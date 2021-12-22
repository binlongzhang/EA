# EA
- 一些进化算法简单实现
- 详细的运行发放时可以参考对应算法内部的readme

## GeneticAlgorithm

该项目用两个经典问题展示遗传算法在对应问题上的应用

- 求解非线性函数极值问题
- TSP问题

注意：

1. 主要流程在 main.m 脚本中，其中各节功能已经写明，具体地方的注释也已标明，包括关键变量存储的数据也已在注释中说明，直接运行main.m即可看到示例；
2. 相关的辅助函数已经写明了注释、输入、输出等；
3. 遗传算法也有可能会陷入到局部最优解；

## PSO&ACA

包含了经典的粒子群算法和蚁群算法示例

## NSGAⅡ

> Deb K, Pratap A, Agarwal S, et al. A fast and elitist multiobjective genetic algorithm: NSGA-II[J]. IEEE transactions on evolutionary computation, 2002, 6(2): 182-197.

以ZDT-1为例

## NSPSOFS&CMDPSOFS&NSGAⅡFS

> Xue B, Zhang M, Browne W N. Particle swarm optimization for feature selection in classification: A multi-objective approach[J]. IEEE transactions on cybernetics, 2012, 43(6): 1656-1671.

## VLPSO

> Tran B, Xue B, Zhang M. Variable-length particle swarm optimization for feature selection on high-dimensional classification[J]. IEEE Transactions on Evolutionary Computation, 2018, 23(3): 473-487.

## PSO_EMT

> Chen K, Xue B, Zhang M, et al. An evolutionary multitasking-based feature selection method for high-dimensional classification[J]. IEEE Transactions on Cybernetics, 2020.

- 数据以 .mat 的格式放在data文件夹下
  - 数据格式：**X** : (*InsNum \* Features*)
  - 标签格式：**Y** : (*InsNum \* 1*)
- main为主函数入口，修改运行数据文件名即可运行

## SM_MOEA_FS

> Cheng F, Chu F, Xu Y, et al. A Steering-Matrix-Based Multiobjective Evolutionary Algorithm for High-Dimensional Feature Selection[J]. IEEE Transactions on Cybernetics, 2021.