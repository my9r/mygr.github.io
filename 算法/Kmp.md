kmp的fail数组既可以指**最长的前后缀长度**，也可以指**当前位的最长的前缀匹配**，也可以指**最长的循环节长度**

#under_construction 
[字符串的所有前缀中，有多少个可以构成形如 "ABABA" 由 k 个A 组成的字符串]()

通过不断跳fail的方式可以求出最短的前缀匹配，可以通过继承优化到 $O(n+m)$ [例子](https://www.luogu.com.cn/problem/P3435) 

