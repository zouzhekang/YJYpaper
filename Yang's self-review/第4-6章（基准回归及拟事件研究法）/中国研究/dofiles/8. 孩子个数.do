*---------------------------------------*
*				  Chilnum	  			*
*				哪一胎影响最大	   			*
*				   杨景媛		 		*
*			修正版本 2025.01.09			*
*---------------------------------------*
* 修正说明：将二元因变量的线性回归改为logistic回归
* 原问题：dv1是二元变量，使用reghdfe违反统计学基本假设


cd $temp

* —->  TableX  <--- *
// 哪一胎的影响最大？
est drop *
use $data/MarriedFemale1990, clear
replace childnum = 6 if childnum >= 6
logit dv1 i.childnum i.province i.edu1 i.UR i.birthy i.sedu1, vce(cluster province)
est sto m1990

use $data/MarriedFemale2000, clear
replace childnum = 6 if childnum >= 6
logit dv1 i.childnum i.province i.edu1 i.UR i.birthy i.sedu1, vce(cluster province)
est sto m2000

use $data/MarriedFemale2010, clear
replace childnum = 6 if childnum >= 6
logit dv1 i.childnum i.province i.edu1 i.UR i.birthy i.sedu1, vce(cluster province)
est sto m2010

coefplot m1990 m2000 m2010, drop(_cons) vertical  ///
  ciopts(recast(rcap)) 

* 输出为CSV格式
clear
// 1990
use $data/MarriedFemale1990, clear
replace childnum = 6 if childnum >= 6
logit dv1 i.childnum i.province i.edu1 i.birthy i.sedu1, vce(cluster province)
outreg2 using $R/childnum/myfile1990, replace nonote noaster  stats(coef ci)  
seeout

import delimited $R/childnum/myfile1990.txt, clear 
gen xxx = v2 if v1 == ""
split xxx, parse(-) generate(newv)

gen low = subinstr(newv1, "(", "", .)
gen high = subinstr(newv2, ")", "", .)
keep v1 v2 low high
gen id = _n 
drop if id <= 3 | id >= 16
drop id
rename (v2 low high)(coef1990 low1990 high1990)
export delimited using $R/childnum/forR1990.csv, replace


// 2000
use $data/MarriedFemale2000, clear
replace childnum = 6 if childnum >= 6
logit dv1 i.childnum i.province i.edu1 i.birthy i.sedu1, vce(cluster province)
outreg2 using $R/childnum/myfile2000, replace nonote noaster  stats(coef ci) 
seeout

import delimited $R/childnum/myfile2000.txt, clear 
gen xxx = v2 if v1 == ""
split xxx, parse(" - ") generate(newv)

gen low = subinstr(newv1, "(", "", .)
gen high = subinstr(newv2, ")", "", .)
keep v1 v2 low high
gen id = _n 
drop if id <= 3 | id >= 16
drop id
rename (v2 low high)(coef2000 low2000 high2000)

export delimited using $R/childnum/forR2000.csv, replace


// 2010
use $data/MarriedFemale2010, clear
replace childnum = 6 if childnum >= 6
logit dv1 i.childnum i.province i.edu1 i.UR i.birthy i.sedu1, vce(cluster province)
outreg2 using $R/childnum/myfile2010, replace nonote noaster  stats(coef ci) 
seeout

import delimited $R/childnum/myfile2010.txt, clear 
gen xxx = v2 if v1 == ""
split xxx, parse(" - ") generate(newv)

gen low = subinstr(newv1, "(", "", .)
gen high = subinstr(newv2, ")", "", .)
keep v1 v2 low high
gen id = _n 
drop if id <= 3 | id >= 16
drop id
rename (v2 low high)(coef2010 low2010 high2010)

export delimited using $R/childnum/forR2010.csv, replace














