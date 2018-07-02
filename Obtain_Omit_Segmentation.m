function[ConnectionShip]=Obtain_Omit_Segmentation(Images,ConnectionShip,Threshold2,lambda)
%% 
%%
% lambda=1;
Omit=[];
for i=1:29
    StartPoint=cell2mat(ConnectionShip.StartPoint(i+2)); %%多对一
    Matrix2=cell2mat(ConnectionShip.Matrix2(i)); %%多对一for
    FinalPoint=cell2mat(ConnectionShip.FinalPoint(i)); %%多对一
    ImageUp=cell2mat(Images(i,1));
    [BwUp,~]=bwlabel(ImageUp);
    ImageDown=cell2mat(Images(i+2,1));
    [BwDown,~]=bwlabel(ImageDown);
    for j=1:length(FinalPoint) 
        UpIndex=FinalPoint(j);
        Index=find(Matrix2(FinalPoint(j),:)>0);
        for k=1:length(Index)
            DownIndex=Index(k);
            if ismember(Index(k),StartPoint)
                ResultUp=BwUp==UpIndex;
                CoordinateUp=regionprops(ResultUp,'BoundingBox');
                CoordinateUp=round(cell2mat((struct2cell(CoordinateUp))'));
                ResultDown=BwDown==DownIndex;
                CoordinateDown=regionprops(ResultDown,'BoundingBox');
                CoordinateDown=round(cell2mat((struct2cell(CoordinateDown))'));
                Xp=min(CoordinateDown(2),CoordinateUp(2));
                Yp=min(CoordinateDown(1),CoordinateUp(1));
                Xh=max(CoordinateDown(2)+CoordinateDown(4),CoordinateUp(2)+CoordinateUp(4));
                Yh=max(CoordinateDown(1)+CoordinateDown(3),CoordinateUp(1)+CoordinateUp(3));
                ResultDown1=ResultDown(Xp:Xh-1,Yp:Yh-1);
                ResultUp1=ResultUp(Xp:Xh-1,Yp:Yh-1);
                PositionInf=2*sum(sum(ResultDown1&ResultUp1))/(sum(sum(ResultDown1))+sum(sum(ResultUp1)));
                ShapeInf=ShapeInformation(ResultUp1,ResultDown1);
                Similarity=(PositionInf.^2+lambda*(ShapeInf.^2))/((1+lambda));
                if Similarity>Threshold2
                    omit=[i, FinalPoint(j), i+2, Index(k)];
                    Omit=[Omit;omit];
                end
            end
        end
    end
end
ConnectionShip.Omit=Omit;