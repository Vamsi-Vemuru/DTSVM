%Cleaning up
clc,clear all,close all

%a contains the raw image
%b contains the preprocessed image
%c contains the dtcwt energy features

%Loading training data and test data
tic
TrainingSet=[];
GenTestSet=[];
ForTestSet=[];
disp('Setting up the training set...');
i=1;
NumberOfPeople=100;
while i<24*NumberOfPeople
    j=i+19;
    while i<=j
        a=imread(strcat('\Aditya\Biometrics\EnergyDtSvm\gen24each\',num2str(i),'.bmp')); % channge the path as necessary
        b=preproc(a);
        d=energyfeatures1(b);
        TrainingSet=[TrainingSet;d];
        i=i+1;
    end
    while i<=j+4
        a=imread(strcat('\Aditya\Biometrics\EnergyDtSvm\gen24each\',num2str(i),'.bmp'));
        b=preproc(a);
        d=energyfeatures1(b);
        GenTestSet=[GenTestSet;d];
        i=i+1;
    end
end

i=1;
while i<30*NumberOfPeople
       j=i+24;
    while i<=j
        a=imread(strcat('\Aditya\Biometrics\EnergyDtSvm\forgy30each\',num2str(i),'.bmp'));
        b=preproc(a);
        d=energyfeatures1(b);
        TrainingSet=[TrainingSet;d];
        i=i+1;
    end
    while i<=j+5
        a=imread(strcat('\Aditya\Biometrics\EnergyDtSvm\forgy30each\',num2str(i),'.bmp'));
        b=preproc(a);
        d=energyfeatures1(b);
        ForTestSet=[ForTestSet;d];
        i=i+1;
    end
end
 
 


% for i=1:3000
%         a=imread(strcat('\Aditya\Biometrics\KeyDtSvm\forgy30each\',num2str(i),'.bmp'));
%         b=preproc(a);
%         d=energyfeatures(b);
%         ForTestSet=[ForTestSet;d];
% end


%Setting up class data
TrainClass=[];
TrainClass2=[];
GenTestClass=[];
ForgeTestClass=[];

for j=1:NumberOfPeople
  TrainClass=[TrainClass; j*ones(20,1)];
  TrainClass2=[TrainClass2; -j*ones(25,1)];
  GenTestClass=[GenTestClass; j*ones(4,1)];
  ForgeTestClass=[ForgeTestClass; j*ones(5,1)];
% ForgeTestClass=[ForgeTestClass; j*ones(30,1)];
end
TrainClass=[TrainClass; TrainClass2];

% TrainClass=[ones(2000,1); -1*ones(2500,1)];
% GenTestClass=ones(400,1);
% ForgeTestClass=-1*ones(500,1);

%Writing into files
disp('Writing into files');
libsvmwrite('trainingset_energy100_avg', TrainClass, sparse(TrainingSet));
libsvmwrite('gentestset_energy100_avg', GenTestClass, sparse(GenTestSet));
libsvmwrite('fortestset_energy100_avg', ForgeTestClass, sparse(ForTestSet));

toc
