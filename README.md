# YJYpaper
本仓库专门用来记录武汉大学国际经济贸易专业杨景媛的硕士毕业论文《中印生育行为影响家庭暴力的经济学分析》中存在的问题。  

原论文在[这里](./paper/%E4%B8%AD%E5%8D%B0%E7%94%9F%E8%82%B2%E8%A1%8C%E4%B8%BA%E5%BD%B1%E5%93%8D%E5%AE%B6%E5%BA%AD%E6%9A%B4%E5%8A%9B%E7%9A%84%E7%BB%8F%E6%B5%8E%E5%AD%A6%E5%88%86%E6%9E%90.pdf) 欢迎各位评论并列举更多的错误，也可以提供举报的地址。  

❗有博主（李然于心）已经被粉衣哥带俩金哥深夜登门拜访了！！！视频在[夸克网盘](https://pan.quark.cn/s/10cebfa84661#/list/share)，顿时有点害怕捏！！！

## TODO
- [x] 收集存在问题
- [ ] 向武汉大学举报
- [ ] 在教育部科研诚信管理信息系统举报
- [ ] 向湖北省教育厅举报

## 主要问题
### 涉嫌造假
1. 疑似内容编造(p1)：  
第一页倒数第三行内容：“例如部分国家和地区出台的《立即逮捕法案》”  
并未找到因家暴出台的《立即逮捕法案》，此处疑似为 强制逮捕法案（mandatory arrest laws）。
2. 内容编造(p2)：  
第二页第五行内容：“而在 2001 年随着《离婚法》的出台
与宣传”  
我国并未颁布《离婚法》，此为杜撰内容。
3. 数据编造(p14)：  
第十四页的图2.1 全球各国家暴发生率直方图，纵坐标为频数，频数指的是xxx出现的次数，她是怎么求出非整数的？
![plt](./pic/plt.jpeg)  

### 涉嫌抄袭剽窃
1. 整段抄袭(p2 p3)：  
·以下两段涉嫌抄袭论文 何晖,王凌林.印度反家庭暴力的实践与成效[J].现代世界警察, 2022(11):58-64  ，以下两段杨的原文内未出现任何引用。  
第二页最后一段内容：“在印度，根据印度国家犯罪研究局的官方报告，2019 年针对妇女的 40.5 万犯罪案件中，其中有超过 30%是家庭暴力案件。2021 年印度 NFHS-5 数据显示，在 18~49 岁的印度女性中，近三分之一的人遭受过家庭暴力，32%的已婚女性曾遭受伴侣在身体、性或情感等方面的暴力，其中 27%的女性在调查的近一年时间内至少遭受过一种形式的暴力。” 涉嫌抄袭：  
![en_abstract](./pic/pap2.jpg)
第三页第一段内容：“不完善的法律制度与复杂的举报流程是印度家庭暴力频发的外在原因。早在1983 年，印度刑法典修订的第 498A 条就规定如果丈夫或夫家亲属虐待妇女，处以最高三年的监禁及相应罚款。2005 年 6 月，印度通过首部《反家庭暴力法》。但印度反家庭暴力的法律并没有根据社会的变化进行修改。同时，复杂的举报证据与流程，加之缺乏严格执法，使印度反家庭暴力法律制度有名无实、形同虚设，很多案件不了了之。截至 2020 年底，基于第 498A 的定罪率不到 20%，印度法院总共有 65.1 万起 498A 家庭暴力案件悬而未决。”涉嫌抄袭：  
![en_abstract](./pic/pap1.jpg)  
2. 疑似抄袭未删干净(p4)：  
第四页倒数第三行的内容：“其中规定，即单独二孩政策。”与前后文不搭，疑似抄袭未删干净。  

### 数据错误
1. 年份错误(p4)：  
第四页第七行内容：“新中国成立之后，由于社会经济的逐渐稳定与发展，全国总人口从 1049 年之前的 5.42 亿增长到 1970 年的 8.30 亿。”  
我国于1949年成立，并非1049年，这属于严重的**政治错误**。
2. 常识性错误(p15)：   
第十五页最后一段内容：“预计到 2087 年，世界人口将达到峰值 103 亿人，之后将缓慢下降至 2100 年的 103 亿人。”   
这降了啥？其中必有一个数据是错误的。  

### 数据分析错误
1. 常识性分析错误(p21)：  
第一段倒数三行内容，如下图所示，0.01% 应为10000位女性中有一位。  
![idiot](./pic/img2.jpg)
2. 分析错误(p25)：   
第二十五页倒数第六行内容：“本文用各地区人均道观数据衡量该地区思想传统程度”  
道教属于宗教范畴，不同地区的宗教分布不一致，故人均道观数跟当地思想传统程度无直接关系。
3. 强行拟合(p26)：  
如图所示，图中的点散度过大，无明显线性关系。其中同为观念传统地区且生育率相近的甘肃和福建的家暴跨度过大，可说明该线不适合证明观念与家暴之间的关系。 
![idiot](./pic/img.jpeg)   
4. 模型使用错误(p37)：  
在论文第4 节 4.数据与实证策略 4.1.实证策略 4.1.1.基于双重固定效应模型的实证策略，该模型的被解释变量 DV, 代表个体是否遭遇家庭暴力; 由于被解释变量DV只有两种取值（二元变量），有或者没有遭遇家庭暴力, 因而这是一个典型的『二元选择模型（binary choice model）』  
计量经济学的基本常识: 不能用线性模型来解释一个二元选择变量. 应该使用 Logistic回归 或 Probit回归模型。  
但是, 论文中使用的所谓 "双重固定效应回归模型" 4.1 是一个线性模型. 这是一个严重的错误. 论文使用了错误的模型, 主要实证结果不可靠.  
![model](https://private-user-images.githubusercontent.com/185666644/472110072-bdc7fdf4-c9af-4096-acbd-6982bf3969f3.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NTM4NDI0ODQsIm5iZiI6MTc1Mzg0MjE4NCwicGF0aCI6Ii8xODU2NjY2NDQvNDcyMTEwMDcyLWJkYzdmZGY0LWM5YWYtNDA5Ni1hY2JkLTY5ODJiZjM5NjlmMy5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjUwNzMwJTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI1MDczMFQwMjIzMDRaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT1hNTJiZjRlZjg1ZmQzYTNjYzkzMGI0Njg5NjQ1NmY1ZmMyNzAzMDJkZjA1ODQ0YThhM2Q5N2ZjNzVjODU2MDkzJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.chLXLr0VkqsR1f6rRgD7YRxzBV9ZJSblhi-KIo2E8UE) 

### 写作与表达错误
1. 摘要翻译错误：  
中文关键词：生育；家庭暴力；母职惩罚；社会规范
英文关键词：Fertility；Domestic Violence；Outside Option；Social Norm  
“母职惩罚”和“Outside Option”无法对应。
![en_abstract](./pic/zhaiyao.jpeg)
2. 摘要翻译问题：  
原文英文关键词那一行写着：“关键词：Fertility；Domestic Violence；Outside Option；Social Norm”  
其中**关键词**三个字未翻译为英文keyword。  
3. 错别字(p3)：  
第三页图1.2的图注将“粉红帮”写成了“粉红邦”。  
4. 错别字(p4)：  
第四页第一行内容：“伴随 90 年带股市房市大泡沫破裂”  
此处应为“年代”而不是“年带”。   
5. 错别字(p6)：  
第六页倒数第六至七行内容：“而决定女性外部选则的关键因素包括女性的特质”   
此处应为“选择”而不是“选则”。
6. 疑似错别字(p8)：  
第八页第六至七行内容：“此时就只会有表达性大家暴”  
此处的“大”疑似为“的”。   
6. 疑似错误字符(p8)：  
第八页 关于家庭暴力的其他文献 中的第六行内容：“例如，g 通过越南的数据发现”  
这个g指代不明，疑似错写字符。  
7. 错别字(p10)：  
第十页倒数第三行内容：“可以分为两只文献，第一支文献...第二支文献...”   
将“支”错写为“只”。
8. 写错时间(p15)：  
第十五页第一段第四行内容：“与 1960 年 -1665 之间的剧烈增长形成明显对比”  
疑似将1965写为1665。 
9. 错别字(p15)：  
第十五页倒数第三行内容：“未来非洲人口获奖贡献90%的世界人口增量”   
疑似把“或将”错写为“获奖”。  
10. 错别字(p18)：  
第十八页第三行内容：“就业情况等多个纬度”   
把“维度”错写为“纬度”。  
11. 多字(p24)：  
第二十四页第二段第一行内容：“图 2.16 通展示了我国生育数量与平均家暴发生率之间的关系。”   
其中的“通”为多余字。   
12. 漏标点符号(p25)：  
第二十五页倒数第五行内容：“甘肃，福建西藏以及辽宁等地”   
福建西藏之间没加逗号。   
13. 图片标题错误(p26)：  
图 2.19 下方的标题：“图2.19 平均数量与平均家暴发生率散点图（按照宗族文化程度分类）”   
将“平均生育数量”漏写为“平均数量”。  
12. 简称错误(p27)：  
第二十七页2.2.4节内容：“也被称作受压迫的种姓（Scheduled Castes，简称 CS）”   
简称错误，应为SCs或SC。  
15. 多写符号(p40)：  
第四十页倒数第三行内容：“包括丈夫是否曾经对你有过殴打等行为，。”   
多写了一个逗号。    
15. 写错单词(p40)：  
第四十页倒数第二行内容：“NHHS4 调查中关于受访者回答的描述性统计见表 4.3.从表中可以看到”   
疑似将“NFHS4”写为“NHHS4”。  
16. 多处空格混乱(p40)：  
疑似多处将“NHHS4”、“NHHS 4”、“NHHS3”、“NHHS 3”混着写，中间是否有空格未知，该问题主要出现在第四十页。      
14. 错别字及错误字符(p41)：  
第四十一页的表格疑似将“7.”写成了“x7.”，将“被迫”写成了“被破”。
![table](./pic/tab.jpeg)  
15. 多写符号(p43)：  
第四十三页倒数第四行内容：“3（生育 5 个以上）），”   
连续写了两个右括号。  
15. 多写符号(p56)：  
第五十六页倒数第三行内容：“人口大邦（占全样本 95%以上）的母职惩罚）。”   
母职惩罚后面多写了一个右括号。  
16. 多处名字写错(p17 p40 p42, p20 p55)：  
疑似多处将“Kleven”写成“Kelvin”，分别出现在第十七页、四十页、四十二页。  
疑似多处将“Kleven”写成“Kelven”，分别出现在第二十页、五十五页。  

### 格式与规范错误
1. 格式错误(p1)：  
第一页第二段第二行内容：“即有 27%的女性一生中至少遭受过一次来自丈夫或男性亲密伴侣的身体和/或性暴力侵害”  
没有必要使用“和/或”，直接使用或也能表达和的意思。  
2. 图片标题格式错误(p44)：  
第四十四页图下方的标题为：“图 5.1：生育子女数量对家庭暴力的影响”  
其中图 5.1 后面加了冒号，与前后文格式不匹配。 

### 学术伦理问题
1. 该文章阐述家庭暴力与生育、传统文化、宗教、女性就业之间的关联，在数据拟合度低的情况下强行将家暴与文化、宗教捆绑，该课题可能涉及较为严重的**学术伦理问题**。  

### 文献引用错误
1. 图表引用错误(p26)：  
第二十六页倒数第七行内容：“图 2.19 反映了这种现象，本文各省份分为宗族思想较强和宗族思想较弱的地区，结果发现，在宗族思想较强的地区，生育数量的上升往往伴随着较低的家暴发生率。”   
图 2.19 反应的是家暴和生育的关系，跟宗教没有关系。  
2. 疑似为了降重修改标题(p63)：  
参考文献部分第六十三页：
[46] Cesur R, Sabia J J. When War Comes Home: The Impact of Combat Service on Domestic Violence[J]. Review of Economics and Statistics, 2016, 98(2): 209-225.  
我查到的题目是 When War Comes Home: The effect of Combat Service on Domestic Violence
3. 完全重复(p64)：  
参考文献部分第六十四页：
[59] Dugan L, Nagin D S, Rosenfeld R. Explaining the Decline in Intimate Partner Homicide: The 
Effects of Changing Domesticity, Women's Status, and Domestic Violence Resources[J]. Homicide Studies, 1999, 3(3): 187-214.  
[60] Dugan L, Nagin D S, Rosenfeld R. Explaining the Decline in Intimate Partner Homicide: The 
Effects of Changing Domesticity, Women's Status, and Domestic Violence Resources[J]. 
Homicide Studies, 1999, 3(3): 187-214.
4. 完全重复(p66)：  
参考文献部分第六十六页：
[101]Tauchen H V, Witte A D, Long S K. Domestic Violence: A Nonrandom Affair[J]. International   
Economic Review, 1991, 32(2): 491.  
[102]Tauchen H, Witte A, Long S. Domestic Violence - a Nonrandom Affair[J]. International 
Economic Review, 1991, 32(2): 491-511.
5. 疑似引用化学论文(p66)：
参考文献部分第六十六页：
[105]Wilson W W, Haiges R, Christe K. Contents Lists Available at Sciencedirect[J]. 2023.
该引用中Contents Lists Available at Sciencedirect疑似不是论文题目，该文章的出处疑似为化学材料相关期刊。


## 🙏acknowledge
- 感谢各位提的issue
- 感谢知乎答主云杉
