# 进化多目标优化

## NSGAⅡ

该项目主要分三个部分：

- picture：用于存放文件“进化多目标优化.md”中的图片数据；

- 进化多目标优化.md :  进化多目标优化笔记，记录相关信息和算法流程；

- 代码：
  - function：交叉使用对应浮点型算术交叉，变异采用多项式变异；
  - main.m: 运行示例、主函数、结果可视化（针对 “ZDT1”）
  
- ZDT1 问题描述

  - Objective functions：(minimized)

  $$
  f_1(x)=x_1;\\
  f_2(x) = g(x)[1-\sqrt{\frac{x_1}{g_{(x)}}}];\\
  其中，g(x) = 1+9\frac{\sum^{n}_{i=2}x_i}{n-1}；
  $$

  - Variable bounds：		 $[0,1]$;
  - Optimal solutions:		 $x_1\in[0,1],x_i=0$;