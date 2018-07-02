function[ConnectionShip]=OverConnection(ConnectionShip)
%%确定索引个数
%%将每一个线粒体赋一个初始值
Length=length(ConnectionShip.Matrix)+1;
%% 给每个FinalPoint和和分裂合并点一个初始的索引
%第三列代表给定的索引值
%第一列代表该初始索引在那一层
%第二列代表该初始索引在哪一个区域
Count=0;
Indexs=[];
for i=1:Length
    StartPoint=cell2mat(ConnectionShip.StartPoint(i,1));%第一次出现的点设为起始点
    for j=1:length(StartPoint)
        Count=Count+1;
        Indexs=[Indexs;i,StartPoint(j),Count];
    end
end
%  初始化分裂的点   在下一层
for i=1:Length
    Split=cell2mat(ConnectionShip.SplitPointPairNew(i,1)); %分裂的点  设为初始点
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

%%给属于同一个线粒体的分割区域加上同一个索引
%%对每一个初始化的点只寻找一对一的连接
for Count=1:length(Indexs)
    InitPoint=Indexs(Count,:);
    PointSet=InitPoint;
    TempLayer=InitPoint(1);
    TempLabel=InitPoint(3);
    if TempLayer<Length
        TempIndex=InitPoint(2);
        FinalPoint=cell2mat(ConnectionShip.FinalPoint(TempLayer,:));
        %如果当前点不是终止点
        while ismember(TempIndex,FinalPoint)==0&&TempLayer<Length  %判断当前线粒体在不在终止层   若在，直接跳出循环
            OneToOne=cell2mat(ConnectionShip.OneToOne(TempLayer,1));
            if ismember(TempIndex,OneToOne(:,1))==1 %当前点与之前点一一对应
                TempLayer=TempLayer+1;
                IndexX=find(OneToOne(:,1)==TempIndex);
                TempIndex=OneToOne(IndexX,2);
                PointSet=[PointSet;TempLayer,TempIndex,TempLabel];%将一一对应的线粒体加入该label中
                FinalPoint=cell2mat(ConnectionShip.FinalPoint(TempLayer,:));
            else
                TempLayer
            end
        end
    end
    Indexs1(Count,1)={PointSet};
end
ConnectionShip.Indexs=Indexs1;
%%根据分裂合并点   连接
%%第三列代表给定的索引值
%%第一列代表该初始索引在那一层
%%第二列代表该初始索引在哪一个区域
