相关链接：[[矩阵树定理]]，[[欧拉回路]]

对于一个有向图，对于它的欧拉回路个数 $ec(G)$ ，有

$$ec(G)=root_{w}(G)\sum_{v\in V}(deg_v -1)!$$其中 $root_w(G)$ 表示以 $w$ 为根的 $G$ 的外向生成树有多少种

注意BEST定理计算的是两点间若干条边有顺序的方案数，如果是 “某条边能够经过的次数” 则应当除去 $\frac{1}{w!}$ 将顺序消掉

## 例题：

[# Counting Prefixes](https://www.luogu.com.cn/problem/CF1919E)
[# C4](https://www.luogu.com.cn/problem/AT_agc051_d)

