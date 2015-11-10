function keyval=energyfeatures(ip)
lvl=5;
z=dtcwt(ip);

keyenergy=ones(size(z{lvl}{1}));
    
for i=1:6
     keyenergy=keyenergy.*z{lvl}{i};
end

keyval=keyenergy.^(1/6);
keyval=keyval(:)';

 

