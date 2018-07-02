function[ConnectionShip]=Validation(Images,ConnectionShip,Threshold2,lambda)
% 用分割信息校验初始连接关系中的分裂合并点
%% ConnectionShip 初始化的连接关系
%% Images 通过算法得到的二值图
%% 功能 对初始化的连接关系中疑似分裂合并的点对使用分割信息校验
%% 若得到的疑似分裂合并的点对的权重小于给定的Threshold2
%% 则将连接矩阵此处赋值为0得到新的连接矩阵C
%% 再根据C获取新的连接关系
Length=length(Images);
ConnectionShip.MergePointPairNew=cell(Length,1);
ConnectionShip.SplitPointPairNew=cell(Length,1);
ConnectionShip.MoreToMore=cell(Length,1);
for i=1:Length-1
    %%  利用分割信息校验初始化的连接关系C  并获取新的连接矩阵C
    ImageUp=cell2mat(Images(i,1));
    ImageDown=cell2mat(Images(i+1,1));
    [BwUp,~]=bwlabel(ImageUp);
    [BwDown,~]=bwlabel(ImageDown);
    C=cell2mat(ConnectionShip.Matrix(i,1)); %%多对一
    C=double(C);
    %     PointPairCoarse=cell2mat(ConnectionShip.PointPairCoarse(i,1)); %%多对一
    MiddleCorr=cell2mat(ConnectionShip.MiddleCorr(i,1)); %%多对一
    %     UpdatedPointPair=union(PointPairCoarse,MiddleCorr,'rows');
    UpdatedPointPair=MiddleCorr;
    PositionInfs=zeros(size(C));
    ShapeInfs=zeros(size(C));
    for j=1:size(UpdatedPointPair,1)
        U=UpdatedPointPair(j,1);
        D=UpdatedPointPair(j,2);
        ResultUp=BwUp==U;
        ResultDown=BwDown==D;
        CoordinateUp=regionprops(ResultUp,'BoundingBox');
        CoordinateUp=round(cell2mat((struct2cell(CoordinateUp))'));
        CoordinateDown=regionprops(ResultDown,'BoundingBox');
        CoordinateDown=round(cell2mat((struct2cell(CoordinateDown))'));
        Xp=min(CoordinateDown(2),CoordinateUp(2));
        Yp=min(CoordinateDown(1),CoordinateUp(1));
        Xh=max(CoordinateDown(2)+CoordinateDown(4),CoordinateUp(2)+CoordinateUp(4));
        Yh=max(CoordinateDown(1)+CoordinateDown(3),CoordinateUp(1)+CoordinateUp(3));
        ResultDown1=ResultDown(Xp:Xh-1,Yp:Yh-1);
        ResultUp1=ResultUp(Xp:Xh-1,Yp:Yh-1);
        PositionInf=sum(sum(ResultDown1&ResultUp1))/min(sum(sum(ResultDown1)),sum(sum(ResultUp1)));
        ShapeInf=ShapeInformation(ResultUp1,ResultDown1);
        Similarity=(PositionInf.^2+lambda*(ShapeInf.^2))/((1+lambda));
        PositionInfs(U,D)=PositionInf;
        ShapeInfs(U,D)=ShapeInf;
        C(U,D)=Similarity;
    end
    ConnectionShip.PositionInfs(i,1)={PositionInfs};
    ConnectionShip.ShapeInfs(i,1)={ShapeInfs};
    ConnectionShip.Similarity(i,1)={C};
    %%
    %%根据新的连接矩阵C  获取新的连接关系  %%阈值化操作
    C=C.*double(C>Threshold2);
%     [Cx,Cy]=find((C<Threshold2)&(C>0));
%     if isempty(Cx)==0
%         for k=1:length(Cx)
%             if sum(find(C(Cx(k),:))>1)==1&& sum(find(C(:,Cy(k)))>1)==1%%
%                 C(Cx(k),Cy(k)) =C(Cx(k),Cy(k)) .*double(C(Cx(k),Cy(k))>0.1);
%             else
%                 RowSum=sum(C(Cx(k),:));
%                 ColSum=sum(C(:,Cy(k)));
%                 if C(Cx(k),Cy(k))<RowSum||C(Cx(k),Cy(k))<ColSum %%出现分裂合并的情况
%                     if C(Cx(k),Cy(k))<0.2*RowSum&&C(Cx(k),Cy(k))<0.2*ColSum
%                         C(Cx(k),Cy(k))=0;
%                     end
%                 else
%                     C(Cx(k),Cy(k)) =C(Cx(k),Cy(k)) .*double(C(Cx(k),Cy(k))>0.1);
%                 end
%             end
%             
%         end
%     end
    C=double(C)>0;
    A=sum(C,1);%对列求和
    IndexA0=find(A==0);
    ConnectionShip.StartPoint(i+1,1)={IndexA0};
    B=sum(C,2);%对列求和
    IndexB0=find(B==0);%上一层是最后一层出现线粒体是终止层    下层没有线粒体对应连接
    ConnectionShip.FinalPoint(i,1)={IndexB0};
    Split=[];
    Merge=[];
    OneToOne=[];%找到一对一的连接对
    MoreToMore=[];
    [Cx,Cy]=find(C>0);
    if isempty(Cx)==0
        for k=1:length(Cx)
            if (sum(C(Cx(k),:))==1&&sum(C(:,Cy(k)))==1)
                OneToOne=[OneToOne;Cx(k),Cy(k)];
            end
            if (sum(C(Cx(k),:))>1&&sum(C(:,Cy(k)))==1)
                IndexS=find(C(Cx(k),:)==1);
                Split=[Split;Cx(k) Cy(k)];
            end
            if (sum(C(Cx(k),:))==1&&sum(C(:,Cy(k)))>1)
                IndexM=find(C(:,Cy(k))==1);
                Merge=[Merge;Cx(k) Cy(k)];
            end
            if (sum(C(Cx(k),:))>1&&sum(C(:,Cy(k)))>1)
                IndexM=find(C(:,Cy(k))==1);
                MoreToMore=[MoreToMore;Cx(k) Cy(k)];
            end
        end
    end
    ConnectionShip.SplitPointPairNew(i,1)={Split};
    ConnectionShip.MergePointPairNew(i,1)={Merge};
    ConnectionShip.OneToOne(i,1)={OneToOne};
    ConnectionShip.MoreToMore(i,1)={MoreToMore};
    ConnectionShip.EstimateNumber(i,1)=size(Split,1)+size(Merge,1)+size(OneToOne,1);
    [UpIndex1,~]=find(C==1);
    ConnectionShip.TrueNumber(i,1)=length(UpIndex1);
    AllPoints=[Split;Merge;OneToOne];
    ConnectionShip.PointPairFine(i,1)={[Split;Merge;MoreToMore]};
    ConnectionShip.Points(i,1)={AllPoints};
    ConnectionShip.MatrixNew(i,1)={C};
end
%%将第一层的线粒体加入起始点
ConnectionShip.StartPoint(1,1)={[1:size(cell2mat(ConnectionShip.MatrixNew(1,1)),1)]};
%%将最后一层的线粒体加入终点
ConnectionShip.FinalPoint(Length,1)={[1:size(cell2mat(ConnectionShip.MatrixNew(Length-1,1)),2)]'};


