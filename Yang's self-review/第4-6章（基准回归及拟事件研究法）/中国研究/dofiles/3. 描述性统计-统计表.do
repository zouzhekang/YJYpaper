*---------------------------------------*
*				描述性统计表				*
*				  杨景媛		 			*
*				2024.04.10				*
*---------------------------------------*

// 对应正文表4.1


cd $temp

use $data/pooled, clear

logout, save($output/data_sum) word replace : bysort year : tabstat age edu sedu work birthy fertility dv1,  s(N mean sd min max) f(%12.3f) c(s)





*-----------------------------------------------*
*				2025年08月论文核查纠错				*
*-----------------------------------------------*

// 之前毕业论文做描述性统计的生活忽略了sedu（配偶受教程度）变量的值标签，导致输出表格当中最大值为98（实际上应该是8）

use $data/pooled, clear

labellist

drop if sedu == 98

logout, save($output/data_sum)_revised2025) word replace : bysort year : tabstat age edu sedu work birthy fertility dv1,  s(N mean sd min max) f(%12.3f) c(s)














