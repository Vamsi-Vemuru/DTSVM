clc
clear all
close all

tic

%Loading Data
[lbl,inst]=libsvmread('trainingset_energy100_10-2_twoclass');
[tlbl,tinst]=libsvmread('gentestset_energy100_10-2_twoclass');
[flbl,finst]=libsvmread('fortestset_energy100_10-2_twoclass');

disp('Default parameters without scaling');
model0=svmtrain(lbl,inst,'-q');
[pred0,accu0,dec0]=svmpredict(tlbl,tinst,model0);
[predf0,accuf0,decf0]=svmpredict(flbl,finst,model0);
% fprintf('FRR = %g%%',100-accu0*100);
% fprintf('\nFAR = %g%%\n\n',accuf0*100);

%Scaling to [-1,1] and reconverting to sparse matrices
%tmax=max([inst; tinst]);
tmax=max([inst; tinst; finst]);
%tmin=min([inst; tinst]);
tmin=min([inst; tinst; finst]);
inst=sparse(scalemaxmin(inst,tmax,tmin));
tinst=sparse(scalemaxmin(tinst,tmax,tmin));
finst=sparse(scalemaxmin(finst,tmax,tmin));

disp('Default parameters with scaling');
model1=svmtrain(lbl,inst,'-q');
[pred1,accu1,dec1]=svmpredict(tlbl,tinst,model1);
[predf1,accuf1,decf1]=svmpredict(flbl,finst,model1);
% fprintf('FRR = %g%%',100-accu1*100);
% fprintf('\nFAR = %g%%\n\n',accuf1*100);

%Run this code once to find best c and g then change the c and g for model2
bestcv = 0;
for log2c = 6.9:0.025:7.1
  for log2g = -6.1:0.025:-5.9
    cmd = ['-q -v 3 -c ', num2str(2^log2c), ' -g ', num2str(2^log2g)];
    cv = svmtrain(lbl,sparse(scalemaxmin(inst,tmax,tmin)), cmd);
    if (cv >= bestcv)
      bestcv = cv; bestc = 2^log2c; bestg = 2^log2g;
    end
	  fprintf('%g %g %g (best c=%g, g=%g, rate=%g)\n', log2c, log2g, cv, bestc, bestg, bestcv);
  end
end
cmd = ['-c ', num2str(bestc), ' -g ', num2str(bestg),' -q'];

disp('Chosen parameters with scaling');
disp('Training...');
model2=svmtrain(lbl,inst,cmd);
disp('Predicting...');
[pred2,accu2,dec2]=svmpredict(tlbl,tinst,model2);
% fprintf('\nFRR = %g%%',100-accu2*100);
[predf2,accuf2,decf2]=svmpredict(flbl,finst,model2);
% fprintf('\nFAR = %g%%\n\n',(accuf2)*100);

toc
