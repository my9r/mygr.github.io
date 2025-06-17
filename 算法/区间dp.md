数据范围较小且每个统计的问题可以分解为几个互不相干的小问题再合并处理时，考虑区间dp

关键在于合并的本质：枚举了所有可能的合并方式以及合并顺序，这也是其与线段树上合并信息的不同点 "信息间的合并顺序会对结果产生影响"


#under_construction
[凸包的三角剖分与区间dp的结合](  )


对于代价随着时间的变化而增长，满足条件后停止增长的问题，可以考虑把每一时刻的代价表示为每一时刻未满足条件的代价的和 [修缮长城](https://www.luogu.com.cn/problem/UVA1336) ，或是将每一段的代价乘上未来累计所需的时间 [修车](https://www.luogu.com.cn/problem/P2053)

对于字符串的拼接问题，也可以使用区间dp去解决 [机密文件](https://www.luogu.com.cn/problem/P2400)

对于树上问题，尝试将树拍成一个序列(中序遍历，dfn等)，转化为序列上dp，就可以进行区间dp了 [# P1864 NOI2009 二叉查找树](https://www.luogu.com.cn/problem/P1864)

动态加点，维护树的直径，可以考虑加点过后计算其到直径两端的距离，然后判断其是否为新的直径即可 [# CF2006E Iris's Full Binary Tree](https://www.luogu.com.cn/problem/CF2006E)

对于取值区间只不交或包含的情况，可以考虑区间dp解决，若外部套了一个状压，且状压一定时长度相等，区间dp部分可以优化至 $O(n^2)$ [# P10197 USACO24FEB Minimum Sum of Maximums P](https://www.luogu.com.cn/problem/P10197)