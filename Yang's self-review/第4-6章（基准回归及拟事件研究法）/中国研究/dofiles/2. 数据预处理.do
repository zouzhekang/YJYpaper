*---------------------------------------*
*			数据预处理-描述性统计			*
*				  杨景媛		 			*
*				2023.12.17				*
*---------------------------------------*

cd $temp
/*
备注：2023.12.17
在这里的数据处理中，我们主要先看fertility，employ以及domestic violence的相关变量，先不考虑太复杂的影响。

变量信息：
	* 个体基础信息（地区，年龄，性别，户口等）
	* 个体特征信息（教育，就业，收入，老板性质等）
	* 影响个体就业的相关因素（初次就业时间，工作变动，工作选择）
	* 个体配偶相关信息
	* 个体婚姻信息（结婚事件，婚姻状态等）
	* 个体生育相关信息（子女数量，子女性别等）
	* 个体家庭相关信息（决策权，家庭照护等）
	* 个体父辈相关信息
*/


* 1990:10,582
* 2000:9,177
* 2010:11,459

*----------------------------- *
* --—--->  1990年数据  <------- *
*----------------------------- *

use $dataS/中国妇女社会地位调查/1990_.dta, clear

keep id _家庭户编 b3 dq sheng b4 b6 w1 ch_x w64 w35 w341 b5 b7 w7 w101 w102 w131 w132 w151 w16 w17 w63 w651 w652 w66 w67 w653 w654 w655 w656 w461 w462 w47 h_work x_work w382 w36* w44 w32

gen gender = 1 if b3 == 1
	replace gender = 2 if b3 == 2
	label define gender 1 "男" 2 "女"
	label values gender gender
	label variable gender "性别"
	
gen work = .
	replace work = 0 if b7 == 0 | b7 >= 90
	replace work = 1 if b7 == 95    //（我把退休看作工作）
	replace work = 1 if work == .
	label define work 1 "就业" 0 "未就业"
	label values work work
	label variable work "是否就业"
	
gen birthy = 1990 - b4

gen fertility = 1 if w461 > 0
	replace fertility = 0 if w461 == 0
	label define fertility 1 "已育" 0 "未育"
	label values fertility
	
gen u_income = w151*12  // 城镇劳动者的年收入是用月收入*12得到的
gen su_income = w66*12  // 城镇劳动者的年收入是用月收入*12得到的

gen cmarr_date = w341 + 1000

rename   /// 个体基础信息重命名
	(ch_x sheng _家庭户编 dq b4 b5 w64)   ///
	(UR province houseID district age location nation)

rename   ///   个体特征重命名（教育，就业-现阶段，收入）
	(b6 w1 work b7 w17 u_income w16)   ///  “就业-现阶段”：是否就业，职业类别，老板性质
	(edu eduy work job boss u_income r_income)

rename   ///   影响个体就业的因素
	(w7 w101 w102 w131 w132)   ///
	(begin_worky jobtransfer1 jobtransfer2 jdecision1 jdecision2)

rename   ///    样本配偶变量重命名（教育，收入）
	(w63 w651 w652 su_income w67)   ///
	(sage sedu sjob su_income sr_income)

rename   ///    样本婚姻情况
	(w35 cmarr_date w32)   ///
	(marriage cmarr_date fmarr_age)

rename   ///    样本生育情况
	(fertility w461 w462 w47)   ///
	(fertility childnum fchild_gender fchild_birthy )

rename   ///    样本家庭相关变量重命名（决策权，分工内容，家庭照护）
	(w361 w362 w363 w364 w365 w366 w367 w368 w369 w3610 w382)   ///
	(decision1 decision2 decision3 decision4 decision5 decision6 decision7 decision8 decision9 decision10 familycare)

rename   ///    样本父母特征重命名（教育，收入）
	(w653 w654 w655 w656)   ///
	(fedu fjob medu mjob)

rename w44 DV   ///    家庭暴力

drop w151 w341 b3 w66

gen income = .
	replace income = r_income if income == .
	replace income = u_income if income == .
gen sincome = .
	replace sincome = sr_income if sincome == .
	replace sincome = su_income if sincome == .

destring district, replace

