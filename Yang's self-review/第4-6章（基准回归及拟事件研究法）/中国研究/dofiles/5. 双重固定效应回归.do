*---------------------------------------*
*				  基准回归	  			*
*			logistic regression  		*
*				   杨景媛		 		*
*			修正版本 2025.01.09			*
*---------------------------------------*
* 修正说明：将二元因变量的线性回归改为logistic回归
* 原问题：dv1是二元变量，使用reghdfe违反统计学基本假设
* 修正方法：使用logit模型，将固定效应转为控制变量


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
logit dv1 fertility2 i.province i.edu1 i.birthy i.sedu1, vce(robust)
	est sto all1990
	margins, dydx(fertility2) post
	est sto all1990_mfx
logit dv1 fertility2 i.province i.edu1 i.birthy i.sedu1 if UR== 1, vce(robust)
	est sto all1990U
	margins, dydx(fertility2) post
	est sto all1990U_mfx
logit dv1 fertility2 i.province i.edu1 i.birthy i.sedu1 if UR== 2, vce(robust)
	est sto all1990R
	margins, dydx(fertility2) post
	est sto all1990R_mfx
esttab all1990_mfx all1990U_mfx all1990R_mfx, keep(fertility2) star(* 0.1 ** 0.05 *** 0.01)

* --> 2000年数据
use $data/MarriedFemale2000, clear
logit dv1 fertility2 i.province i.edu1 i.birthy i.sedu1, vce(robust)
	est sto all2000
	margins, dydx(fertility2) post
	est sto all2000_mfx
logit dv1 fertility2 i.province i.edu1 i.birthy i.sedu1 if UR== 1, vce(robust)
	est sto all2000U
	margins, dydx(fertility2) post
	est sto all2000U_mfx
logit dv1 fertility2 i.province i.edu1 i.birthy i.sedu1 if UR== 2, vce(robust)
	est sto all2000R
	margins, dydx(fertility2) post
	est sto all2000R_mfx
esttab all2000_mfx all2000U_mfx all2000R_mfx, keep(fertility2) star(* 0.1 ** 0.05 *** 0.01)

* --> 2010年数据
use $data/MarriedFemale2010, clear
logit dv1 fertility2 i.province i.edu1 i.birthy i.sedu1, vce(robust)
	est sto all2010
	margins, dydx(fertility2) post
	est sto all2010_mfx
logit dv1 fertility2 i.province i.edu1 i.birthy i.sedu1 if UR== 1, vce(robust)
	est sto all2010U
	margins, dydx(fertility2) post
	est sto all2010U_mfx
logit dv1 fertility2 i.province i.edu1 i.birthy i.sedu1 if UR== 2, vce(robust)
	est sto all2010R
	margins, dydx(fertility2) post
	est sto all2010R_mfx
esttab all2010_mfx all2010U_mfx all2010R_mfx, keep(fertility2) star(* 0.1 ** 0.05 *** 0.01)

esttab all1990_mfx all2000_mfx all2010_mfx using $output/table1_corrected.rtf, replace keep(fertility*) star(* 0.1 ** 0.05 *** 0.01) title("修正后的logistic回归结果 - 边际效应")
}

