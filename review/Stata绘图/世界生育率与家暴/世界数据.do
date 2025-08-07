cd "/Users/yuan/Desktop/世界数据"

pwd

// 家暴
import excel "/Users/yuan/Desktop/世界数据/家暴/world_DV_ok.xlsx", firstrow clear
save DV, replace

// Child penalty
import delimited "/Users/yuan/Desktop/世界数据/ChildPenalty/penalty_.csv", clear
rename name Country
save CP, replace

// fertility rate
import delimited "/Users/yuan/Desktop/世界数据/FertilityRate/FR.csv", varnames(1) clear 
rename (countryname countrycode v3) (Country iso FR)
save FR, replace


// 匹配
use FR, clear
	merge 1:1 Country using DV
	drop if _merge == 2
	drop _merge
	
	merge 1:1 Country using CP
	drop if _merge == 2
	drop _merge
	
save FR_DV_CP, replace

histogram lifetime, scheme(plotplain) ytitle(频数) xtitle(家暴发生率)



histogram penalty
	
	twoway(scatter lifetime FR if penalty <= 30)(scatter lifetime FR if penalty >= 30)
	
twoway   ///
(scatter lifetime FR if penalty <= 30)(lfit lifetime FR if penalty <= 30)   ///
(scatter lifetime FR if penalty >= 30)(lfit lifetime FR if penalty >= 30)  

	scatter lifetime FR if penalty <= 24
	scatter lifetime FR if penalty >= 24
	

	
	
	