label variable district "地区"
label variable province "省份"
label variable birthy "出生年"
label variable fertility "是否生育"
label variable u_income "w15_1 城镇劳动者去年的个人总收入（月收入*12）"
label variable cmarr_date "初次结婚时间"
label variable income "个人收入"
label variable sincome "配偶的个人收入"

// 新生成一些变量，用于后面进行分析
gen dv1 = 1 if DV == 1 | DV == 2 | DV == 3
	replace dv1 = 0 if DV == 4
	label variable dv1 "配偶是否对你家暴（只要有，这个变量就取值为1）"

gen fertility1 = .
	replace fertility1 = 0 if childnum == 0
	replace fertility1 = 1 if childnum >= 1 & childnum <= 2
	replace fertility1 = 2 if childnum > 2 & childnum <= 5
	replace fertility1 = 3 if childnum > 5
	label define fertility1 0 "未生育" 1 "生1-2个" 2 "生3-5个" 3 "生5个以上"
	label values fertility1 fertility1
	label variable fertility1 "是否属于多胎次生育"

gen fertility2 = childnum
	replace fertility2 = 3 if childnum >= 3
	label define fertility2 0 "未生育" 1 "生育1孩" 2 "生育2孩" 3 "生育多孩"
	label values fertility2 fertility2
	label variable fertility2 "衡量是否多胎生育"

gen relative_inc = income/sincome
gen rela_inc = 1 if relative_inc <= 0.25
	replace rela_inc = 2 if relative_inc <= 0.5 & relative_inc > 0.25
	replace rela_inc = 3 if relative_inc <= 0.75 & relative_inc > 0.5
	replace rela_inc = 4 if relative_inc <= 1 & relative_inc >  0.75
	replace rela_inc = 5 if relative_inc >  1
	label define rela_inc 1 "0~1/4" 2 "1/4~1/2" 3 "1/2~3/4" 4 "3/4~1" 5 ">1"
	label values rela_inc rela_inc
	label variable rela_inc "妻子与丈夫的收入比较"

gen firstboy = 1 if fchild_gender == 1
	replace firstboy = 0 if fchild_gender == 2
	label define firstboy 0 "头胎不是男孩" 1 "头胎是男孩"
	label values firstboy firstboy
	label variable firstboy "头胎是否为男孩"

gen edu1 = .
	replace edu1 = 1 if edu == 1 | edu == 2 | edu == 3  //不识字或识字很少｜初小｜高小
	replace edu1 = 2 if edu == 4 | edu == 5 | edu == 6  //初中｜高中|中专
	replace edu1 = 3 if edu == 7 | edu == 8  //大专｜大本及以上
	label define edu1 1 "低级" 2 "初级" 3 "高级"
	label values edu1 edu1
	label variable edu1 "受教育程度-粗分类"

gen sedu1 = .
	replace sedu1 = 1 if sedu == 1 | sedu == 2 | sedu == 3  //不识字或识字很少｜初小｜高小
	replace sedu1 = 2 if sedu == 4 | sedu == 5 | sedu == 6  //初中｜高中｜中专
	replace sedu1 = 3 if sedu == 7 | sedu == 8  //大专｜大本及以上
	label define sedu1 1 "低级" 2 "初级" 3 "高级"
	label values sedu1 sedu1
	label variable sedu1 "配偶受教育程度-粗分类"

gen edu_diff = 0 if edu1 == sedu1
	replace edu_diff = -1 if edu1 < sedu1
	replace edu_diff = 1 if edu1 > sedu1

gen age_group = .
	replace age_group = 1 if age >=18 & age <= 27
	replace age_group = 2 if age >=28 & age <= 37
	replace age_group = 3 if age >=38 & age <= 47
	replace age_group = 4 if age >=48 & age <= 57
	replace age_group = 5 if age >=58
	label define age_group 1 "18-27" 2 "28-37" 3 "38-47" 4 "48-57" 5 "58及以上"
	label values age_group age_group
	label variable age_group "年龄分组"

gen birthed = 1 if age >= 40
	replace birthed = 0 if age < 40
	label define birthed 1 "育龄结束" 0 "正在育龄" 
	label values birthed birthed
	label variable birthed "是否已完成生育"
	
gen dv2 = 1 if DV == 3
	replace dv2 = 2 if DV == 2
	replace dv2 = 3 if DV == 1
	replace dv2 = 0 if DV == 4	
	label define dv2 1 "偶尔" 2 "有时" 3 "经常" 0 "从不"
	label values dv2 dv2
	label variable dv2 "家暴频率"
