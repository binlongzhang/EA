# VLPSO-FS

## 项目简介

- data - 存放数据
- PSO.m 修改dataname之后，直接运行基本的PSO算法
- VLPSO.m 同上，运行VLPSO算法
- VLPSO_LS 同上，运行VLPSO_LS算法

## 算法简介

- 主要目的：减少计算复杂度

- 属于filter和wrapper的混合方法

- 单目标优化

- 创新

  - 利用exemplar更新速度（来源于CLPSO并非该文提出）

  $$
  v^{t+1}_{id} = w*v^t_{id}+ c*r_{id}*(p^t_{exmplar(id)d}-x^t_{id})
  $$

  - exemplar的分配：

    - 因为可变长度会导致对应例子没有对应维度，因此不能任意选择粒子，必须要保证维度存在；
    - 尝试寻找exemplar的次数直接定位popsize

  - 选择exemplars时候需要决定是否选自己的PC是动态自适应的，主要是基于fitness的排名；
    $$
    Pc_i = 0.05+0.45*\frac{exp^{\frac{10(rank(i)-1)}{ppsize-1}}}{exp^{10}-1}
    $$
    
- 种群长度的变化：
  
  - 种群划分为不同尺寸的组
    - 最优fitness的尺寸最后被定义为最大尺寸长度，其他的按照组依次改变长度，所差的维度随机生成
  
- 特征排序：
  
  - 使用symmetric uncertainty（对称不确定性）
  
    1. 对称不确定性论文中的方法和网上方法不同，但不影响排序
  
    2. 计算熵时，连续性变量使用差分熵，连续性变量的概率不好处理
      3. 样本数量少，拟合概率密度函数精度差（目前使用分组的方法）
  
- 长度改变：
  
  - 各组依次修正长度，所差变量随机生成（可改进），更新Pc和exemplar
  
- fitness函数
  
  - 基于混合平衡准确率（少样本）和样本距离（曼哈顿距离）度量，但其中使用用于权衡的lambda的数据没有给出；
    - The training data is scaled to the range of [0,1].训练数据集的距离缩放还是变量维度缩放，前者几乎对fitness无影响；
  
- alpha次pbest不更新则更新exemplar
  
- beta次gbest不更新改变种群长度
  
- 还将2016《A PSO Based Hybrid Feature Selection Algorithm for High-Dimensional Classifification》中的local search引入；利用SU来进行局部特征的加入或删除以寻找更优解；胆文章没有具体说明如何应用local search我参考了2016年那篇文章中的设置，但是可能因为SU的计算复杂度太高，运行时间过久；
  
- 因为该算法较为复杂，因此选用的数据结构较为复杂，这可能是时间性能无法达到论文中结果的最主要原因；不过可以确定的是时间复杂度上：VLPSO-LS > PSO > VLPSO;

## 问题

- 该方法每个维度的更新都是独立的；
- 虽然使用了SU来给特征排序，但没有从本质上解决FS一直存在的——“多个相关性弱的特征联合起来相关性强”的问题；
- 文中提到了多数情况使用二进制编码效果较差，但是使用浮点数编码多次进化不同个体，可能有相同的表现性，重复计算和对比给计算带来了巨大负担，此处是否为一个改进方向；

