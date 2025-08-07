*---------------------------------------*
*				描述性统计				*
*				  杨景媛		 			*
*				2023.12.17				*
*---------------------------------------*

cd $temp

*----------------------------- *
* --—--->  生育与就业  <-------  *
*----------------------------- *
use $data/MarriedFemale1990, clear
	graph bar (mean) work, over(fertility1, label(labsize(vsmall)))	///
		by(UR, note(" "))  ///
		scheme(plotplain)  ///
		ytitle("平均就业率") ///
		name(fertility_work1990, replace) ///
		title("1990年数据")
		
use $data/MarriedFemale2000, clear
	graph bar (mean) work, over(fertility1, label(labsize(vsmall)))	///
		by(UR, note(" "))  ///
		scheme(plotplain)  ///
		ytitle("平均就业率") ///
		name(fertility_work2000, replace) ///
		title("2000年数据")
	
use $data/MarriedFemale2010, clear
	graph bar (mean) work, over(fertility1, label(labsize(vsmall)))	///
		by(UR, note("按照城乡进行分组"))  ///
		scheme(plotplain)  ///
		ytitle("平均就业率") ///
		name(fertility_work2010, replace) ///
		title("2010年数据")

use $data/pooled, clear
	graph bar (mean) work, over(fertility1, label(labsize(vsmall)))	///
		by(UR, note(" "))  ///
		scheme(plotplain)  ///
		ytitle("平均就业率") ///
		name(fertility_work, replace) ///
		title("1990-2010年混合数据")

graph combine fertility_work1990 fertility_work2000 fertility_work2010 fertility_work, cols(2) scheme(plotplain) 
		

*----------------------------- *
* --—--->  年龄组与家暴  <------ *
*----------------------------- *
		
use $data/MarriedFemale1990, clear
	graph bar (mean) dv1, over(age_group, label(labsize(vsmall)))	///
		by(UR, note(" "))  ///
		scheme(plotplain)  ///
		ytitle("平均家暴发生率") ///
		name(age_dv1990, replace) ///
		title("1990年数据")
		
use $data/MarriedFemale2000, clear
	graph bar (mean) dv1, over(age_group, label(labsize(vsmall)))	///
		by(UR, note(" "))  ///
		scheme(plotplain)  ///
		ytitle("平均家暴发生率") ///
		name(age_dv2000, replace) ///
		title("2000年数据")
	
use $data/MarriedFemale2010, clear
	graph bar (mean) dv1, over(age_group, label(labsize(vsmall)))	///
		by(UR, note("按照城乡进行分组"))  ///
		scheme(plotplain)  ///
		ytitle("平均家暴发生率") ///
		name(age_dv2010, replace) ///
		title("2010年数据")

use $data/pooled, clear
	graph bar (mean) dv1, over(age_group, label(labsize(vsmall)))	///
		by(UR, note(" "))  ///
		scheme(plotplain)  ///
		ytitle("平均家暴发生率") ///
		name(age_dv, replace) ///
		title("1990-2010年混合数据")

graph combine age_dv1990 age_dv2000 age_dv2010 age_dv, cols(2)	scheme(plotplain) 	
		
		
*----------------------------- *
* --—--->  受教育与家暴  <------ *
*----------------------------- *
		
use $data/MarriedFemale1990, clear
	graph bar (mean) dv1, over(edu1, label(labsize(vsmall)))	///
		by(UR, note(" "))  ///
		scheme(plotplain)  ///
		ytitle("平均家暴发生率") ///
		name(edu_dv1990, replace) ///
		title("1990年数据")
		
use $data/MarriedFemale2000, clear
	graph bar (mean) dv1, over(edu1, label(labsize(vsmall)))	///
		by(UR, note(" "))  ///
		scheme(plotplain)  ///
		ytitle("平均家暴发生率") ///
		name(edu_dv2000, replace) ///
		title("2000年数据")
	