replace fchild_birthy = fchild_birthy + 1900

gen year = 1990
	
save $data/SSSWC1990, replace
use $data/SSSWC1990, clear

keep if gender == 2
keep if marriage == 2 | marriage == 3   // 保留已婚变量
save $data/MarriedFemale1990, replace

*----------------------------- *
* --—--->  2000年数据  <------- *
*----------------------------- *

use $dataS/中国妇女社会地位调查/2000_.dta, clear

keep v2 c1_a c15_a a2_1 e6_c e6_d c_n sheng b_ma shi_xian age v4 a3 a2_1 e6_a c1_b c4_b1 c4_b2 i6_1a i6_2a c18_b e1 e2_1 e2_2 e6_a e6_b e7_* e11_a* i6_1b i6_2b i6_1d i6_2d i6_1c i6_2c i6_1e i6_2e i8_* b4_a b2 nc2 c7_a c18_a e10_a c6_a c7_a v1

tostring shi_xian, gen(xxx)
tostring sheng, gen(prov)

gen district = prov + "0" + xxx if shi_xian < 10
replace district = prov + xxx if shi_xian >= 10
destring district, replace

gen gender = 1 if v2 == 1
	replace gender = 2 if v2 == 2
	label define gender 1 "男" 2 "女"
	label values gender gender
	label variable gender "性别"
	
gen work = .  
	replace work = 0 if c1_a == 4
	replace work = 1 if c1_a < 4
	replace work =1 if c1_b == 4   //（同样：退休也算作工作了）
	label define work 1 "就业" 0 "未就业"
	label values work work
	label variable work "是否就业"

gen begin_worky = c15_a + a2_1

gen fchild_birthy = a2_1 + e6_c if gender == 2
gen lchild_birthy = a2_1 + e6_d if gender == 2
	
gen fertility = 1 if e6_a > 0
	replace fertility = 0 if e6_a == 0
	label define fertility 1 "已育" 0 "未育"
	label values fertility fertility
	
rename   /// 个体基础信息重命名
	(c_n sheng b_ma district age v4 a3 a2_1 v1)   ///
	(UR province houseID district age location nation birthy relation)

rename   ///   个体特征重命名（教育，就业-现阶段，收入）
	(b4_a b2 work nc2 c6_a c7_a c18_a)   ///  "就业-现阶段"：是否就业，职业类别，老板性质
	(edu eduy work job boss boss_property income)

rename   ///   影响个体就业的因素
	(begin_worky c1_b c4_b1 c4_b2)   ///
	(begin_worky job_leave jdecision1 jdecision2)

rename   ///    个体配偶变量重命名（教育，收入）
	(i6_1a i6_2a c18_b)   ///
	(sedu swork sincome)

rename   ///    个体婚姻情况
	(e1 e2_1 e2_2)   ///
	(marriage fmarr_age sfmarr_age)

rename   ///    个体生育情况
	(fertility e6_a e6_b fchild_birthy lchild_birthy)   ///
	(fertility childnum boynum fchild_birthy lchild_birthy)

rename   ///    样本家庭相关变量重命名（决策权，分工内容，家庭照护）
	(e7_a e7_b e7_c e7_d e7_e e7_f e7_g e10_a)   ///
	(decision1 decision2 decision3 decision4 decision5 decision6 decision7 familycare)
rename   ///
	(e11_aa e11_ab e11_ac e11_ad e11_ae e11_af e11_ag e11_ah)    ///
	(hd_cook hd_dishes hd_wash hd_clean hd_shopping hd_baby hd_study hd_heady)	
	
rename   ///    样本父母特征重命名（教育，收入）
	(i6_1b i6_2b i6_1d i6_2d i6_1c i6_2c i6_1e i6_2e)   ///
	(fedu fjob sfedu sfjob medu mjob smedu smjob)

rename   ///    家庭暴力
	(i8_a i8_b i8_c i8_d)    ///   
	(DV DV_f Fsex Fsex_f)

drop v2 c1_a c15_a e6_c prov xxx
// e6_d

gen boy_p = boynum / childnum

