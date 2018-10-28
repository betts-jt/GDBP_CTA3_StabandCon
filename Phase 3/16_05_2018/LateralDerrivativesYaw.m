function [Yr, YrF, Nr, Lr] = LateralDerrivativesYaw(Svtp,data)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%% Calculation of sideforce due to yaw derrivatives. Yr
% Body component. (Yr)b - ESDU 83026
Yrb = (-0.04*data('lf')*data('Sbs'))/(data('b')*data('S'))

% Fin component. (Yr)F - ESDU 82017
YvFjw = (-0.98*1.105*data('avtpNC')*Svtp/2)/data('S');

zff = 2.19+0.85*0.59;
lff = (data('nosetoVtpMAC')-data('cgPos'))+0.7*0.59*tan(deg2rad(30));


YrF = (YvFjw*(lff*cos(deg2rad(data('alpha')))+zff*sin(deg2rad(data('alpha')))))/data('b')

Yr = Yrb + YrF;

%% Calculation of yaw moment due to yaw derrivatives. Nr
% Wing component. (Nr)w - ESDU 71017
Cd0 = 0.0179; % Cd0 at point being analysed
Cl= 2.7; %Cl at point being analysed
Nrw = 0.124*Cd0-0.013*data('Clp')^2

% Body component. (Nr)b - ESDU 83026
Nrb = (-0.01*data('lf')^2*data('Sbs'))/(data('b')^2*data('S'))


NrF = (-YrF*(lff*cos(deg2rad(data('alpha')))+zff*sin(deg2rad(data('alpha')))))/data('b')

% Flap component. (Nr)f - ESDU 71017
deltaCd0 = 0.1; %Increment increase in drag coefficient due to flap deployment
f = 0.45; % From figure 3

if data('flapsDep') == 1
    Nrf = 0.124*f*sec(deg2rad(2))*deltaCd0
else
    Nrf=0;
end

Nr = Nrw + Nrb + NrF + Nrf;


%% Calculation of roll moment due to yaw derrivatives. Lr
% Wing component. (Lr)w - ESDU 71017
Lrw = (1/data('avtpNC'))*0.395*data('Clp')

% Fin component. (Nr)F - ESDU 82017
LrF = (YrF*(zff*cos(deg2rad(data('alpha')))-lff*sin(deg2rad(data('alpha')))))/data('b')

% Flap component. (Lr)f - ESDU 71017
if data('flapsDep') == 1
    Lrf = -0.0167
else
    Lrf = 0;
end

Lr = Lrw + LrF + Lrf;
end

