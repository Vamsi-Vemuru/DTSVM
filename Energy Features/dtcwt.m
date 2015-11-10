function im_out=dtcwt(im_in)
im1=double(im_in);% conversion to double.
%figure;
%imagesc(im1);colormap(gray);
filt_cfs=dtfilters('dtf1');% creates a 1x2 cell array with first stage and all other stage filter banks.
img_dtcwt=dddtree2('cplxdt',im1,5,filt_cfs{1},filt_cfs{2});%dtcwt
im_out={};

for lvl=1:5
    i=1;
    for tree=1:2
        for ori=1:3
            real_cfs=img_dtcwt.cfs{lvl}(:,:,ori,tree,1);
            % real cfs .cfs{j}(:,:,d,k,m)j = 1,2,..., level is the level. 
            % d = 1,2,3 is the orientation. k = 1,2 is the wavelet transform tree. m = 1,2 are the real and imaginary parts.
            imag_cfs=img_dtcwt.cfs{lvl}(:,:,ori,tree,2);%%imaginary cfs.
            cplx_cfs=real_cfs+1i*imag_cfs;%complex values
            im_out{lvl}{i}=abs(cplx_cfs);%magnitude of the coeffs
            i=i+1;
        end
    end
end

%im_out=im_out(:)';%vectorising.
%imagesc(cplx_mag_matrix);
%colormap(gray);