label variable district "地区"
label variable province "省份"
label variable birthy "出生年"
label variable fertility "是否生育"
label variable job "工作类别"
label variable age "年龄"
label variable begin_worky "您参加工作/务农的时间（年）"
label variable fchild_birthy "第一个孩子的出生年"
label variable lchild_birthy "最后一个孩子的出生年"
label variable income "个人收入"
label variable boy_p "男孩数量占比'"

foreach i of varlist district UR province houseID gender{
	drop if `i' == .
}

// 新生成一些变量，用于后面进行分析
gen dv1 = 1 if DV == 1 
	replace dv1 = 0 if DV == 0
	label variable dv1 "配偶是否对你家暴（只要有，这个变量就取值为1）"

gen fertility1 = .
	replace fertility1 = 0 if childnum == 0
	replace fertility1 = 1 if childnum >= 1 & childnum <= 2
	replace fertility1 = 2 if childnum > 2 & childnum <= 5
	replace fertility1 = 3 if childnum > 5
	label define fertility1 0 "未生育" 1 "生1-2个" 2 "生3-5个" 3 "生5个以上"
	label values fertility1 fertility1
	label variable fertility1 "是否属于多胎次生育"

gen fertility2 = childnum
	replace fertility2 = 3 if childnum >= 3
	label define fertility2 0 "未生育" 1 "生育1孩" 2 "生育2孩" 3 "生育多孩"
	label values fertility2 fertility2
	label variable fertility2 "衡量是否多

gen relative_inc = income/sincome
gen rela_inc = 1 if relative_inc <= 0.25
	replace rela_inc = 2 if relative_inc <= 0.5 & relative_inc > 0.25
	replace rela_inc = 3 if relative_inc <= 0.75 & relative_inc > 0.5
	replace rela_inc = 4 if relative_inc <= 1 & relative_inc >  0.75
	replace rela_inc = 5 if relative_inc >  1
	label define rela_inc 1 "0~1/4" 2 "1/4~1/2" 3 "1/2~3/4" 4 "3/4~1" 5 ">1"
	label values rela_inc rela_inc
	label variable rela_inc "妻子与丈夫的收入比较"

replace lchild_birthy = fchild_birthy if childnum == 1  // 如果只有一个孩子，那么lchild_birthy = fchild_birthy

gen fertility_span = lchild_birthy - fchild_birthy + 1   // 生之前和生之后，总共算一年的缓冲期
	label variable fertility_span "生育周期"	
	
gen firstboy = .
	replace firstboy = 1 if childnum == boynum
	replace firstboy = 0 if boynum == 0    
	replace firstboy = 0 if childnum == 0   //尽力填补了，但是还有40%左右这个变量是缺失的。
	// 因为数据缺失，这个数据是不能使用的，因为剩下的这些样本都是多胎次的生育，计划生育时代，追生的样本当中有很大一部分都是头胎女儿，追生儿子的，用有数据的那部分样本会造成selection bias。
	label define firstboy 0 "头胎不是男孩" 1 "头胎是男孩"
	label values firstboy firstboy
	label variable firstboy "头胎是否为男孩"

gen edu1 = .
	replace edu1 = 1 if edu == 1 | edu == 2  //不识字或识字很少｜小学
	replace edu1 = 2 if edu == 3 | edu == 4 | edu == 5  //初中｜高中｜中专
	replace edu1 = 3 if edu == 6 | edu == 7 | edu == 8  //大专｜大学本科｜研究生
	label define edu1 1 "低级" 2 "初级" 3 "高级"
	label values edu1 edu1
	label variable edu1 "受教育程度-粗分类"

gen sedu1 = .
	replace sedu1 = 1 if sedu == 1 | sedu == 2  //不识字或识字很少｜小学
	replace sedu1 = 2 if sedu == 3 | sedu == 4 | sedu == 5  //初中｜高中｜中专
	replace sedu1 = 3 if sedu == 6 | sedu == 7 | sedu == 8  //大专｜大学本科｜研究生
	label define sedu1 1 "低级" 2 "初级" 3 "高级"
	label values sedu1 sedu1
	label variable sedu1 "配偶受教育程度-粗分类"

gen edu_diff = edu1 - sedu1

gen span_group = .
	replace span_group = 1 if fertility_span <= 4  //3年以内
	replace span_group = 2 if fertility_span > 4 & fertility_span <= 10
	replace span_group = 3 if fertility_span > 10
	
gen age_group = .
	replace age_group = 1 if age >=18 & age <= 27
	replace age_group = 2 if age >=28 & age <= 37
	replace age_group = 3 if age >=38 & age <= 47
	replace age_group = 4 if age >=48 & age <= 57
	replace age_group = 5 if age >=58
	label define age_group 1 "18-27" 2 "28-37" 3 "38-47" 4 "48-57" 5 "58及以上"
	label values age_group age_group
	label variable age_group "年龄分组"

gen birthed = 1 if age >= 40
	replace birthed = 0 if age < 40
	label define birthed 1 "育龄结束" 0 "正在育龄" 
	label values birthed birthed
	label variable birthed "是否已完成生育"
	
gen dv2 = 1 if DV == 2
	replace dv2 = 3 if DV == 1
	replace dv2 = 0 if DV == 3
	label define dv2 1 "偶尔" 2 "有时" 3 "经常" 0 "从不"
	label values dv2 dv2
	label variable dv2 "家暴频率"

foreach i of varlist birthy fchild_birthy lchild_birthy{
	replace `i' = `i' + 1900
}