use $data/MarriedFemale2010, clear
	graph bar (mean) dv1, over(edu1, label(labsize(vsmall)))	///
		by(UR, note("按城乡分组；受教育程度依次为：低级、中级、高级"))  ///
		scheme(plotplain)  ///
		ytitle("平均家暴发生率") ///
		name(edu_dv2010, replace) ///
		title("2010年数据")

use $data/pooled, clear
	graph bar (mean) dv1, over(edu1, label(labsize(vsmall)))	///
		by(UR, note(" "))  ///
		scheme(plotplain)  ///
		ytitle("平均家暴发生率") ///
		name(edu_dv, replace) ///
		title("1990-2010年混合数据")

graph combine edu_dv1990 edu_dv2000 edu_dv2010 edu_dv, cols(2)	scheme(plotplain) 	
		

*----------------------------- *
* ----> 相对受教育程度与家暴 <---- *
*----------------------------- *

use $data/MarriedFemale1990, clear
gen xx = sedu1-edu1
gen edudiff = -1 if xx < 0
	replace edudiff = 0 if xx == 0
	replace edudiff = 1 if xx > 0	
	label define edudiff -1 "高于配偶" 0 "等于配偶" 1 "低于配偶" 
	label values edudiff edudiff
	label variable edudiff "和配偶的受教育水平差异"		

	graph bar (mean) dv1, over(edudiff, label(labsize(vsmall)))	///
		by(UR, note(" "))  ///
		scheme(plotplain)  ///
		ytitle("平均家暴发生率") ///
		name(edudiff_dv1990, replace) ///
		title("1990年数据")

use $data/MarriedFemale2000, clear
gen xx = sedu1-edu1
gen edudiff = -1 if xx < 0
	replace edudiff = 0 if xx == 0
	replace edudiff = 1 if xx > 0	
	label define edudiff -1 "高于配偶" 0 "等于配偶" 1 "低于配偶" 
	label values edudiff edudiff
	label variable edudiff "和配偶的受教育水平差异"		

	graph bar (mean) dv1, over(edudiff, label(labsize(vsmall)))	///
		by(UR, note(" "))  ///
		scheme(plotplain)  ///
		ytitle("平均家暴发生率") ///
		name(edudiff_dv2000, replace) ///
		title("2000年数据")

use $data/MarriedFemale2010, clear
gen xx = sedu1-edu1
gen edudiff = -1 if xx < 0
	replace edudiff = 0 if xx == 0
	replace edudiff = 1 if xx > 0	
	label define edudiff -1 "高于配偶" 0 "等于配偶" 1 "低于配偶" 
	label values edudiff edudiff
	label variable edudiff "和配偶的受教育水平差异"		

	graph bar (mean) dv1, over(edudiff, label(labsize(vsmall)))	///
		by(UR, note("按照城乡进行分组"))  ///
		scheme(plotplain)  ///
		ytitle("平均家暴发生率") ///
		name(edudiff_dv2010, replace) ///
		title("2010年数据")
	
use $data/pooled, clear
gen xx = sedu1-edu1
gen edudiff = -1 if xx < 0
	replace edudiff = 0 if xx == 0
	replace edudiff = 1 if xx > 0	
	label define edudiff -1 "高于配偶" 0 "等于配偶" 1 "低于配偶" 
	label values edudiff edudiff
	label variable edudiff "和配偶的受教育水平差异"		

	graph bar (mean) dv1, over(edudiff, label(labsize(vsmall)))	///
		by(UR, note(" "))  ///
		scheme(plotplain)  ///
		ytitle("平均家暴发生率") ///
		name(edudiff_dv, replace) ///
		title("1990-2010年混合数据")
	
graph combine edudiff_dv1990 edudiff_dv2000 edudiff_dv2010 edudiff_dv, cols(2) scheme(plotplain) 		

		
*----------------------------- *
* ----> 相对收入水平与家暴 <----- *
*----------------------------- *
use $data/MarriedFemale1990, clear
	graph bar (mean) dv1, over(rela_inc, label(labsize(vsmall)))	///
		by(UR, note(" "))  ///
		caption("	妻子收入/丈夫收入")   ///
		scheme(plotplain)  ///
		ytitle("平均家暴发生率") ///
		name(relainc_dv1990, replace) ///
		title("1990年数据")
		
