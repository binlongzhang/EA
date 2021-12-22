# 遗传算法

> 遗传算法，也叫Genetic Algorithm，简称 GA 算法，其通过染色体(Chromosome)来代表其需要求解的解，通过是模仿基因遗传、“物竞天择，适者生存”来不断选择具有优良性状的个体。

## 核心思路

1. 待求解问题编码；
2. 种群初始化；
3. 适应度计算；
4. 自然选择（淘汰劣势物种，利用轮盘赌）；
5. 交叉；
6. 变异（基因突变/基因重组）；
7. 循环N个epoch到2；
8. 解码最终种群来获取待求解问题的解；

## 项目介绍

该项目用两个经典问题展示遗传算法在对应问题上的应用

- 求解非线性函数极值问题
- TSP问题

注意：

1. 主要流程在 main.m 脚本中，其中各节功能已经写明，具体地方的注释也已标明，包括关键变量存储的数据也已在注释中说明，直接运行main.m即可看到示例；

2. 相关的辅助函数已经写明了注释、输入、输出等；
3. 遗传算法也有可能会陷入到局部最优解；