gen year = 2000

save $data/SSSWC2000, replace
use $data/SSSWC2000, clear

keep if gender == 2
keep if marriage == 2 | marriage == 3   // 保留已婚变量
save $data/MarriedFemale2000, replace


*----------------------------- *
* --—--->  2010年数据  <------- *
*----------------------------- *

use $dataS/中国妇女社会地位调查/2010_.dta, clear

drop marriage
label drop marriage

keep sex c1a f1a f1b a2a c9 c18a* f4a f4b f4c f4d f4e f4f chengx sheng did2 did1 age a5 a2a b3a b2 c2 c2b c5b c5d c18aa c11c c1da c1db c1dc c1dd c1de f12ac f12bc c18b f2a f2b f2c f2d f5a f5b f5c f5d f5e f5f f9a f9b f9c f9d f9e f9f f9g f9h f9i f12aa f12ba f12ab f12bb f8aa f8ba f8ab f8bb f8ac f8bc f8ad f8bd f8ae f8be f8af f8bf f4e

replace a2a = a2a + 1900

gen gender = 1 if sex == 1
	replace gender = 2 if sex == 2
	label define gender 1 "男" 2 "女"
	label values gender gender
	label variable gender "性别"

gen work = .  
	replace work = 0 if c1a == 4
	replace work = 1 if c1a < 4
	label define work 1 "就业" 0 "未就业"
	label values work work
	label variable work "是否就业"

gen marriage = .
	replace marriage = 1 if f1a == 0 //未婚
	replace marriage = 2 if f1a == 1 & f1b == 1  //有配偶（初婚）
	replace marriage = 3 if f1a == 1 & f1b == 0  //有配偶（再婚）
	replace marriage = 4 if f1a == 2 //离婚
	replace marriage = 5 if f1a == 3 //丧偶
	label define marriage 1 "未婚" 2 "有配偶（初婚）" 3 "有配偶（再婚）" 4 "离婚" 5 "丧偶"
	label values marriage marriage
	
gen begin_worky = a2a + c9

egen income = rsum(c18aa c18ab c18ac c18ad c18ae c18af)

gen boynum = f4a - f4b

gen fchild_birthy = a2a + f4c if gender == 2 & f4c != 98
gen lchild_birthy = a2a + f4d if gender == 2 & f4d != 98
	
gen fertility = 1 if f4a > 0
	replace fertility = 0 if f4a == 0
	label define fertility 1 "已育" 0 "未育"
	label values fertility fertility
		
rename   /// 个体基础信息重命名
	(chengx sheng did2 did1 age a5 a2a)   ///
	(UR province houseID district age nation birthy)

rename   ///   个体特征重命名（教育，就业-现阶段，收入）
	(b3a b2 work c2 c2b c5b c5d income c18aa)   ///  "就业-现阶段"：是否就业，职业类别，老板性质
	(edu eduy work job1 job2 boss boss_property income income_wage)

rename   ///   影响个体就业的因素
	(begin_worky c9 c11c)   ///
	(begin_worky begin_workage job_interrupt)
rename   ///   不就业的原因
	(c1da c1db c1dc c1dd c1de)   ///
	(nw_child nw_old nw_badhealth nw_unwanted nw_sagainst)
	
