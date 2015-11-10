function scaled=scalemaxmin(x,Mx,Mn)
[m n]=size(x);
mx=repmat(Mx,m,1);
mn=repmat(Mn,m,1);
scaled=2*((x-mn)./(mx-mn))-1;