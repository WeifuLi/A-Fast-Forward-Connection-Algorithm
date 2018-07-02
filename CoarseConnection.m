function[ConnectionShip]=CoarseConnection(Points,LowThresold,HighThresold)
%% ��ȡ��ʼ������
%% Points������  �������ÿ���ָ������boundbox
Step=1;%%���Ƕ����Ϣ ��һ����ڶ���  ��һ���������  ��һ�����Step+1�����Ϣ��������©���
Length=length(Points);
for i=1:Length-1
    Up=cell2mat(Points(i,1));
    for j=1:min(Step,Length-i)
        Down=cell2mat(Points(i+j,1));
        [OverlapRatio]=Connection(Up,Down);
%         C=OverlapRatio>0; 
%        %%
%        %% ���Ƿ��Ѻϲ����������Щ���ʹ�÷ָ���Ϣ����У��
%         A=sum(C,1);%�������
%         IndexA2=find(A>1);%�����������ֺϲ������
%         ConnectionShip.MergePoint(i,1)={IndexA2};
%         Merge=[];
%         for M=1:length(IndexA2)
%             IndexM=find(C(:,IndexA2(M))==1);
%             Merge=[Merge;IndexM IndexA2(M)*ones(length(IndexM),1)];
% %             ConnectionShip.MergePointPair(i,M)={[IndexM IndexA2(M)*ones(length(IndexM),1)]};
%         end
%               
%         B=sum(C,2);%�������
%         IndexB2=find(B>1);%��������ַ��ѳɶ�������
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
       %%  ����Щ��Է�Ϊ������صĵ�ԣ�����صĵ�ԣ���صĵ�ԡ� �Ե���صĵ��ֵ��ֵΪ0������صĵ������ʹ�÷ָ���ϢУ�飬����صĵ��������
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