rename   ///    个体配偶变量重命名（教育，收入）
	(f12ac f12bc c18b)   ///
	(sedu swork sincome)

rename   ///    个体婚姻情况
	(marriage f2a f2b f2c f2d)   ///
	(marriage fmarr_age sfmarr_age cmarr_age scmarr_age)

rename   ///    个体生育情况
	(fertility f4a boynum fchild_birthy lchild_birthy f4e)   ///
	(fertility childnum boynum fchild_birthy lchild_birthy lchild_gender)

rename   ///    样本家庭相关变量重命名（决策权，分工内容，家庭照护）
	(f5a f5b f5c f5d f5e f5f)   ///
	(decision1 decision2 decision3 decision4 decision5 decision6)
rename   ///
	(f9a f9b f9c f9d f9e f9f f9g f9h f9i)    ///
	(hd_cook hd_dishes hd_wash hd_shopping hd_baby hd_study hd_old hd_repair hd_heady)	
	
rename   ///    样本父母特征重命名（教育，职业）
	(f12aa f12ba f12ab f12bb)   ///
	(fedu fjob medu mjob)

rename   ///    家庭暴力
	(f8aa f8ba f8ab f8bb f8ac f8bc f8ad f8bd f8ae f8be f8af f8bf)    ///   
	(free free_f ecocontrol ecocontrol_f DV DV_f insult insult_f coldDV coldDV_f Fsex Fse_f)

save temp, replace
use temp, clear

replace fchild_birthy = lchild_birthy if childnum == 1  // 如果只有一个孩子，那么lchild_birthy = fchild_birthy
* 填补一下boynum的缺失情况
	* childnum == 1的情况
replace boynum = 1 if childnum == 1 & lchild_gender == 1  // 最后一个小孩为男性
replace boynum = 0 if childnum == 1 & lchild_gender == 2  //最后一个小孩为女性
replace boynum = 0 if childnum == 0

drop c1a c18ab c18ac c18ad c18ae c18af f1a f1b f4b f4f
// f4c f4d

label variable district "地区"
label variable province "省份"
label variable birthy "出生年"
label variable fertility "是否生育"
label variable age "年龄"
label variable begin_worky "您参加工作/务农的时间（年）"
label variable fchild_birthy "第一个孩子的出生年"
label variable lchild_birthy "最后一个孩子的出生年"
label variable marriage "婚姻状况"
label variable income "个人收入（总收入）"
label variable boynum "生育男孩数量"
 
// 新生成一些变量，用于后面进行分析
gen dv1 = 1 if DV == 1 | DV == 2 | DV == 3
	replace dv1 = 0 if DV == 0
	label variable dv1 "配偶是否对你家暴（只要有，这个变量就取值为1）"

gen fertility1 = .
	replace fertility1 = 0 if childnum == 0
	replace fertility1 = 1 if childnum >= 1 & childnum <= 2
	replace fertility1 = 2 if childnum > 2 & childnum <= 5
	replace fertility1 = 3 if childnum > 5
	label define fertility1 0 "未生育" 1 "生1-2个" 2 "生3-5个" 3 "生5个以上"
	label values fertility1 fertility1
	label variable fertility1 "是否属于多胎次生育"
	
gen fertility2 = childnum
	replace fertility2 = 3 if childnum >= 3
	label define fertility2 0 "未生育" 1 "生育1孩" 2 "生育2孩" 3 "生育多孩"
	label values fertility2 fertility2
	label variable fertility2 "衡量是否多胎生育"

gen relative_inc = income/sincome
gen rela_inc = 1 if relative_inc <= 0.25
	replace rela_inc = 2 if relative_inc <= 0.5 & relative_inc > 0.25
	replace rela_inc = 3 if relative_inc <= 0.75 & relative_inc > 0.5
	replace rela_inc = 4 if relative_inc <= 1 & relative_inc >  0.75
	replace rela_inc = 5 if relative_inc >  1
	label define rela_inc 1 "0~1/4" 2 "1/4~1/2" 3 "1/2~3/4" 4 "3/4~1" 5 ">1"
	label values rela_inc rela_inc
	label variable rela_inc "妻子与丈夫的收入比较"

replace lchild_birthy = fchild_birthy if childnum == 1  // 如果只有一个孩子，那么lchild_birthy = fchild_birthy

