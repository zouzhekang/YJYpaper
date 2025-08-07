*---------------------------------------*
*				  基准回归	  			*
*				pooled reg   			*
*				   杨景媛		 		*
*				2023.12.22				*
*---------------------------------------*


cd $temp

/*
备注：
	- 本文件回归结果对应如下：
	- 输出文件夹中的table1.rtf对应正文中的表5.1
	- 输出文件夹中的table2_1/table2_2/table2_3对应正文中表5.2的面板A/B/C
*/


*------------------------------ *
* --—--->  简单描述回归  <------- *
*------------------------------ *
// 样本量
* 1990:10,582
* 2000:9,177
* 2010:11,459

* —->  Table1  <--- *
{
est drop *
* --> 1990年数据
use $data/MarriedFemale1990, clear
reghdfe dv1 fertility2, a(province edu1 birthy sedu1) vce(robust)
	est sto all1990
reghdfe dv1 fertility2 if UR== 1, a(province edu1 birthy sedu1) vce(robust)
	est sto all1990U
reghdfe dv1 fertility2 if UR== 2, a(province edu1 birthy sedu1) vce(robust)
	est sto all1990R
esttab all1990*, keep(fertility2) star(* 0.1 ** 0.05 *** 0.01)

* --> 2000年数据
use $data/MarriedFemale2000, clear
reghdfe dv1 fertility2, a(province edu1 birthy sedu1) vce(robust)
	est sto all2000
reghdfe dv1 fertility2 if UR== 1, a(province edu1 birthy sedu1) vce(robust)
	est sto all2000U
reghdfe dv1 fertility2 if UR== 2, a(province edu1 birthy sedu1) vce(robust)
	est sto all2000R
esttab all2000*, keep(fertility2) star(* 0.1 ** 0.05 *** 0.01)

* --> 2010年数据
use $data/MarriedFemale2010, clear
reghdfe dv1 fertility2, a(province edu1 birthy sedu1) vce(robust)
	est sto all2010
reghdfe dv1 fertility2 if UR== 1, a(province edu1 birthy sedu1) vce(robust)
	est sto all2010U
reghdfe dv1 fertility2 if UR== 2, a(province edu1 birthy sedu1) vce(robust)
	est sto all2010R
esttab all2010*, keep(fertility2) star(* 0.1 ** 0.05 *** 0.01)

esttab all1990* all2000* all2010* using $output/table1.rtf, replace keep(fertility*) star(* 0.1 ** 0.05 *** 0.01)
}

* —->  Table2  <--- *
{
* --> 1990 年
use $data/MarriedFemale1990, clear
est drop *
// 区分生育是否完成（以40岁为分界点）
reghdfe dv1 fertility2 if birthed == 1, a(province edu1 birthy sedu1) vce(robust)
	est sto birthed1990
reghdfe dv1 fertility2 if birthed == 1 & UR== 1, a(province edu1 birthy sedu1) vce(robust)
	est sto birthed1990U
reghdfe dv1 fertility2 if birthed == 1 & UR== 2, a(province edu1 birthy sedu1) vce(robust)
	est sto birthed1990R
reghdfe dv1 fertility2 if birthed == 0, a(province edu1 birthy sedu1) vce(robust)
	est sto birthing1990
reghdfe dv1 fertility2 if birthed == 0 & UR== 1, a(province edu1 birthy sedu1) vce(robust)
	est sto birthing1990U
reghdfe dv1 fertility2 if birthed == 0 & UR== 2, a(province edu1 birthy sedu1) vce(robust)
	est sto birthing1990R
esttab birth*1990*, keep(fertility2) star(* 0.1 ** 0.05 *** 0.01)

esttab birth*1990* using $output/table2_1.rtf, replace keep(fertility2) star(* 0.1 ** 0.05 *** 0.01)

* --> 2000 年
use $data/MarriedFemale2000, clear
gen lchild_age = 2000 - lchild_birthy
drop if lchild_age < 0

gen already = 1 if lchild_age > 12
	replace already = 0 if lchild_age <= 12

// 生育已完成（最小的孩子已经13岁了）
est drop *
reghdfe dv1 fertility2 if already == 1, a(province edu1 birthy sedu1) vce(robust)
est sto m1
reghdfe dv1 fertility2 if already == 1 & UR == 1, a(province edu1 birthy sedu1) vce(robust)   //城镇
est sto m2
reghdfe dv1 fertility2 if already == 1 & UR == 2, a(province edu1 birthy sedu1) vce(robust)   //乡村
est sto m3
// 生育未完成（最小的孩子还小于13岁）
reghdfe dv1 fertility2 if already == 0, a(province edu1 birthy sedu1) vce(robust)
est sto m4
reghdfe dv1 fertility2 if already == 0 & UR == 1, a(province edu1 birthy sedu1) vce(robust)   //城镇
est sto m5
reghdfe dv1 fertility2 if already == 0 & UR == 2, a(province edu1 birthy sedu1) vce(robust)   //乡村
est sto m6

esttab m*, keep(fertility2) star(* 0.1 ** 0.05 *** 0.01)

esttab m* using $output/table2_2.rtf, replace keep(fertility2) star(* 0.1 ** 0.05 *** 0.01)

* --> 2010 年
use $data/MarriedFemale2010, clear
gen lchild_age = 2010 - lchild_birthy
drop if lchild_age < 0

gen already = 1 if lchild_age > 12
	replace already = 0 if lchild_age <= 12

// 生育已完成（最小的孩子已经13岁了）
est drop *
reghdfe dv1 fertility2 if already == 1, a(province edu1 birthy sedu1) vce(robust)
est sto m1
reghdfe dv1 fertility2 if already == 1 & UR == 1, a(province edu1 birthy sedu1) vce(robust)   //城镇
est sto m2
reghdfe dv1 fertility2 if already == 1 & UR == 2, a(province edu1 birthy sedu1) vce(robust)   //乡村
est sto m3
// 生育未完成（最小的孩子还小于13岁）
reghdfe dv1 fertility2 if already == 0, a(province edu1 birthy sedu1) vce(robust)
est sto m4
reghdfe dv1 fertility2 if already == 0 & UR == 1, a(province edu1 birthy sedu1) vce(robust)   //城镇
est sto m5
reghdfe dv1 fertility2 if already == 0 & UR == 2, a(province edu1 birthy sedu1) vce(robust)   //乡村
est sto m6

esttab m*, keep(fertility2) star(* 0.1 ** 0.05 *** 0.01)

esttab m* using $output/table2_3.rtf, replace keep(fertility2) star(* 0.1 ** 0.05 *** 0.01)
}























