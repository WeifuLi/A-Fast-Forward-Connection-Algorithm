function[ConnectionShip]=CoarseConnection(Points,LowThresold,HighThresold)
%% 获取初始的连接
%% Points是输入  代表的是每个分割区域的boundbox
Step=1;%%考虑多层信息 第一层与第二层  第一层与第三层  第一层与第Step+1层的信息，补上遗漏情况
Length=length(Points);
for i=1:Length-1
    Up=cell2mat(Points(i,1));
    for j=1:min(Step,Length-i)
        Down=cell2mat(Points(i+j,1));
        [OverlapRatio]=Connection(Up,Down);
%         C=OverlapRatio>0; 
%        %%
%        %% 考虑分裂合并的情况，这些点对使用分割信息进行校验
%         A=sum(C,1);%对列求和
%         IndexA2=find(A>1);%多个线粒体出现合并的情况
%         ConnectionShip.MergePoint(i,1)={IndexA2};
%         Merge=[];
%         for M=1:length(IndexA2)
%             IndexM=find(C(:,IndexA2(M))==1);
%             Merge=[Merge;IndexM IndexA2(M)*ones(length(IndexM),1)];
% %             ConnectionShip.MergePointPair(i,M)={[IndexM IndexA2(M)*ones(length(IndexM),1)]};
%         end
%               
%         B=sum(C,2);%对列求和
%         IndexB2=find(B>1);%线粒体出现分裂成多个的情况
%         ConnectionShip.SplitPoint(i,1)={IndexB2};        
%         Split=[];
%         for S=1:length(IndexB2)
%             IndexS=find(C(IndexB2(S),:)==1);
%             Split=[Split;IndexB2(S)*ones(length(IndexS),1) IndexS'];
% %             ConnectionShip.SplitPointPair(i,S)={[IndexB2(S)*ones(length(IndexS),1) IndexS']};
%         end
%         PointPairCoarse=[Merge;Split];
%         PointPairCoarse=unique(PointPairCoarse,'rows');
%         ConnectionShip.PointPairCoarse(i,j)={PointPairCoarse};
       %%
       %%  将这些点对分为：高相关的点对，中相关的点对，相关的点对。 对低相关的点对值赋值为0，中相关的点对重新使用分割信息校验，高相关的点无需计算
        OverlapRatio=double(OverlapRatio);
        C1=OverlapRatio.*(OverlapRatio>LowThresold);
        C2=OverlapRatio.*((OverlapRatio>LowThresold)&(OverlapRatio<HighThresold));
        [MiddleCorrX,MiddleCorrY]=find(C2>0);
        ConnectionShip.MiddleCorr(i,j)={[MiddleCorrX,MiddleCorrY]};
        ConnectionShip.Matrix(i,j)={C1};        
    end
end

for i=1:Length-2
    Up=cell2mat(Points(i,1));
    Down=cell2mat(Points(i+2,1));
    [OverlapRatio]=Connection(Up,Down);
    C=OverlapRatio>0;
    ConnectionShip.Matrix2(i,1)={C};
end