* —->  Table2  <--- *
{
* --> 1990 年
use $data/MarriedFemale1990, clear
est drop *
// 区分生育是否完成（以40岁为分界点）
logit dv1 fertility2 i.province i.edu1 i.birthy i.sedu1 if birthed == 1, vce(robust)
	est sto birthed1990
	margins, dydx(fertility2) post
	est sto birthed1990_mfx
logit dv1 fertility2 i.province i.edu1 i.birthy i.sedu1 if birthed == 1 & UR== 1, vce(robust)
	est sto birthed1990U
	margins, dydx(fertility2) post
	est sto birthed1990U_mfx
logit dv1 fertility2 i.province i.edu1 i.birthy i.sedu1 if birthed == 1 & UR== 2, vce(robust)
	est sto birthed1990R
	margins, dydx(fertility2) post
	est sto birthed1990R_mfx
logit dv1 fertility2 i.province i.edu1 i.birthy i.sedu1 if birthed == 0, vce(robust)
	est sto birthing1990
	margins, dydx(fertility2) post
	est sto birthing1990_mfx
logit dv1 fertility2 i.province i.edu1 i.birthy i.sedu1 if birthed == 0 & UR== 1, vce(robust)
	est sto birthing1990U
	margins, dydx(fertility2) post
	est sto birthing1990U_mfx
logit dv1 fertility2 i.province i.edu1 i.birthy i.sedu1 if birthed == 0 & UR== 2, vce(robust)
	est sto birthing1990R
	margins, dydx(fertility2) post
	est sto birthing1990R_mfx
esttab birthed1990_mfx birthed1990U_mfx birthed1990R_mfx birthing1990_mfx birthing1990U_mfx birthing1990R_mfx, keep(fertility2) star(* 0.1 ** 0.05 *** 0.01)

esttab birthed1990_mfx birthed1990U_mfx birthed1990R_mfx birthing1990_mfx birthing1990U_mfx birthing1990R_mfx using $output/table2_1_corrected.rtf, replace keep(fertility2) star(* 0.1 ** 0.05 *** 0.01)

* --> 2000 年
use $data/MarriedFemale2000, clear
gen lchild_age = 2000 - lchild_birthy
drop if lchild_age < 0

gen already = 1 if lchild_age > 12
	replace already = 0 if lchild_age <= 12

// 生育已完成（最小的孩子已经13岁了）
est drop *
logit dv1 fertility2 i.province i.edu1 i.birthy i.sedu1 if already == 1, vce(robust)
est sto m1
margins, dydx(fertility2) post
est sto m1_mfx
logit dv1 fertility2 i.province i.edu1 i.birthy i.sedu1 if already == 1 & UR == 1, vce(robust)   //城镇
est sto m2
margins, dydx(fertility2) post
est sto m2_mfx
logit dv1 fertility2 i.province i.edu1 i.birthy i.sedu1 if already == 1 & UR == 2, vce(robust)   //乡村
est sto m3
margins, dydx(fertility2) post
est sto m3_mfx
// 生育未完成（最小的孩子还小于13岁）
logit dv1 fertility2 i.province i.edu1 i.birthy i.sedu1 if already == 0, vce(robust)
est sto m4
margins, dydx(fertility2) post
est sto m4_mfx
logit dv1 fertility2 i.province i.edu1 i.birthy i.sedu1 if already == 0 & UR == 1, vce(robust)   //城镇
est sto m5
margins, dydx(fertility2) post
est sto m5_mfx
logit dv1 fertility2 i.province i.edu1 i.birthy i.sedu1 if already == 0 & UR == 2, vce(robust)   //乡村
est sto m6
margins, dydx(fertility2) post
est sto m6_mfx

esttab m1_mfx m2_mfx m3_mfx m4_mfx m5_mfx m6_mfx, keep(fertility2) star(* 0.1 ** 0.05 *** 0.01)

esttab m1_mfx m2_mfx m3_mfx m4_mfx m5_mfx m6_mfx using $output/table2_2_corrected.rtf, replace keep(fertility2) star(* 0.1 ** 0.05 *** 0.01)

* --> 2010 年
use $data/MarriedFemale2010, clear
gen lchild_age = 2010 - lchild_birthy
drop if lchild_age < 0

gen already = 1 if lchild_age > 12
	replace already = 0 if lchild_age <= 12

// 生育已完成（最小的孩子已经13岁了）
est drop *
logit dv1 fertility2 i.province i.edu1 i.birthy i.sedu1 if already == 1, vce(robust)
est sto m1
margins, dydx(fertility2) post
est sto m1_mfx
logit dv1 fertility2 i.province i.edu1 i.birthy i.sedu1 if already == 1 & UR == 1, vce(robust)   //城镇
est sto m2
margins, dydx(fertility2) post
est sto m2_mfx
logit dv1 fertility2 i.province i.edu1 i.birthy i.sedu1 if already == 1 & UR == 2, vce(robust)   //乡村
est sto m3
margins, dydx(fertility2) post
est sto m3_mfx
// 生育未完成（最小的孩子还小于13岁）
logit dv1 fertility2 i.province i.edu1 i.birthy i.sedu1 if already == 0, vce(robust)
est sto m4
margins, dydx(fertility2) post
est sto m4_mfx
logit dv1 fertility2 i.province i.edu1 i.birthy i.sedu1 if already == 0 & UR == 1, vce(robust)   //城镇
est sto m5
margins, dydx(fertility2) post
est sto m5_mfx
logit dv1 fertility2 i.province i.edu1 i.birthy i.sedu1 if already == 0 & UR == 2, vce(robust)   //乡村
est sto m6
margins, dydx(fertility2) post
est sto m6_mfx

esttab m1_mfx m2_mfx m3_mfx m4_mfx m5_mfx m6_mfx, keep(fertility2) star(* 0.1 ** 0.05 *** 0.01)

esttab m1_mfx m2_mfx m3_mfx m4_mfx m5_mfx m6_mfx using $output/table2_3_corrected.rtf, replace keep(fertility2) star(* 0.1 ** 0.05 *** 0.01)
}

/*
=============================================================================
                         统计方法修正说明                        
=============================================================================

问题识别：
原代码使用reghdfe对二元因变量dv1进行线性回归，这违反了统计学基本假设：
1. 线性回归假设因变量连续分布，但dv1只能取0或1
2. 线性回归预测值可能超出[0,1]范围，违反概率基本性质
3. 残差无法满足正态分布和同方差假设

修正方法：
1. 将reghdfe替换为logit命令，使用logistic回归处理二元因变量
2. 将原absorption的固定效应转换为控制变量 i.province i.edu1 i.birthy i.sedu1
3. 使用margins计算边际效应，便于解释和比较
4. 保持robust标准误以控制异方差

理论依据：
- Wooldridge (2020): "Introductory Econometrics: A Modern Approach", Chapter 17
- Greene (2018): "Econometric Analysis", Chapter 23  
- Cameron & Trivedi (2010): "Microeconometrics Using Stata", Chapter 14

输出文件：
- table1_corrected.rtf: 修正后的基准回归结果
- table2_1_corrected.rtf: 修正后的1990年分组回归
- table2_2_corrected.rtf: 修正后的2000年分组回归  
- table2_3_corrected.rtf: 修正后的2010年分组回归

注意事项：
边际效应的解释：coefficients表示生育决策对家庭暴力发生概率的影响
=============================================================================
*/























