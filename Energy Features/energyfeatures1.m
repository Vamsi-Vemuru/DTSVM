function keyval=energyfeatures1(ip)
lvl=5;
z=dtcwt(ip);

keyenergy=zeros(size(z{lvl}{1}));
    
for i=1:6
     keyenergy=keyenergy+z{lvl}{i};
end

keyval=keyenergy/6;
keyval=keyval(:)';