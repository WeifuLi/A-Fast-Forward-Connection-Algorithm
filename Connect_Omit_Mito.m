function[ConnectionShip]=Connect_Omit_Mito(ConnectionShip)
Omit=ConnectionShip.Omit;
IndexsM=cell2mat(ConnectionShip.FinalConnection);
for j=1:size(Omit,1)  
    IndexP=Omit(j,1:2);
    [~,IndexX]=ismember(IndexP,IndexsM(:,1:2),'rows');
    labelX=IndexsM(IndexX,3);
    IndexN=Omit(j,3:4);
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

%% 将相同label的放到一个cell里面
Count=0;
U=unique(IndexsM(:,3));
for i=1:length(U)
    IndexI=find(IndexsM(:,3)==U(i));
    Count=Count+1;
    ConnectionShip.FinalConnection1(Count,1)={IndexsM(IndexI,:)};
end