use $data/MarriedFemale2000, clear
	graph bar (mean) dv1, over(rela_inc, label(labsize(vsmall)))	///
		by(UR, note(" "))  ///
		caption("	妻子收入/丈夫收入")   ///
		scheme(plotplain)  ///
		ytitle("平均家暴发生率") ///
		name(relainc_dv2000, replace) ///
		title("2000年数据")
	
use $data/MarriedFemale2010, clear
	graph bar (mean) dv1, over(rela_inc, label(labsize(vsmall)))	///
		by(UR, note("按照城乡进行分组"))  ///
		caption("	妻子收入/丈夫收入")   ///
		scheme(plotplain)  ///
		ytitle("平均家暴发生率") ///
		name(relainc_dv2010, replace) ///
		title("2010年数据")

use $data/pooled, clear
	graph bar (mean) dv1, over(rela_inc, label(labsize(vsmall)))	///
		by(UR, note(" "))  ///
		caption("	妻子收入/丈夫收入")   ///
		scheme(plotplain)  ///
		ytitle("平均家暴发生率") ///
		name(relainc_dv, replace) ///
		title("1990-2010年混合数据")

graph combine relainc_dv1990 relainc_dv2000 relainc_dv2010 relainc_dv, cols(2) scheme(plotplain) 	
		
	
use $data/pooled, clear
collapse (mean) relative_inc, by(UR year)
twoway(line relative_inc year if UR == 2)(line relative_inc year if UR == 1), scheme(plotplain) 	


*----------------------------- *
* ----> 生育情况与是否家暴 <----- *
*----------------------------- *
use $data/MarriedFemale1990, clear
	graph bar (mean) dv1, over(fertility1, label(labsize(vsmall)))	///
		by(UR, note(" "))  ///
		scheme(plotplain)  ///
		ytitle("平均家暴发生率") ///
		name(fertility_dv1990, replace) ///
		title("1990年数据")
		
use $data/MarriedFemale2000, clear
	graph bar (mean) dv1, over(fertility1, label(labsize(vsmall)))	///
		by(UR, note(" "))  ///
		scheme(plotplain)  ///
		ytitle("平均家暴发生率") ///
		name(fertility_dv2000, replace) ///
		title("2000年数据")
	
use $data/MarriedFemale2010, clear
	graph bar (mean) dv1, over(fertility1, label(labsize(vsmall)))	///
		by(UR, note("按照城乡进行分组"))  ///
		scheme(plotplain)  ///
		ytitle("平均家暴发生率") ///
		name(fertility_dv2010, replace) ///
		title("2010年数据")

use $data/pooled, clear
	graph bar (mean) dv1, over(fertility1, label(labsize(vsmall)))	///
		by(UR, note(" "))  ///
		scheme(plotplain)  ///
		ytitle("平均家暴发生率") ///
		name(fertility_dv, replace) ///
		title("1990-2010年混合数据")

graph combine fertility_dv1990 fertility_dv2000 fertility_dv2010 fertility_dv, cols(2)scheme(plotplain) 		

use $data/MarriedFemale2000, clear
collapse dv1 childnum, by(province UR edu1)
twoway(lfitci dv1 childnum, level(90))(scatter dv1 childnum, jitter(5)), scheme(plotplain) 	



*----------------------------- *
* ----> 是否完成生育与家暴 <----- *
*----------------------------- *
use $data/MarriedFemale1990, clear
	graph bar (mean) dv1, over(birthed, label(labsize(vsmall)))	///
		by(UR, note("按照是否满40岁分组"))  ///
		scheme(plotplain)  ///
		ytitle("平均家暴发生率") ///
		name(birthed_dv1990, replace) ///
		title("1990年数据")
		
