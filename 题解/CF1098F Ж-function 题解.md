
转换到SA数组上，先考虑 $rk_i > rk_l$ 的部分

我们要求的其实就是
$$\sum_{i\in [rk_l,R]}[l \le sa_i \le r]\min( \min_{j\in[rk_l,i-1]}h_j,r-sa_i+1)$$
发现这个 $h$ 在不同询问时很难解决，所以考虑分治，设分治中心为 $mid$， $pre_i=\min_{j\in [mid,i-1]}h_j$ ，$suf_i=\min_{j\in [i,mid-1]}h_j$  ，那么式子就转化为了

$$\sum_{i\in [rk_l,R]}[l \le sa_i \le r]\min( \min(suf_{rk_l},pre_{i}  ) ,r-sa_i+1)$$
<details>
<summary> 假掉的点子</summary>
欸我有个点子，不妨将 $min$ 拆开，得到

$$\sum_{i\in [rk_l,R]}[l \le sa_i \le r]\min( suf_{rk_l},\min(pre_{i},r-sa_i+1))$$
我们发现后面那个式子可以视作一个关于 $r$ 的分段函数，所以我们考虑在当前的分治区间对所有询问的 $r$ 从小到大排序，然后对所有 $i$ 按照 “是否有 $r-sa_i+1>pre_i$” 分为两部分分别统计答案，枚举询问的过程中将不满足条件的扔至另一个集合中

对于 $r-sa_i+1>pre_i$ ，显然是一个二维数点问题

哦不行，最后还是变成三位偏序了

</details>

考虑容斥，我们先去计算

$$\sum_{i\in [rk_l,R]}[l \le sa_i \le r]\min(suf_{rk_l},pre_{i}  ) $$
(离线扫描线)
然后再加上

$$\begin{eqnarray} &&\sum_{i\in [rk_l,R]}[l \le sa_i \le r \wedge r-sa_i+1 \le \min(suf_{rk_l},pre_{i}  )]r-sa_i+1-\min(suf_{rk_l},pre_{i}  )\\
&&\sum_{i\in [rk_l,R]}[\max(l,r+1-\min(suf_{rk_l},pre_i) )\le sa_i \le r]r-sa_i+1-\min(suf_{rk_l},pre_{i}  )\\
\end{eqnarray}$$
怎么感觉变麻烦了还（

再来一遍，令 $\min(suf_{rk_l},pre_i)=suf_{rk_l}$ ，则有

$$\sum_{i\in [rk_l,R]}[\max(l,r+1-suf_{rk_l} )\le sa_i \le r]r-sa_i+1-suf_{rk_l}$$
这玩意可以普通线段树维护

接下来还要加上

$$\sum_{i\in [rk_l,R]}[\max(l,r+1-pre_i)\le sa_i \le r]suf_{rk_l}-pre_{i}$$
这仍然是一个二维数点问题

所以说我们最后要求的就是

$$\begin{eqnarray}  
&& \sum_{i\in [rk_l,R]}[l \le sa_i \le r]\min(suf_{rk_l},pre_{i}  )\\
&+& \sum_{i\in [rk_l,R]}[\max(l,r+1-suf_{rk_l} )\le sa_i \le r]r-sa_i+1-suf_{rk_l}\\
&+& \sum_{i\in [rk_l,R]}[l\le sa_i \le r \wedge ,r\le sa_i+pre_i-1]suf_{rk_l}-pre_{i}\\
\end{eqnarray}$$
















总结一下啥时候才能用这样的转化方法：能化简出来的时候

变相的其实就是在枚举这三个 $\min$ 中哪个元素作为最小元素

之前假掉的那个点子为啥没法那么化简，就是因为本质上他还是没有跳脱出二维数点这个范畴

我们先来分析下原先的式子中有哪些维度，如果你将 $pre_i$ 视作值域维的话，那会有三维

为什么转换能通呢？其实不是“删去”了某些维度，而是“合并”了一些维度

当我们钦定有 $r-sa_i+1 \le \min(suf_{rk_l},pre_i)$ 时，我们就产生了 $r-\min(suf_{rk_l},pre_i)+1\le sa_i$ 的关系，于是就能够与 $[l\le sa_i \le r]$ 产生合并

其实就已经变为了一个二维问题，但问题在于 $pre_i$ 是一个变量，但同时 $suf_{rk_l}$ 是一个常量，所以可以考虑拆解为两个优势区间解决

所以总的来说，遇到式子中的 $\min$ 有两种处理方法

1. 容斥，用总方案减去不合法方案
2. 拆分，枚举 $\min$ 中的最小值
然后遇到多维问题时，尝试变量是否能够合并 ($sa_i$)，从而带来维度的合并
