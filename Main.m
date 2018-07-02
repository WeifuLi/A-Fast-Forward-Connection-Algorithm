%���ڷָ�������ȡ���²�����ӹ�ϵ
clc; clear;

%% load ����
tic
ResultPath='.\Data\';%�ָ���·��
Dir=dir([ResultPath,'*.png']);
t=0;
for j=1:length(Dir)
%     if  j==11
%     end
    filename=Dir(j).name;
    Result=imread([ResultPath filename]);
    %     Result=Result(1:4000,4001:end);%��Сͼ ���Դ���
    Coordinate=regionprops(Result>0,'BoundingBox');
    Coordinate=round(cell2mat((struct2cell(Coordinate))'));
    Coordinate(:,3)=Coordinate(:,3)+Coordinate(:,1);
    Coordinate(:,4)=Coordinate(:,4)+Coordinate(:,2);
    Coordinate=[Coordinate ones(size(Coordinate,1),1)];
    t=t+1;
    Points(t,1)={Coordinate};
    Images(t,1)={Result};
end

%%��ȡ��ʼ������
LowThresold=0.01;HighThresold=0.4;
[ConnectionShip]=CoarseConnection(Points,LowThresold,HighThresold);
%%�÷ָ���ϢУ���ʼ���ӹ�ϵ�еķ��Ѻϲ���
Threshold2=0.03;lambda=0.5; 
[ConnectionShip]=Validation(Images,ConnectionShip,Threshold2,lambda);
toc
%%��ÿһ�������帳һ����ʼֵ
[ConnectionShip]=OverConnection(ConnectionShip);
%%���ݷ��Ѻϲ���ȡ��ͬ�����ӹ�ϵ
[ConnectionShip]=FineConnection(ConnectionShip);
%%������Ƭ�ٻ������
[ConnectionShip]=Obtain_Omit_Segmentation(Images,ConnectionShip,Threshold2,lambda);
%%���Ӷϲ�ĵ�
[ConnectionShip]=Connect_Omit_Mito(ConnectionShip);
save ConnectionShip0.5.mat ConnectionShip