use $data/MarriedFemale2000, clear
	graph bar (mean) dv1, over(birthed, label(labsize(vsmall)))	///
		by(UR, note("按照最小孩子是否满17分组"))  ///
		scheme(plotplain)  ///
		ytitle("平均家暴发生率") ///
		name(birthed_dv2000, replace) ///
		title("2000年数据")
	
use $data/MarriedFemale2010, clear
	graph bar (mean) dv1, over(birthed, label(labsize(vsmall)))	///
		by(UR, note("按照最小孩子是否满17分组"))  ///
		scheme(plotplain)  ///
		ytitle("平均家暴发生率") ///
		name(birthed_dv2010, replace) ///
		title("2010年数据")

use $data/pooled, clear
	graph bar (mean) dv1, over(birthed, label(labsize(vsmall)))	///
		by(UR, note("是否结束育龄"))  ///
		scheme(plotplain)  ///
		ytitle("平均家暴发生率") ///
		name(birthed_dv, replace) ///
		title("1990-2010年混合数据")

graph combine birthed_dv1990 birthed_dv2000 birthed_dv2010 birthed_dv, cols(2)scheme(plotplain) 		
		

*----------------------------- *
* ----> 头胎是否男孩与家暴 <----- *
*----------------------------- *
use $data/MarriedFemale1990, clear
	graph bar (mean) dv1, over(firstboy, label(labsize(medium)))	///
		by(UR, note(""))  ///
		scheme(plotplain)  ///
		ytitle("平均家暴发生率") ///
		name(firstboy_dv1990, replace) ///
		title("")

ttest dv1 if UR == 1, by(firstboy)
ttest dv1 if UR == 2, by(firstboy)
//
// reghdfe dv1 firstboy if age < 40, a(province edu1 UR birthy)
// reghdfe dv1 firstboy if age < 40 & UR == 1, a(province edu1 birthy)
// reghdfe dv1 firstboy if age < 40 & UR == 2, a(province edu1 birthy)

*----------------------------- *
* ----> 家庭暴力的时间趋势 <----- *
*----------------------------- *

use $data/pooled, clear
collapse (mean) dv1, by(year UR)

export delimited using "/Users/yuan/study/毕业论文- R绘图/绪论/time_trend.csv", replace
twoway(line dv1 year if UR == 1)(line dv1 year if UR == 2), scheme(plotplain) 



*----------------------------- *
* -----> 宗族思想散点图 <------- *
*----------------------------- *
use $data/MarriedFemale2000, clear
merge m:1 province using $data/genealogy
keep if _merge == 3
drop _merge 

collapse (mean) childnum dv1 genealogy_newPer, by(province)
drop if province == 11 | province == 12 | province == 31 | province == 50

twoway ///
(scatter dv1 childnum if genealogy_newPer > 0.04, mlabel(province) mlabpos(12))(lfit dv1 childnum if genealogy_newPer > 0.04)  ///
(scatter dv1 childnum if genealogy_newPer <= 0.04, mlabel(province) mlabpos(12))(lfit dv1 childnum if genealogy_newPer <= 0.04) ,   ///
scheme(plotplain)

*----------------------------- *
* -----> 道家思想散点图 <------- *
*----------------------------- *
use $data/MarriedFemale2000, clear
decode province, gen(省份)
merge m:1 省份 using $data/qing, force
keep if _merge == 3
drop _merge 

collapse (mean) childnum dv1 ave_guan, by(province)
drop if province == 11 | province == 12 | province == 31 | province == 50

twoway ///
(scatter dv1 childnum if ave_guan > 0.02, mlabel(province) mlabpos(12))(lfit dv1 childnum if ave_guan > 0.02)  ///
(scatter dv1 childnum if ave_guan <= 0.02, mlabel(province) mlabpos(12))(lfit dv1 childnum if ave_guan <= 0.02),   ///
scheme(plotplain)




