% %% Pork-chop plot VENUS TO EARTH
% 
clear all
muS=astro_constants(4); % Sun gravity constant in km^3/s^2

%Note: I just assumed sample collection time to be about 2 months or so,
%who knows if thats right or not but we can change it in the future if
%needs be

td_start= 61898; % put here the opening of the possible departure dates in days 61841+sample collection time(62) %NEW ARRIVAL OPENING 61835
td_end= 62711;  % put here the closing of the possible departure dates in days (61841+sample collection time(62))+137
ToF0=100; %minimum flight time in days
dToF=170; %window after flight time in days
nsteps_i = 813; %increases plot resolution 
nsteps_j = 500;
for i=1:nsteps_i
    ti(i)=td_start+(td_end-td_start)*(i-1)/(nsteps_i-1);
    for j=1:nsteps_j
        ToF(j)=(ToF0+dToF*(j-1)/(nsteps_j-1)); % time of flight in seconds
        tj(j)=ti(i)+ToF(j);
        [RE,vV]=EphSS(2,ti(i)); % Position and velocity of Venus at time ti(i)
        [RA,vE]=EphSS(3,tj(j)); % Position and velocity of the Earth at time tj(j)

[A,P,E,ERROR,VI,VF,TPAR,THETA] = lambertMR(RE,RA,ToF(j)*86400,muS,0,0,0);
v1(i,j)=(norm(vV-VI));
v2(i,j)=(norm(vE-VF));
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

figure (5)
contourf(ti,ToF,dv','ShowText','on')
xlabel('Depature Date (MJD)')
ylabel('Time of Flight (Days)')
title('Venus to Earth Transfer')

%Changes zeros to NaN so it doesn't just make the min value 0
for j=1:size(dv,1)
    for z=1:size(dv,2)
        if dv(j,z)==0
            dv(j,z)=nan;
        end
    end
end

dv=round(dv,1);

figure (6)
contour(ti,ToF,dv',[4,5,6,7])
xlabel('Depature Date (MJD)')
ylabel('Time of Flight (Days)')
title('Venus to Earth Transfer')

[v1_out,v2_out,v1_z,v2_z]=DeltaVs(ti,tj,ToF,dv,muS,v1,v2);
minimum = min(min(dv));
[i,j]=find(dv==minimum);
day=flip(ti(i));
time=ToF(j);

%Returns optimal MJD and Flight time

INBOUNDTakeoffopen=round(day(1),5,"significant");
INBOUNDTakeoffclose=round(day(end),5,"significant");
INBOUNDFlightTimeOpen=time(1);
INBOUNDFlightTimeClose=time(end);
INBOUNDMinDV=minimum
INBOUNDArrivalOpen=INBOUNDTakeoffopen+round(INBOUNDFlightTimeOpen);
INBOUNDArrivalClose=INBOUNDTakeoffclose+round(INBOUNDFlightTimeClose);
fprintf('Departure window opening: %s\n',num2str(INBOUNDTakeoffopen));
fprintf('Departure window closing: %s\n',num2str(INBOUNDTakeoffclose));
%fprintf('v1 at start of window: %s and at end of window: %d \n', v1_out(1) ,v1_out(end));
%fprintf('v2 at start of window: %s and at end of window: %d \n', v2_out(1) ,v2_out(end));
%fprintf('The ToF at window opening date is: %s\n',num2str(INBOUNDFlightTimeOpen));
%fprintf('The ToF at window closing date is: %s\n',num2str(INBOUNDFlightTimeClose));
fprintf('Earth arrival window opening: %s\n',num2str(INBOUNDArrivalOpen));
anchor=62432;
fprintf('Earth arrival window closing: %s\n',num2str(anchor));%INBOUNDArrivalClose));
[im,ia,ic]=unique(i);
for counter=1:length(ia)
    jm(counter)=j(ia(counter));
end
for counter=1:length(im)
    v1_array(counter)=v1((im(counter)),(jm(counter)));
    v2_array(counter)=v2((im(counter)),(jm(counter)));
    date_array(counter)=round(ti(im(counter)),5,"significant");
    ToF_array(counter)=ToF(jm(counter));
end

figure (7)
hold on
grid on 
grid minor
title('Venus to Earth v1 and v2 visualisation')
xlabel('Modified Julian Date')
ylabel('v1 (km/s)')
plot(date_array,v1_array)
yyaxis right
plot(date_array,v2_array)
ylabel('v2 (km/s)')
legend('v1','v2','location','north')

figure (8)
hold on
grid on 
grid minor
title('Venus to Earth ToF visualisation')
xlabel('Modified Julian Date')
ylabel('ToF (Days)')
plot(date_array,ToF_array)