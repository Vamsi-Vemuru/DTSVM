clc,clear all
close all

tc=[];
ts=[];
gtc=[];
gts=[];
ftc=[];
fts=[];

disp('Reading from files');
[lbl,inst]=libsvmread('trainingset_energy100');
[tlbl,tinst]=libsvmread('gentestset_energy100');
[flbl,finst]=libsvmread('fortestset_energy100');

i=1;
while i<size(inst,1)
    ts=[ts ; inst(i:i+9,:)];
    tc=[tc ; lbl(i:i+9,:)];
    if i<2000
        i=i+20;
    else
        i=i+25;
    end
end

for i=1:4:size(tinst,1)
    gts=[gts ; tinst(i:i+1,:)];
    gtc=[gtc ; tlbl(i:i+1,:)];
end

for i=1:5:size(finst,1)
    fts=[fts ; finst(i:i+1,:)];
    %ftc=[ftc ; flbl(i:i+1,:)];
end
 
% tc=[ones(1000,1);-1*ones(1000,1)];
% gtc=ones(size(gts,1),1);
ftc=-1*ones(size(fts,1),1);
ind=find(tc<0);
tc(ind)=-1;

disp('Writing into files');
libsvmwrite('trainingset_energy100_10-2_singleforgedclass', tc, ts);
libsvmwrite('gentestset_energy100_10-2_singleforgedclass', gtc, gts);
libsvmwrite('fortestset_energy100_10-2_singleforgedclass', ftc, fts);