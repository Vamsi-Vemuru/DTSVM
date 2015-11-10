%Cleaning up

demo % comment this line if you do not want the demo to run

clc
clear all
close all

tic

%Loading Data
[lbl,inst]=libsvmread('trainingset_energy100');%change these files for loading different training sets
[tlbl,tinst]=libsvmread('gentestset_energy100');
[flbl,finst]=libsvmread('fortestset_energy100');

disp('Default parameters without scaling');
model0=ovrtrain(lbl,inst,'-q');
[pred0,accu0,dec0]=ovrpredict(tlbl,tinst,model0);
[predf0,accuf0,decf0]=ovrpredict(flbl,finst,model0);
fprintf('False Rejection Ratio = %g%%',100-accu0*100);
fprintf('\nFalse Acceptance Ratio = %g%%',accuf0*100);
AER0=((100-accu0*100)+(accuf0*100))/2;
fprintf('\nAverage Error Rate = %g%%\n\n',AER0);

%Scaling to [-1,1] and reconverting to sparse matrices
%tmax=max([inst; tinst]);
tmax=max([inst; tinst; finst]);
%tmin=min([inst; tinst]);
tmin=min([inst; tinst; finst]);
inst=sparse(scalemaxmin(inst,tmax,tmin));
tinst=sparse(scalemaxmin(tinst,tmax,tmin));
finst=sparse(scalemaxmin(finst,tmax,tmin));

disp('Default parameters with scaling');
model1=ovrtrain(lbl,inst,'-q');
[pred1,accu1,dec1]=ovrpredict(tlbl,tinst,model1);
[predf1,accuf1,decf1]=ovrpredict(flbl,finst,model1);
fprintf('False  Rejection Ratio = %g%%',100-accu1*100);
fprintf('\nFalse Acceptance Ratio = %g%%',accuf1*100);
AER1=((100-accu1*100)+(accuf1*100))/2;
fprintf('\nAverage Error Rate = %g%%\n\n',AER1);

%%%Cross Validation to find bestc and bestg
% disp('Beginning cross-validation');
% bestcv = 0;
% %log2g=-7;
% log2c=4;
% %for log2c = 5:0.2:6,
%   for log2g = -4:0.2:-3,
%     cmd = ['-q -c ', num2str(2^log2c), ' -g ', num2str(2^log2g)];
%     cv = get_cv_ac(lbl, inst, cmd, 3);
%     if (cv >= bestcv),
%       bestcv = cv; bestc = 2^log2c; bestg = 2^log2g;
%     end
%     fprintf('%g %g %g (best c=%g, g=%g, rate=%g)\n', log2c, log2g, cv, bestc, bestg, bestcv);
%   end
% % end
% disp(['The best parameters, yielding Accuracy =',num2str(bestcv*100),'%, are: C=',num2str(bestc),', gamma=',num2str(bestg)]);

%This is for rough testing, DO NOT USE
%    for log2g = -11:1:-7,
%        c = 2^log2c; g = 2^log2g;
%        cmd1 = ['-c ', num2str(c), ' -g ', num2str(g),' -q'];
%        model2=ovrtrain(lbl,inst,cmd1);
%        [pred2,accu2,dec2]=ovrpredict(tlbl,tinst,model2);
%        fprintf('%g %g (c=%g, g=%g, accuracy=%g)\n', log2c, log2g, c, g, accu2);
%    end
% end
%log2c=1, log2g=-8 accuracy=84.75%

% #######################
% Automatic Cross Validation 
% Parameter selection using n-fold cross validation
% #######################
% stepSize = 10;
% bestLog2c =1;%0; %1;
% bestLog2g =-1;%-7;% -1;
% epsilon = 0.005;
% bestcv = 0;
% Ncv = 3; % Ncv-fold cross validation cross validation
% deltacv = 10^6;
% 
% while abs(deltacv) > epsilon
%     bestcv_prev = bestcv;
%     prevStepSize = stepSize;
%     stepSize = prevStepSize/2;
%     log2c_list = bestLog2c-prevStepSize:stepSize/2:bestLog2c+prevStepSize;
%     log2g_list = bestLog2g-prevStepSize:stepSize/2:bestLog2g+prevStepSize;
%     
%     numLog2c = length(log2c_list);
%     numLog2g = length(log2g_list);
%     cvMatrix = zeros(numLog2c,numLog2g);
%     
%     for i = 1:numLog2c
%         log2c = log2c_list(i);
%         for j = 1:numLog2g
%             log2g = log2g_list(j);
%             cmd = ['-q -c ', num2str(2^log2c), ' -g ', num2str(2^log2g)];
%             cv = get_cv_ac(lbl, inst, cmd, Ncv);
%             if (cv >= bestcv),
%                 bestcv = cv; bestc = 2^log2c; bestg = 2^log2g;
%             end
%         end
%     end
%     deltacv = bestcv - bestcv_prev;
%     
% end
% disp(['The best parameters, yielding Accuracy=',num2str(bestcv*100),'%, are: C=',num2str(bestc),', gamma=',num2str(bestg)]);

bestc=2^4; % these values have been obtained from running cross validation manually
bestg=2^-3.4;
cmd1 = ['-c ', num2str(bestc), ' -g ', num2str(bestg),' -q'];
disp('Chosen parameters with scaling');
disp('Training...');
model2=ovrtrain(lbl,inst,cmd1);
disp('Predicting...');
[pred2,accu2,dec2]=ovrpredict(tlbl,tinst,model2);
fprintf('\nFalse Rejection Ratio = %g%%',100-accu2*100);
[predf2,accuf2,decf2]=ovrpredict(flbl,finst,model2);
fprintf('\nFalse Acceptance Ratio = %g%%',(accuf2)*100);
AER2=((100-accu2*100)+(accuf2*100))/2;
fprintf('\nAverage Error Rate = %g%%\n\n',AER2);

toc
