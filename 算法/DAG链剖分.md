
对于 DAG 上的节点，设 $f_{u}$ 表示以点 $u$ 为结束点的路径数，$g_u$ 表示从点 $u$ 开始的路径数，那么对于节点 $u$ 的所有出边，若存在一条边 $u \rightarrow v$ 使得 $2f_{v}>f_{u},2g_{v}>g_{u}$ ，那么我们则称 $u,v$ 是一条重边

对于任意一条路径，其路径上的轻边数量一定是 $O(logn)$ 级别的，因为每走一次轻边路径数都会折半

最常用的场景是在 [[后缀自动机]] 上快速的子串定位

为什么不倍增跳呢？ #under_construction

