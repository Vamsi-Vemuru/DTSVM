function ppo=preproc(img_rd)
[m,n]=size(img_rd);
if(m>n)
    img_rd=img_rd;
end
im_res=imresize(img_rd,[256 512]); %resizing to 256x512
im_adj=imadjust(im_res);%adjust contrast
im_bin=im2bw(im_adj,0.4);%binarizing
ppo=~(bwmorph(~im_bin,'thin',Inf));%thinning the signature strokes
%figure;
%imagesc(im_th);colormap(gray);
