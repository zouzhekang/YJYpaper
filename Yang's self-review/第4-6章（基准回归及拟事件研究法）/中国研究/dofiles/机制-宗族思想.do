*---------------------------------------*
*			机制分析：宗族思想				*
*				  杨景媛		 			*
*				2024.03.03				*
*---------------------------------------*

cd $temp
global Rpath "/Users/yuan/Desktop/论文核查/杨景媛-硕士学位论文调查审核/R语言绘图"


* --> step 1.  数据处理与匹配
// 宗族数据处理
use $dataS/Clan/ChenZhiwu2022EJ_genealogies, clear
	keep citygb pf_c1_1 genealogies pf_c1_1 clan19802009_n provcapital
	rename (citygb pf_c1_1 genealogies clan19802009_n) (city_code population2010 genealogy genealogy_new)
	foreach i of varlist genealogy genealogy_new{
	gen `i'Per = `i'/population2010
	}
	drop genealogy genealogy_new
	order city_code genealogyPer genealogy_newPer
	duplicates drop city_code, force
	merge 1:1 city_code using $dataS/city_merge/cityname
	keep if _merge == 3
	drop _merge provcapital
	order city genea*
	
	tostring population2010, gen(xxx) force
	split xxx, parse(.) generate(gross_population)
	rename gross_population1 population
	drop population2010 xxx gross_population2
	destring population, replace
	
	collapse (mean) genealogyPer genealogy_newPer province_code [fw = population], by(province)
	
	sum genealogyPer, d
	
	rename province Province
	gen province = province_code/10000
save $data/genealogy, replace

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

// 匹配进宗族数据
use temp_pseudo, clear

merge m:1 province using $data/genealogy
keep if _merge == 3
drop _merge 
xtset id year
drop if province == 11 | province == 12 | province == 31 | province == 50

save forclan, replace

* --> step 2.  开始跑回归
	//宗族思想较强
	use forclan, clear
	reghdfe dv1 T_45 T_23 T12 T34 T56 T78 T910 if genealogyPer >= 0.4 , a(birthy edu1 UR) 
	est sto m1    
	parmest, saving("ols_estimate.dta", replace) format(estimate %8.3f std %8.3f t %8.3f) level(90)
	use ols_estimate, clear
	keep parm estimate min90 max90
	gen 分类 = "宗族文化较强地区"
	replace parm = "T_1" if parm == "_cons"
	replace estimate = 0 if parm == "T_1"
	replace min90 = 0 if parm == "T_1"
	replace max90 = 0 if parm == "T_1"
	save temp1_1, replace


	//宗族思想较弱
	use forclan, clear
	reghdfe dv1 T_45 T_23 T12 T34 T56 T78 T910 if genealogyPer < 0.4  , a(birthy edu1 UR) 
	est sto m2    
	parmest, saving("ols_estimate.dta", replace) format(estimate %8.3f std %8.3f t %8.3f) level(90)
	use ols_estimate, clear
	keep parm estimate min90 max90
	gen 分类 = "宗族文化较弱地区"
	replace parm = "T_1" if parm == "_cons"
	replace estimate = 0 if parm == "T_1"
	replace min90 = 0 if parm == "T_1"
	replace max90 = 0 if parm == "T_1"
	save temp2_1, replace


	append using temp1_1		
	
export delimited using "$Rpath/中国/4. 宗族思想/clan_es.csv",replace

// 分头胎性别
	use forclan, clear
	reghdfe dv1 T_45 T_23 T12 T34 T56 T78 T910 if genealogyPer >= 0.4 & firstboy == 1, a(province birthy edu1 UR) 
	est sto m1    
	parmest, saving("ols_estimate.dta", replace) format(estimate %8.3f std %8.3f t %8.3f) level(90)
	use ols_estimate, clear
	keep parm estimate min90 max90
	gen 分类 = "宗族文化较强地区"
	gen 头胎性别 = "男"
	replace parm = "T_1" if parm == "_cons"
	replace estimate = 0 if parm == "T_1"
	replace min90 = 0 if parm == "T_1"
	replace max90 = 0 if parm == "T_1"
	save temp1, replace

	use forclan, clear
	reghdfe dv1 T_45 T_23 T12 T34 T56 T78 T910 if genealogyPer >= 0.4 & firstboy == 0, a(birthy edu1 UR) 
	est sto m1    
	parmest, saving("ols_estimate.dta", replace) format(estimate %8.3f std %8.3f t %8.3f) level(90)
	use ols_estimate, clear
	keep parm estimate min90 max90
	gen 分类 = "宗族文化较强地区"
	gen 头胎性别 = "女"
	replace parm = "T_1" if parm == "_cons"
	replace estimate = 0 if parm == "T_1"
	replace min90 = 0 if parm == "T_1"
	replace max90 = 0 if parm == "T_1"
	save temp2, replace

	
	//宗族思想较弱
	use forclan, clear
	reghdfe dv1 T_45 T_23 T12 T34 T56 T78 T910 if genealogyPer < 0.4 & firstboy == 1, a(birthy edu1 UR) 
	est sto m1    
	parmest, saving("ols_estimate.dta", replace) format(estimate %8.3f std %8.3f t %8.3f) level(90)
	use ols_estimate, clear
	keep parm estimate min90 max90
	gen 分类 = "宗族文化较弱地区"
	gen 头胎性别 = "男"
	replace parm = "T_1" if parm == "_cons"
	replace estimate = 0 if parm == "T_1"
	replace min90 = 0 if parm == "T_1"
	replace max90 = 0 if parm == "T_1"
	save temp3, replace

	use forclan, clear
	reghdfe dv1 T_45 T_23 T12 T34 T56 T78 T910 if genealogyPer < 0.4 & firstboy == 0, a(birthy edu1 UR) 
	est sto m1    
	parmest, saving("ols_estimate.dta", replace) format(estimate %8.3f std %8.3f t %8.3f) level(90)
	use ols_estimate, clear
	keep parm estimate min90 max90
	gen 分类 = "宗族文化较弱地区"
	gen 头胎性别 = "女"
	replace parm = "T_1" if parm == "_cons"
	replace estimate = 0 if parm == "T_1"
	replace min90 = 0 if parm == "T_1"
	replace max90 = 0 if parm == "T_1"
	save temp4, replace

	append using temp3
	append using temp2
	append using temp1
	
	
	
export delimited using "$Rpath/中国/4. 宗族思想/clan_es_firstsex.csv",replace






















