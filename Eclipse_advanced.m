%Eclipse Analysis

%Right, here's what we need:
%
%   Satellite position wrt venus: r
%
%   Venus position wrt sun: r_s
%
%   Eclipse Condition: |r cross r_s|<=r_venus
%                               AND
%                           r dot r_s <=0
%
%   Compute Eclipse time, etc
%
%   Orbit time = 39.4207 minutes
%

AC=astro_constants([1,12,22]); %1,12,22 for venus

G=AC(1); %G in km^3/(kg*s^2)         
GMv=AC(2); %Mass * G in km^3/s^2
r_v=(AC(3)); %Radius of Venus in km
Rh=550;%Height of satellite above Venus surface in km
mission_start=61836;
mission_end=mission_start+365; %62292
flag=0;
i=0;
j=0;
rho=asin(r_v/(r_v+Rh)); %Shadow angle phi/2
Porbit=(2*pi*(r_v^(3/2)))/sqrt(GMv); %Orbital Period

%Position of satellite wrt venus
r = readmatrix('Satellite_position.xlsx','Sheet','Sheet1','Range','H8:J118270');

for x=mission_start:mission_end
    j=j+1;
    r_s=EphSS(2,mission_start+(x-1));

%%Finding Beta

inc=uplanet(mission_start+(x-1),2);
inc=inc(3)+1.5708; %Orbital Inclination w/ polar orbit
Omega=uplanet(mission_start+(x-1),2);
Omega=Omega(4);%Right Ascension of Ascending Node


Nv=[sin(inc)*sin(Omega);-sin(inc)*cos(Omega);cos(inc)].';

Sv=-r_s;

phi=acos((dot(Sv,Nv))/(norm(Sv)*norm(Nv)));

Beta = phi-(pi/2);

            if abs(Beta)<rho
                fe=(1/180)*acos((sqrt((Rh^2)+(2*r_v*Rh)))/((r_v+Rh)*cos(Beta)));
            else
                fe=0;
            end
            Te(j)=Porbit*fe;

end

figure (1)
hold on
grid on
grid minor
title('Eclipse Analysis From Start of Arrival Window for 1 Earth Year')
xlabel('Modified Julian Date')
ylabel('Eclipse Time (minutes)')
plot(mission_start:1:mission_end,Te)
hold off
max_eclipse=max(Te);
min_eclipse=min(Te);
fprintf('The maximum eclipse time: %s\n',num2str(max_eclipse));
fprintf('The minimum eclipse time: %s\n',num2str(min_eclipse));