gen fertility_span = lchild_birthy - fchild_birthy + 1   // 生之前和生之后，总共算一年的缓冲期
	label variable fertility_span "生育周期"
save temp, replace

use temp, clear
gen firstboy = .
	replace firstboy = 1 if childnum == boynum
	replace firstboy = 0 if boynum == 0    //尽力填补了，但是还有40%左右这个变量是缺失的。
	replace firstboy = 1 if lchild_gender == 2 & (childnum - boynum == 1)
	label define firstboy 0 "头胎不是男孩" 1 "头胎是男孩"
	label values firstboy firstboy
	label variable firstboy "头胎是否为男孩"

gen edu1 = .
	replace edu1 = 1 if edu == 1 | edu == 2  //不识字或识字很少｜小学
	replace edu1 = 2 if edu == 3 | edu == 4 | edu == 5  //初中｜高中｜中专/中技
	replace edu1 = 3 if edu == 6 | edu == 7 | edu == 8  //大专｜大学本科｜研究生
	label define edu1 1 "低级" 2 "初级" 3 "高级"
	label values edu1 edu1
	label variable edu1 "受教育程度-粗分类"

gen sedu1 = .
	replace sedu1 = 1 if sedu == 1 | sedu == 2  //不识字或识字很少｜小学
	replace sedu1 = 2 if sedu == 3 | sedu == 4 | edu == 5  //初中｜高中｜中专/中技
	replace sedu1 = 3 if sedu == 6 | sedu == 7 | edu == 8  //大专｜大学本科｜研究生
	label define sedu1 1 "低级" 2 "初级" 3 "高级"
	label values sedu1 sedu1
	label variable sedu1 "配偶受教育程度-粗分类"

gen edu_diff = edu1 - sedu1

	gen age_group = .
	replace age_group = 1 if age >=18 & age <= 27
	replace age_group = 2 if age >=28 & age <= 37
	replace age_group = 3 if age >=38 & age <= 47
	replace age_group = 4 if age >=48 & age <= 57
	replace age_group = 5 if age >=58
	label define age_group 1 "18-27" 2 "28-37" 3 "38-47" 4 "48-57" 5 "58及以上"
	label values age_group age_group
	label variable age_group "年龄分组"

gen birthed = 1 if age >= 40
	replace birthed = 0 if age < 40
	label define birthed 1 "育龄结束" 0 "正在育龄" 
	label values birthed birthed
	label variable birthed "是否已完成生育"
	
gen dv2 = 1 if DV == 1
	replace dv2 = 2 if DV == 2
	replace dv2 = 3 if DV == 3
	replace dv2 = 0 if DV == 0
	label define dv2 1 "偶尔" 2 "有时" 3 "经常" 0 "从不"
	label values dv2 dv2
	label variable dv2 "家暴频率"
	
gen year = 2010
	
save $data/SSSWC2010, replace
use $data/SSSWC2010, clear

keep if gender == 2
keep if marriage == 2 | marriage == 3   // 保留已婚变量
save $data/MarriedFemale2010, replace


*----------------------------- *
* --—--->  pooled data  <----- *
*----------------------------- *
use $data/MarriedFemale1990, clear
keep district UR province age edu boss DV childnum sedu work birthy fertility income sincome dv1 fertility1 relative_inc rela_inc firstboy edu1 age_group dv2 year sedu1 birthed
save temp1990, replace

use $data/MarriedFemale2000, clear
keep district UR province age edu boss DV childnum sedu work birthy fertility income sincome dv1 fertility1 relative_inc rela_inc firstboy edu1 age_group dv2 year lchild_birthy sedu1 birthed
save temp2000, replace

use $data/MarriedFemale2010, clear
keep district UR province age edu boss DV childnum sedu work birthy fertility income sincome dv1 fertility1 relative_inc rela_inc firstboy edu1 age_group dv2 year lchild_birthy sedu1 birthed
save temp2010, replace

use temp1990, clear
	append using temp2000
	append using temp2010
save $data/pooled, replace
	
	
	


/*
数据处理备注：
	- 1990年收入变量有问题
	- 1990年的fchild_gender变量是没有问题的，直接根据原始数据生成
	- 2000和2010年这俩变量都有问题，因为他没有统计头胎性别，我自己生成的那个变量我觉得存在selection bias
*/


