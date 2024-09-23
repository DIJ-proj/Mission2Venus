function [v1_out,v2_out,v1_z,v2_z]=DeltaVs(ti, tj, ToF, dv, muS, v1 ,v2)

%Finds minimum value in dv
minimum = min(min(dv));

%index location of min value
[i,j]=find(dv==minimum);
% for counter=1:15
%     [RE,vE]=EphSS(3,(ti(i(counter)))); % Position and velocity of the Earth at time ti(i)
%     [RA,vA]=EphSS(2,(tj(j(counter)))); % Position and velocity of Venus at time tj(j)
% 
%     [A,P,E,ERROR,VI,VF,TPAR,THETA] = lambertMR(RE,RA,ToF(j(counter))*86400,muS,0,0,0);
%     v1(counter)=(norm(vE-VI));
%     v2(counter)=(norm(vA-VF));
% end
[im,ia,ic]=unique(i);
for counter=1:length(ia)
    jm(counter)=j(ia(counter));
end
for counter=1:length(im)
    v1_out(counter)=v1(im(counter),jm(counter));
    v2_out(counter)=v2(im(counter),jm(counter));
    [RE,vE]=EphSS(3,(ti(im(counter))));
    [RA,vA]=EphSS(2,(tj(jm(counter))));
    [A,P,E,ERROR,VI,VF,TPAR,THETA] = lambertMR(RE,RA,ToF(jm(counter))*86400,muS,0,0,0);
    v1_zout=vE-VI;
    v1_z(counter)=v1_zout(3);
    v2_zout=vA-VF;
    v2_z(counter)=v2_zout(3);
end
return