clear all
close all

nPics=11;
SFlist=[1 2 4 8];

thetaList=[0 pi/6 pi/3 pi/2 2*pi/3 5*pi/6];

outputMatrix=zeros(nPics,length(SFlist),length(thetaList));

picList=dir('../images/*.jpeg'); 

for pic=1:nPics
    pic
    ImgName=['../images/' picList(pic).name];
    Img = double(imread(ImgName));

    for s=1:length(SFlist)
        SF=SFlist(s);
        for t=1:length(thetaList)
            theta=thetaList(t);
            outputMatrix(pic,s,t)=applyAngleFilters_AllRotations(Img,SF,theta,0);
            close all
        end
    end
end

%normalize
normData=zeros(size(outputMatrix));
for t=1:length(thetaList)
    for p=1:nPics
        for sf=1:length(SFlist)
            temp=outputMatrix(:,sf,t);
            normData(:,sf,t)=(temp-min(temp(:)))/(max(temp(:))-min(temp(:)));
        end
    end
end

finalData=squeeze(mean(normData,2));

%rank images and output
[val,ind]=sort(finalData(:,4),'ascend');


outDir='../images/sorted/';
if isdir(outDir)==0
    mkdir(outDir);
end

for p=1:nPics
    Img=imread(['../images/',picList(ind(p)).name]);
    
    imwrite(Img,[outDir,num2str(p),'.jpeg'],'JPEG');
end
