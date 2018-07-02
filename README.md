# A-Fast-Forward-Connection-Algorithm
%主函数  Main
%子函数  CoarseConnection 利用bounding box获取粗的相似度,并利用双阈值LowThresold=0.01低阈值, HighThresold=0.4高阈值用于筛选
%子函数  Validation  对于相似度在双阈值中的部分使用分割信息进行校验 分割阈值Threshold2=0.03;正则化参数lambda=0.5;  并给与不同的类别标签
%子函数  OverConnection 给具有起止点标签的分割赋予一个不同的数值标签 并给相应具有一对一连接标签赋予想用的数值标签  
%子函数  FineConnection 将具有分裂合并标签的分割赋值较小的数值标签
%相关信息都保存在变量里面ConnectionShip.mat


%由于电镜图像质量存在皱褶，破损，亮度不均匀等问题，部分图像存在线粒体缺损的情况 这样就能出现分裂误差
%CoarseConnection 在函数Main_Based_Seg的基础上，考虑到图像缺损的情况计算了两层连接矩阵
%子函数Obtain_Omit_Segmentation 计算了当前层有终止点标签的分割和下两层有起止点标签的分割的相似度，获取中间有断层的分割
%子函数Connect_Omit_Mito 连接中间有断层的分割，赋值相同的数值标签
