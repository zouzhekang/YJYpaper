*---------------------------------------*
*			机制分析：母职惩罚				*
*				  杨景媛		 			*
*				2024.03.03				*
*---------------------------------------*

cd $temp
global Rpath "/Users/yuan/Desktop/论文核查/杨景媛-硕士学位论文调查审核/R语言绘图"



* --> 数据1:Huang et al(2023, J Pop E)

import excel $dataS/ChildPenalty/Huang_et_al2023.xlsx, firstrow clear
// histogram CP0005
// histogram CP0005


save $data/CP_Huang2023, replace

// 2000年数据
use $data/MarriedFemale2000, clear
decode province, gen(省份)

merge m:1 省份 using $data/CP_Huang2023
	keep if _merge == 3
	drop _merge 


* --> 数据2:自己算的！！！
use $dataS/ChildPenalty/province_cp, clear
drop province
rename prov province
drop if province == 11 | province == 12 | province == 31 | province == 50
// drop if cp < 0
// histogram cp
sum cp, d  //中位数0.0939

gen Hcp = 1 if cp >= 0.029
	replace Hcp = 0 if cp < 0.029
save $data/CP0005, replace


*=======================================*
*				事件研究法				*
*=======================================*
use $data/reshaped_pseudo_panel, clear

keep if T >= -5 & T <= 10

gen T_45 = 0
	replace T_45 = 1 if T <= -4
gen T_23 = 0
	replace T_23 = 1 if T == -3 | T == -2
gen T_01 = 0
	replace T_01 = 1 if T == 0 | T == 1

gen T12 = 0
	replace T12 = 1 if T == 1 | T == 2
gen T34 = 0
	replace T34 = 1 if T == 3 | T == 4
gen T56 = 0
	replace T56 = 1 if T == 5 | T == 6
gen T78 = 0
	replace T78 = 1 if T == 7 | T == 8	
gen T910 = 0
	replace T910 = 1 if T == 9 | T == 10

save temp_pseudo, replace


// 开始回归
use temp_pseudo, clear
merge m:1 province using $data/CP0005
keep if _merge == 3
xtset id year
save temp, replace


// 高母职惩罚
use temp, clear
keep if Hcp == 1
reghdfe dv1 T_45 T_23 T12 T34 T56 T78 T910 , a(province birthy UR edu1) 
est sto m1
parmest, saving("ols_estimate.dta", replace) format(estimate %8.3f std %8.3f t %8.3f) level(90)
use ols_estimate, clear
keep parm estimate min90 max90
gen 分类 = "高母职惩罚地区"
replace parm = "T_1" if parm == "_cons"
replace estimate = 0 if parm == "T_1"
replace min90 = 0 if parm == "T_1"
replace max90 = 0 if parm == "T_1"
save temp1, replace



// 低母职惩罚
use temp, clear
keep if Hcp == 0
reghdfe dv1 T_45 T_23 T12 T34 T56 T78 T910 , a(province birthy UR edu1) 
est sto m2    
parmest, saving("ols_estimate.dta", replace) format(estimate %8.3f std %8.3f t %8.3f) level(90)
use ols_estimate, clear
keep parm estimate min90 max90
gen 分类 = "低母职惩罚地区"
replace parm = "T_1" if parm == "_cons"
replace estimate = 0 if parm == "T_1"
replace min90 = 0 if parm == "T_1"
replace max90 = 0 if parm == "T_1"
save temp2, replace

append using temp1

export delimited using "$Rpath/中国/2. 母职惩罚/cp_es.csv",replace



coefplot m1 m2, keep(T*) vertical ciopts(recast(rcap)) s(plotplain) 





