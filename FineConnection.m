function[ConnectionShip]=FineConnection(ConnectionShip)
IndexsM=cell2mat(ConnectionShip.Indexs);
Length=length(ConnectionShip.Matrix)+1;
for  i=1:Length-1
    PointPair=cell2mat(ConnectionShip.PointPairFine(i,1)); %%多对一
    for j=1:size(PointPair,1)
        IndexP=[i PointPair(j,1)];
        [~,IndexX]=ismember(IndexP,IndexsM(:,1:2),'rows');
        labelX=IndexsM(IndexX,3);
        IndexN=[i+1 PointPair(j,2)];
        [~,IndexY]=ismember(IndexN,IndexsM(:,1:2),'rows');
        labelY=IndexsM(IndexY,3);
        if labelX>labelY
            IndexLabelX=find(IndexsM(:,3)==labelX);
            IndexsM(IndexLabelX,3)=labelY;
        else
            IndexLabelY=find(IndexsM(:,3)==labelY);
            IndexsM(IndexLabelY,3)=labelX;
        end
    end
end

%% 将相同label的放到一个cell里面
Count=0;
U=unique(IndexsM(:,3));
for i=1:length(U)
    IndexI=find(IndexsM(:,3)==U(i));
    Count=Count+1;
    ConnectionShip.FinalConnection(Count,1)={IndexsM(IndexI,:)};
end