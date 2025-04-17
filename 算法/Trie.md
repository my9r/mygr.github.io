
对于 Trie 树上全局+1的问题，可以考虑从低到高位建 Trie 树，问题就转化为对 Trie 树上的右链从下往上反转儿子

对于全局 $+k$ 的问题，则可以考虑打标记，设当前位的标记为 $v$ 

+ 若 $v$ 为偶数，则左右儿子的标记 $+\frac{v}{2}$ 即可
+ 若 $v$ 为奇数，则对右儿子 $+\left\lceil\frac{v}{2}\right\rceil$，对左儿子 $+\left\lfloor\frac{v}{2}\right\rfloor$，翻转左右儿子即可
