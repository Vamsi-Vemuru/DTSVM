function demo()
clc
clear all
close all

i=457;
img_rd=imread(strcat('\Aditya\Biometrics\EnergyDtSvm\gen24each\',num2str(i),'.bmp'));
disp('PREPROCESSING')
disp('Original Image')
figure('units','normalized','outerposition',[0 0 1 1]);
hold on
subplot(2,3,1),subimage(img_rd)
imshow(img_rd);
title('1.Original Image')
pause

[m,n]=size(img_rd);
if(m>n)
    img_rd=img_rd';
end
im_res=imresize(img_rd,[256 512]); %resizing to 256x512
disp('Resized Image')
subplot(2,3,2),subimage(im_res)
imshow(im_res);
title('2.Resized Image')
pause


im_adj=imadjust(im_res);%adjust contrast
disp('Contrast Adjusted Image')
subplot(2,3,3),subimage(im_adj)
imshow(im_adj);
title('3.Contrast Adjusted Image')
pause

im_bin=im2bw(im_adj,0.4);%binarizing
disp('Binarized Image')
subplot(2,3,4),subimage(im_bin)
imshow(im_bin);
title('4.Binarized Image')
pause


ppo=~(bwmorph(~im_bin,'thin',Inf));%thinning the signature strokes
disp('Thinned Image')
subplot(2,3,5),subimage(ppo)
imshow(ppo);%colormap(gray);
title('5.Thinned Image')
pause
disp('Press Enter to continue...')
disp('-------------------------------')

z=dtcwt(ppo);
lvl=5;
disp('DTCWT OUTPUT')
figure('units','normalized','outerposition',[0 0 1 1]);
keyenergy=ones(size(z{lvl}{1}));

for i=1:6
    subplot(3,3,i),subimage(z{lvl}{i})
    imshow(z{lvl}{i});
    title(strcat('Orientation',num2str(i)))
    keyenergy=keyenergy.*z{lvl}{i};
end
pause
disp('Press Enter to continue...')
disp('-------------------------------')

disp('FINAL FEATURE IMAGE')
keyval=keyenergy.^(1/6);
subplot(3,3,8),subimage(keyval)
imshow(keyval);
title('Final Feature Image')
pause
disp('Press Enter to continue...')
close all
pause