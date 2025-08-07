*---------------------------------------*
*			Pseudo Panel Data			*
*				  micro		 			*
*				  杨景媛		 			*
*				2024.03.02				*
*---------------------------------------*

cd $temp
global Rpath "/Users/yuan/Desktop/论文核查/杨景媛-硕士学位论文调查审核/R语言绘图"

* --> step 1：数据处理
// 先处理1990年数据
use $data/MarriedFemale1990, clear
keep if fertility == 0 & fchild_birthy == .
keep UR province birthy edu fchild_birthy dv1
gen edu1 = 1 if edu <=4
	replace edu1 = 2 if edu > 4
// 	label define edu1 1 "低级" 2 "高级"
	label values edu1 edu1
	label variable edu1 "受教育程度-粗分类"
rename (fchild_birthy dv1)(fchild_birthy1990 dv11990)
collapse (mean) fchild_birthy1990 dv11990, by(birthy province UR edu1)

save $data/processed1990, replace

// 再处理一下2000年数据
use $data/MarriedFemale2000, clear
// keep if fertility == 1
drop if fchild_birthy ==  .
gen id = _n
keep UR province birthy edu1 fchild_birthy dv1 id childnum firstboy
drop if fchild_birthy <= 1990 | fchild_birthy > 2000
rename (fchild_birthy dv1)(fchild_birthy2000 dv12000)


// 匹配并生成T
merge m:1 birthy province UR edu using $data/processed1990
	keep if _merge == 3
	drop _merge 

gen T1990 = 1990 - fchild_birthy2000
gen T2000 = 2000 - fchild_birthy2000
replace T2000 = -1 if fchild_birthy2000 == .

reshape long dv1 fchild_birthy T, i(id) j(year)

save $data/reshaped_pseudo_panel, replace

* --> step 2：准备回归
use $data/reshaped_pseudo_panel, clear

keep if T >= -5 & T <= 10

gen T_45 = 0
	replace T_45 = 1 if T <= -4
gen T_23 = 0
	replace T_23 = 1 if T == -3 | T == -2
gen T_01 = 0
	replace T_01 = 1 if T == 0 | T == -1

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

	xtset id year
save temp_pseudo, replace


* --> step 3：开始回归
//全样本
use temp_pseudo, clear
reghdfe dv1 T_45 T_23 T12 T34 T56 T78 T910, a(province birthy UR edu1) 
est sto m1    // drop掉的怀孕的那一期
coefplot m1, keep(T*) vertical
parmest, saving("ols_estimate.dta", replace) format(estimate %8.3f std %8.3f t %8.3f) level(90)
use ols_estimate, clear
keep parm estimate min90 max90
gen 分类 = "全样本"
replace parm = "T_1" if parm == "_cons"
replace estimate = 0 if parm == "T_1"
replace min90 = 0 if parm == "T_1"
replace max90 = 0 if parm == "T_1"
save temp, replace

export delimited using "$Rpath/中国/1. 整体样本/all_es.csv",replace


//城镇样本
use temp_pseudo, clear
reghdfe dv1 T_45 T_23 T12 T34 T56 T78 T910 if UR == 1, a(province birthy edu1)   // 城市
est sto m2   // drop掉的怀孕的那一期
parmest, saving("ols_estimate.dta", replace) format(estimate %8.3f std %8.3f t %8.3f) level(90)
use ols_estimate, clear
keep parm estimate min90 max90
gen 分类 = "城镇"
replace parm = "T_1" if parm == "_cons"
replace estimate = 0 if parm == "T_1"
replace min90 = 0 if parm == "T_1"
replace max90 = 0 if parm == "T_1"
save temp1, replace


//农村样本
use temp_pseudo, clear
reghdfe dv1 T_45 T_23 T12 T34 T56 T78 T910 if UR == 2, a(province birthy edu1)   // 乡村
est sto m3   // drop掉的怀孕的那一期
parmest, saving("ols_estimate.dta", replace) format(estimate %8.3f std %8.3f t %8.3f) level(90)
use ols_estimate, clear
keep parm estimate min90 max90
gen 分类 = "乡村"
replace parm = "T_1" if parm == "_cons"
replace estimate = 0 if parm == "T_1"
replace min90 = 0 if parm == "T_1"
replace max90 = 0 if parm == "T_1"
save temp2, replace

append using temp1

export delimited using "$Rpath/中国/1. 整体样本/UR_es.csv",replace



use temp_pseudo, clear
reghdfe dv1 T_45 T_23 T12 T34 T56 T78 T910, a(province birthy UR edu1) 
est sto m1    // drop掉的怀孕的那一期
use temp_pseudo, clear
reghdfe dv1 T_45 T_23 T12 T34 T56 T78 T910 if UR == 1, a(province birthy edu1)   // 城市
est sto m2  
use temp_pseudo, clear
reghdfe dv1 T_45 T_23 T12 T34 T56 T78 T910 if UR == 2, a(province birthy edu1)   // 乡村
est sto m3   // drop掉的怀孕的那一期


esttab m1 m2 m3 , keep(T*) star(* 0.1 ** 0.05 *** 0.01)   

esttab m1 m2 m3 using $output/table6_1.rtf, replace keep(T*) star(* 0.1 ** 0.05 *** 0.01)  


































