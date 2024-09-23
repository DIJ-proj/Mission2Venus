% Pork-chop plot EARTH TO VENUS
%
clear all
muS=astro_constants(4); % Sun gravity constant in km^3/s^2

td_start= 61041; % put here the opening of the possible departure dates in days 61041
td_end= 61854;  % put here the closing of the possible departure dates in days 62502
ToF0=100; %minimum flight time in days
dToF=170; %window after flight time in days
nsteps_i = 813; %increases plot resolution
nsteps_j = 500;
for i=1:nsteps_i
    ti(i)=td_start+(td_end-td_start)*(i-1)/(nsteps_i-1);
    for j=1:nsteps_j
        ToF(j)=(ToF0+dToF*(j-1)/(nsteps_j-1)); % time of flight in seconds
        tj(j)=ti(i)+ToF(j);
        [RE,vE]=EphSS(3,ti(i)); % Position and velocity of the Earth at time ti(i)
        [RA,vA]=EphSS(2,tj(j)); % Position and velocity of Venus at time tj(j)

[A,P,E,ERROR,VI,VF,TPAR,THETA] = lambertMR(RE,RA,ToF(j)*86400,muS,0,0,0);
v1(i,j)=(norm(vE-VI));
v2(i,j)=(norm(vA-VF));


dv(i,j)= v1(i,j)+v2(i,j);
        
        if dv(i,j) > 20
           dv(i,j) = 20;
        elseif dv(i,j) < -20
            dv(i,j) = -20;
        end
    end
end
%x = -10:1:10;
%y = -10:1:10;
%[X,Y] = meshgrid(x,y);
%Z = X.*exp(-X.^2-Y.^2);

figure (1)
contourf(ti,ToF,dv','ShowText','on')
xlabel('Depature Date (MJD)')
ylabel('Time of Flight (Days)')
title('Earth to Venus Transfer')



%Changes zeros to NaN so it doesn't just make the min value 0
for j=1:size(dv,1)
    for z=1:size(dv,2)
        if dv(j,z)==0
            dv(j,z)=nan;
        end
    end
end

dv=round(dv,2);

figure (2)
contour(ti,ToF,dv',[6.35,6.4,6.45,6.5])
xlabel('Depature Date (MJD)')
ylabel('Time of Flight (Days)')
title('Earth to Venus Transfer')


%Returns optimal MJD and Flight time
[v1_out,v2_out,v1_z,v2_z]=DeltaVs(ti,tj,ToF,dv,muS,v1,v2);
minimum = min(min(dv));
[i,j]=find(dv==minimum);
day=flip(ti(i));
time=ToF(j);
OUTBOUNDTakeoffopen=round(day(1),5,"significant");
OUTBOUNDTakeoffclose=round(day(end),5,"significant");
OUTBOUNDFlightTimeOpen=time(1);
OUTBOUNDFlightTimeClose=time(end);
OUTBOUNDMinDV=minimum
OUTBOUNDArrivalOpen=round(OUTBOUNDTakeoffopen+OUTBOUNDFlightTimeOpen,5,"significant");
OUTBOUNDArrivalClose=round(OUTBOUNDTakeoffclose+OUTBOUNDFlightTimeClose,5,"significant");
fprintf('Launch window opening: %s\n',num2str(OUTBOUNDTakeoffopen));
fprintf('Launch window closing: %s\n',num2str(OUTBOUNDTakeoffclose));
%fprintf('The ToF at window opening date is: %s\n',num2str(OUTBOUNDFlightTimeOpen));
%fprintf('The ToF at window closing date is: %s\n',num2str(OUTBOUNDFlightTimeClose));
%fprintf('v1 at start of window: %s and at end of window: %d \n', v1_out(1) ,v1_out(end));
%fprintf('v2 at start of window: %s and at end of window: %d \n', v2_out(1) ,v2_out(end));
fprintf('Venus arrival window opening: %s\n',num2str(OUTBOUNDArrivalOpen));
fprintf('Venus arrival window closing: %s\n',num2str(OUTBOUNDArrivalClose));
[im,ia,ic]=unique(i);
for counter=1:length(ia)
    jm(counter)=j(ia(counter));
end
for counter=1:length(im)
    v1_array(counter)=v1((im(counter)),(jm(counter)));
    v2_array(counter)=v2((im(counter)),(jm(counter)));
    date_array(counter)=round(ti(im(counter)));
    ToF_array(counter)=round(ToF(jm(counter)));
    
end
figure (3)
hold on
grid on 
grid minor
title('Earth to Venus v1 and v2 visualisation')
xlabel('Modified Julian Date')
ylabel('v1 (km/s)')
plot(date_array,v1_array)
yyaxis right
plot(date_array,v2_array)
ylabel('v2 (km/s)')
legend('v1','v2','location','north')

figure (4)
hold on
grid on 
grid minor
title('Earth to Venus ToF visualisation')
xlabel('Modified Julian Date')
ylabel('ToF (Days)')
plot(date_array,ToF_array)


