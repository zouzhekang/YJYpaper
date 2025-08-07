*---------------------------------------*
*		数据处理-Pseudo Panel Data		*
*				  cell		 			*
*				  杨景媛		 			*
*				2023.12.23				*
*---------------------------------------*


/*
备注：
	- 分组变量的选择：省份｜城乡｜受教育程度｜年龄分组（31*2*3*5）
	  样本量大概是180左右，不能用work/income这种会受到生育影响的bad control来分组
	  再进一步分组的话，可以按照配偶受教育程度情况来分组（高于-低于-相等）样本量就为360啦
	- 如果可以的话，可以考虑按照district来匹配（前提是三次的district码对的上）
	- Question:要不要拿男性样本作对照？想了想不要了，Kleven那篇看的是child penalty，对照组是男性，我这里看的是fertility的影响，对照组应该是生育较少的女性。
*/

/*
备注：
	- 本文件回归结果对应如下：
	- 输出文件夹中的table3.rtf对应正文中的表5.3
*/

cd $temp

* --> 1990年数据
use $data/MarriedFemale1990, clear

unite province UR edu1 age_group, gen(mergekey) sep()
save temp, replace

use temp, clear
collapse (count) UR, by(mergekey)
rename UR count
save temp1, replace

use temp, clear
collapse (mean) dv1 dv2 childnum fertility fertility1 fertility2 province UR edu1 age_group, by(mergekey)
merge 1:1 mergekey using temp1
drop _merge

gen year = 1990
save pseudo1990, replace

* --> 2000年数据
use $data/MarriedFemale2000, clear

replace age_group = age_group + 10
	
unite province UR edu1 age_group, gen(mergekey) sep()
save temp, replace

bysort mergekey : egen count = count(UR)
sort count province UR

use temp, clear
collapse (count) UR, by(mergekey)
rename UR count
save temp1, replace

use temp, clear
collapse (mean) dv1 dv2 childnum fertility fertility1 fertility2 province UR edu1 age_group, by(mergekey)
merge 1:1 mergekey using temp1
drop _merge

gen year = 2000
save pseudo2000, replace


* --> 2010年数据
use $data/MarriedFemale2010, clear
	
replace age_group = age_group + 20

unite province UR edu1 age_group, gen(mergekey) sep()
save temp, replace

use temp, clear
collapse (count) UR, by(mergekey)
rename UR count
save temp1, replace

use temp, clear
collapse (mean) dv1 dv2 childnum fertility fertility1 fertility2 province UR edu1 age_group, by(mergekey)
merge 1:1 mergekey using temp1
drop _merge

gen year = 2010
save pseudo2010, replace


* --> pseudo panel data
use pseudo1990, clear
	append using pseudo2000
	append using pseudo2010

encode mergekey, gen(kkk)
xtset kkk year

drop if count <= 15

est drop *

qui reghdfe dv1 fertility2 [fweight = count], absorb(province year age_group UR edu1) vce(cluster province)
est sto pseudo_all_unbalanced
qui reghdfe dv1 fertility2 [fweight = count] if UR == 1, absorb(province year age_group edu1) vce(cluster province)
est sto pseudo_U_unbalanced
qui reghdfe dv2 fertility2 [fweight = count] if UR == 2, absorb(province year age_group edu1) vce(cluster province)
est sto pseudo_R_unbalanced

esttab pseudo_*_unbalanced, keep(fertility*) star(* 0.1 ** 0.05 *** 0.01)

keep if age_group == 3 | age_group == 4 | age_group == 5  // balanced panel data
xtset kkk year
qui reghdfe dv1 fertility2 [fweight = count], absorb(province year age_group UR edu1) vce(cluster province)
est sto pseudo_all_balanced
qui reghdfe dv1 fertility2 [fweight = count] if UR == 1, absorb(province year age_group edu1) vce(cluster province)
est sto pseudo_U_balanced
qui reghdfe dv2 fertility2 [fweight = count] if UR == 2, absorb(province year age_group edu1) vce(cluster province)
est sto pseudo_R_balanced

esttab pseudo_*_balanced, keep(fertility*) star(* 0.1 ** 0.05 *** 0.01)


esttab pseudo_* using $output/table3.rtf, replace keep(fertility*) star(* 0.1 ** 0.05 *** 0.01)
























































