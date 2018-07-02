function [ShapeInf]=ShapeInformation(ResultUp1,ResultDown1)
%通过很多个变化，取IoU最大的那个
X=[10 20 30 40];%半径
Y=0:pi/12:2*pi;%角度
[m,n]=size(ResultUp1);
M1=zeros(m+2*X(end),n+2*X(end));
M2=zeros(m+2*X(end),n+2*X(end));
M1(X(end)+1:end-X(end),X(end)+1:end-X(end))=ResultUp1;
M2(X(end)+1:end-X(end),X(end)+1:end-X(end))=ResultDown1;
ShapeInfs=zeros(length(X)*length(Y),1);
k=0;
for i=1:length(X)
    R=X(i);
    for j=1:length(Y)
        k=k+1;
        Angle=Y(j);
        x=round(R*cos(Angle));
        y=round(R*sin(Angle));
        M3=circshift(M1,[x y]); 
        ShapeInfs(k)=sum(sum(M2&M3))/sum(sum(M2|M3));
    end
end
ShapeInf=max(ShapeInfs);
end