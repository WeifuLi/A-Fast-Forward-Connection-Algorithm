%基于分割结果来获取上下层的连接关系
clc; clear;

%% load 数据
tic
ResultPath='.\Data\';%分割结果路径
Dir=dir([ResultPath,'*.png']);
t=0;
for j=1:length(Dir)
%     if  j==11
%     end
    filename=Dir(j).name;
    Result=imread([ResultPath filename]);
    %     Result=Result(1:4000,4001:end);%做小图 调试代码
    Coordinate=regionprops(Result>0,'BoundingBox');
    Coordinate=round(cell2mat((struct2cell(Coordinate))'));
    Coordinate(:,3)=Coordinate(:,3)+Coordinate(:,1);
    Coordinate(:,4)=Coordinate(:,4)+Coordinate(:,2);
    Coordinate=[Coordinate ones(size(Coordinate,1),1)];
    t=t+1;
    Points(t,1)={Coordinate};
    Images(t,1)={Result};
end

%%获取初始的连接
LowThresold=0.01;HighThresold=0.4;
[ConnectionShip]=CoarseConnection(Points,LowThresold,HighThresold);
%%用分割信息校验初始连接关系中的分裂合并点
Threshold2=0.03;lambda=0.5; 
[ConnectionShip]=Validation(Images,ConnectionShip,Threshold2,lambda);
toc
%%将每一个线粒体赋一个初始值
[ConnectionShip]=OverConnection(ConnectionShip);
%%根据分裂合并获取相同的连接关系
[ConnectionShip]=FineConnection(ConnectionShip);
%%考虑切片毁坏的情况
[ConnectionShip]=Obtain_Omit_Segmentation(Images,ConnectionShip,Threshold2,lambda);
%%连接断层的点
[ConnectionShip]=Connect_Omit_Mito(ConnectionShip);
save ConnectionShip0.5.mat ConnectionShip




