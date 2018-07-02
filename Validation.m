function[ConnectionShip]=Validation(Images,ConnectionShip,Threshold2,lambda)
% �÷ָ���ϢУ���ʼ���ӹ�ϵ�еķ��Ѻϲ���
%% ConnectionShip ��ʼ�������ӹ�ϵ
%% Images ͨ���㷨�õ��Ķ�ֵͼ
%% ���� �Գ�ʼ�������ӹ�ϵ�����Ʒ��Ѻϲ��ĵ��ʹ�÷ָ���ϢУ��
%% ���õ������Ʒ��Ѻϲ��ĵ�Ե�Ȩ��С�ڸ�����Threshold2
%% �����Ӿ���˴���ֵΪ0�õ��µ����Ӿ���C
%% �ٸ���C��ȡ�µ����ӹ�ϵ
Length=length(Images);
ConnectionShip.MergePointPairNew=cell(Length,1);
ConnectionShip.SplitPointPairNew=cell(Length,1);
ConnectionShip.MoreToMore=cell(Length,1);
for i=1:Length-1
    %%  ���÷ָ���ϢУ���ʼ�������ӹ�ϵC  ����ȡ�µ����Ӿ���C
    ImageUp=cell2mat(Images(i,1));
    ImageDown=cell2mat(Images(i+1,1));
    [BwUp,~]=bwlabel(ImageUp);
    [BwDown,~]=bwlabel(ImageDown);
    C=cell2mat(ConnectionShip.Matrix(i,1)); %%���һ
    C=double(C);
    %     PointPairCoarse=cell2mat(ConnectionShip.PointPairCoarse(i,1)); %%���һ
    MiddleCorr=cell2mat(ConnectionShip.MiddleCorr(i,1)); %%���һ
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
    %%�����µ����Ӿ���C  ��ȡ�µ����ӹ�ϵ  %%��ֵ������
    C=C.*double(C>Threshold2);
%     [Cx,Cy]=find((C<Threshold2)&(C>0));
%     if isempty(Cx)==0
%         for k=1:length(Cx)
%             if sum(find(C(Cx(k),:))>1)==1&& sum(find(C(:,Cy(k)))>1)==1%%
%                 C(Cx(k),Cy(k)) =C(Cx(k),Cy(k)) .*double(C(Cx(k),Cy(k))>0.1);
%             else
%                 RowSum=sum(C(Cx(k),:));
%                 ColSum=sum(C(:,Cy(k)));
%                 if C(Cx(k),Cy(k))<RowSum||C(Cx(k),Cy(k))<ColSum %%���ַ��Ѻϲ������
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
    A=sum(C,1);%�������
    IndexA0=find(A==0);
    ConnectionShip.StartPoint(i+1,1)={IndexA0};
    B=sum(C,2);%�������
    IndexB0=find(B==0);%��һ�������һ���������������ֹ��    �²�û���������Ӧ����
    ConnectionShip.FinalPoint(i,1)={IndexB0};
    Split=[];
    Merge=[];
    OneToOne=[];%�ҵ�һ��һ�����Ӷ�
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
%%����һ��������������ʼ��
ConnectionShip.StartPoint(1,1)={[1:size(cell2mat(ConnectionShip.MatrixNew(1,1)),1)]};
%%�����һ�������������յ�
ConnectionShip.FinalPoint(Length,1)={[1:size(cell2mat(ConnectionShip.MatrixNew(Length-1,1)),2)]'};


