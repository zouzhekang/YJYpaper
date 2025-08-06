cd "/Users/yuan/study/毕业论文- R绘图/世界生育率"



import delimited "/Users/yuan/study/毕业论文- R绘图/世界生育率/world_fertility.csv", varnames(1) clear

reshape long x, i(countryname countrycode) j(年份)

rename x 生育率
rename countryname 国家名

export delimited using "/Users/yuan/study/毕业论文- R绘图/世界生育率/WF.csv", replace


























