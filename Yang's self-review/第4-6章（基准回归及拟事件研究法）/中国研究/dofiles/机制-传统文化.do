*---------------------------------------*
*			机制分析：封建思想				*
*				  杨景媛		 			*
*				2024.03.14				*
*---------------------------------------*


cd $temp
global Rpath "/Users/yuan/Desktop/论文核查/杨景媛-硕士学位论文调查审核/R语言绘图"

* --> step1. 数据处理

// 庙观数据
import delimited $dataS/qing/all.csv, clear
drop if province == "山西"
drop if province == "广东"
replace province = "西藏自治区" if province == "西藏"
rename count all
save $data/all, replace

import delimited $dataS/qing/result.csv, clear
drop if province == "山西"
drop if province == "广东"
replace province = "西藏自治区" if province == "西藏"
save $data/qing, replace

// 人口数据
import delimited $dataS/qing/population.csv, clear
save $data/population2022, replace

// 数据匹配与计算
use $data/qing, clear
merge m:1 province using $data/population2022
drop _merge
merge m:1 province using $data/all
drop _merge

gen ave_miao = count/population if religiontype == "佛教"
gen ave_guan = count/population if religiontype == "道教"
gen ave_qing = all/population

collapse (mean) ave_miao ave_guan ave_qing, by(province)

split province, parse("省") gen(省份) 
rename 省份1 省份
replace 省份 = "内蒙" if 省份 == "内蒙古自治区"
replace 省份 = "宁夏" if 省份 == "宁夏回族自治区"
replace 省份 = "广西" if 省份 == "广西壮族自治区"
replace 省份 = "新疆" if 省份 == "新疆维吾尔自治区"
replace 省份 = "西藏" if 省份 == "西藏自治区"
replace 省份 = "上海" if 省份 == "上海市"
replace 省份 = "北京" if 省份 == "北京市"
replace 省份 = "重庆" if 省份 == "重庆市"
replace 省份 = "天津" if 省份 == "天津市"

// histogram ave_miao
// histogram ave_guan
// histogram ave_qing

sum ave_guan, d   //中位数：.0196

save $data/qing, replace


* --> step2. 数据匹配
// event study数据
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

// 匹配进封建数据
use temp_pseudo, clear
decode province, gen(省份)
merge m:1 省份 using $data/qing, force
keep if _merge == 3
drop _merge 
xtset id year
drop if province == 11 
drop if province == 12
drop if province == 31 
drop if province == 50 
save forqing, replace


// 较封建地区
use forqing, clear
reghdfe dv1 T_45 T_23 T12 T34 T56 T78 T910 if ave_guan >= 0.0196, a(birthy UR edu1) // 封建
est sto m1  
parmest, saving("ols_estimate.dta", replace) format(estimate %8.3f std %8.3f t %8.3f) level(90)
use ols_estimate, clear
keep parm estimate min90 max90
gen 分类 = "传统文化盛行地区"
replace parm = "T_1" if parm == "_cons"
replace estimate = 0 if parm == "T_1"
replace min90 = 0 if parm == "T_1"
replace max90 = 0 if parm == "T_1"
save temp1, replace

// 较开放地区
use forqing, clear
reghdfe dv1 T_45 T_23 T12 T34 T56 T78 T910 if ave_guan < 0.0196, a(birthy UR edu1) // 不封建
est sto m2
parmest, saving("ols_estimate.dta", replace) format(estimate %8.3f std %8.3f t %8.3f) level(90)
use ols_estimate, clear
keep parm estimate min90 max90
gen 分类 = "传统文化并不盛行"
replace parm = "T_1" if parm == "_cons"
replace estimate = 0 if parm == "T_1"
replace min90 = 0 if parm == "T_1"
replace max90 = 0 if parm == "T_1"
save temp2, replace

append using temp1

export delimited using "$Rpath/中国/3. 传统文化/tc_es.csv",replace



// esttab m1 m2, keep(T*) star(* 0.1 ** 0.05 *** 0.01)









































