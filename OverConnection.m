function[ConnectionShip]=OverConnection(ConnectionShip)
%%ȷ����������
%%��ÿһ�������帳һ����ʼֵ
Length=length(ConnectionShip.Matrix)+1;
%% ��ÿ��FinalPoint�ͺͷ��Ѻϲ���һ����ʼ������
%�����д������������ֵ
%��һ�д���ó�ʼ��������һ��
%�ڶ��д���ó�ʼ��������һ������
Count=0;
Indexs=[];
for i=1:Length
    StartPoint=cell2mat(ConnectionShip.StartPoint(i,1));%��һ�γ��ֵĵ���Ϊ��ʼ��
    for j=1:length(StartPoint)
        Count=Count+1;
        Indexs=[Indexs;i,StartPoint(j),Count];
    end
end
%  ��ʼ�����ѵĵ�   ����һ��
for i=1:Length
    Split=cell2mat(ConnectionShip.SplitPointPairNew(i,1)); %���ѵĵ�  ��Ϊ��ʼ��
    Merge=cell2mat(ConnectionShip.MergePointPairNew(i,1));
    MoreToMore=cell2mat(ConnectionShip.MoreToMore(i,1));
    FinalPoint=cell2mat(ConnectionShip.FinalPoint(i,1));
    PointPair=[Split;Merge;MoreToMore];
    if isempty(PointPair)==0
        PairUp=PointPair(:,1);
        PairDown=PointPair(:,2);
        PairUp=unique(PairUp);
        PairDown=unique(PairDown);
        Indexs=[Indexs;(i+1)*ones(length(PairDown),1),PairDown (Count+1:Count+length(PairDown))'];
        Count=Count+length(PairDown);
        FinalPoint=unique([FinalPoint;PairUp]);
        ConnectionShip.FinalPoint(i,1)={FinalPoint};
    end
end

%%������ͬһ��������ķָ��������ͬһ������
%%��ÿһ����ʼ���ĵ�ֻѰ��һ��һ������
for Count=1:length(Indexs)
    InitPoint=Indexs(Count,:);
    PointSet=InitPoint;
    TempLayer=InitPoint(1);
    TempLabel=InitPoint(3);
    if TempLayer<Length
        TempIndex=InitPoint(2);
        FinalPoint=cell2mat(ConnectionShip.FinalPoint(TempLayer,:));
        %�����ǰ�㲻����ֹ��
        while ismember(TempIndex,FinalPoint)==0&&TempLayer<Length  %�жϵ�ǰ�������ڲ�����ֹ��   ���ڣ�ֱ������ѭ��
            OneToOne=cell2mat(ConnectionShip.OneToOne(TempLayer,1));
            if ismember(TempIndex,OneToOne(:,1))==1 %��ǰ����֮ǰ��һһ��Ӧ
                TempLayer=TempLayer+1;
                IndexX=find(OneToOne(:,1)==TempIndex);
                TempIndex=OneToOne(IndexX,2);
                PointSet=[PointSet;TempLayer,TempIndex,TempLabel];%��һһ��Ӧ������������label��
                FinalPoint=cell2mat(ConnectionShip.FinalPoint(TempLayer,:));
            else
                TempLayer
            end
        end
    end
    Indexs1(Count,1)={PointSet};
end
ConnectionShip.Indexs=Indexs1;
%%���ݷ��Ѻϲ���   ����
%%�����д������������ֵ
%%��һ�д���ó�ʼ��������һ��
%%�ڶ��д���ó�ʼ��������һ������
