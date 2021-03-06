# Ant Colony Optimization

>蚁群算法模拟自然界蚂蚁群体的觅食行为，用蚂蚁的行走路径表示待优化问题的可行解，整个蚂蚁群体群体的所有路径构成待优化问题的解空间。路径较短的蚂蚁释放的信息素量较多，随着时间的推进，较短的路径上累积的信息素浓度逐渐增高，选择该路径的蚂蚁个数也越来越多。最终，整个蚂蚁会在正反馈的作用下集中到最佳的路径上，此时对应的便是待优化问题的最优解。

## 核心

- 选择机制：信息素越多的路径，被选择的概率越大。
- 更新机制：路径上面的信息素会随蚂蚁的经过而增长，而且同时也随时间的推移逐渐挥发消失。
- 协调机制：通过种群个体遗留信息来实现互相通信、协同工作的。

# 流程

## 蚁群流程

- 蚂蚁在路径上释放信息素。
- 碰到还没走过的路口，就随机挑选一条路走。同时，释放与路径长度有关的信息素。
- 信息素浓度与路径长度成反比。后来的蚂蚁再次碰到该路口时，就选择信息素浓度较高路径。
- 最优路径上的信息素浓度越来越大。
- 最终蚁群找到最优寻食路径

## 算法流程

1. 初始，各节点上无信息素

2. 蚂蚁k根据信息素（*Tau*）决定 *t* 轮时从 *i* 城到下一个访问的城市 *j* 的概率
   $$
   P_i^k = 
   \begin{cases}
   \frac{Tau_{ij}(t)^\alpha\cdot{\eta_{ij}(t)}^\beta}{\sum_{s\in allow_k}},& j\in allow_k \\
   0,& j\notin allow_k
   
   \end{cases}
   $$
   其中，$\eta_{ij}(t) = \frac1{d_{ij}}$为启发函数，表示蚂蚁k从i移动到j点的期望程度；

   $allow_k$表示蚂蚁待访问城市集合$\alpha$为信息素程度重要因子，为启发函数重要因子，根据需要调整大小；

3. 更新信息素
   $$
   Tau_{ij}(t+1) = (1-\rho)\cdot Tau_{ij}(t) + \Delta Tau_{ij}(t)\\
   其中，\Delta Tau_{ij}(t) = \sum^{popNum}_{k=1}{\Delta Tau^k_{ij}(t)}\\
   $$
   其中$\Delta Tau^k_{ij}(t)$表示第k只蚂蚁在i到j的路上的信息素，$\Delta Tau_{ij}(t)$表示所有蚂蚁在i到j上的信息素之和，$\rho$表示挥发程度；

   关于蚂蚁释放信息素的方法有三种常见模型：

   - ant cycle system：每只蚂蚁在整个路径上释放的信息素总量一定
   - ant quantity system：妹纸蚂蚁在相邻城市路径上释放的信息总量一定
   - ant density system：无论距离长短释放相同信息素

4. 判断终止条件：达到最大轮数

