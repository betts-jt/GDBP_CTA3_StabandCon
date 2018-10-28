function [Yv, Nv, Lv] = LateralDerrivativesSideslip(Svtp, data)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%% Calculation of sideforce due to sideslip derrivatives. Yv
% Wing/Body component. (Yv)wb - ESDU 79006
F = 0.006; %From Figure 2
Fw = 0.8; %From Figure 3
Yvwb= -((0.0714+0.674*(data('Zf')^2/data('Sbs'))+((data('Zf')*data('b')*F*Fw)/data('Sbs'))*(4.95*(data('Zw')/data('Zf'))-0.12))*(data('S')/data('Sbs'))+0.006*(data('dihedralA')));

% Nacel component. (Yv)n - ESDU 79006
Yvn = (-pi()*data('MaxEngineNacelWidth')^2*((0+0.5*data('MaxEngineNacelWidth'))/data('MaxEngineNacelWidth'))^1.5)/data('S');

% Fin Component. (Yv)F - ESDU 82010
YvF = -0.98*1.105*1.225*data('avtpNC')*Svtp/data('S');

% Flap component. (Yv)f - ESDU 82010
deltaClf = .7; %Increment increase in lift coefficient due to flap deployment
if data('flapsDep') == 1;
    Yvf = -deltaClf*0.05+YvF*.225*deltaClf;
else
    Yvf=0;
end
Yv = Yvwb+Yvn+YvF+Yvf


%% Calculation of yawing moment due to sideslip derrivatives. Nv
% Wing Body component (Nv)wb - ESDU 79006
A = 0.2575+((data('lf')^2/data('Sbs'))*(0.0008*(data('lf')^2/data('Sbs'))-0.024));
B = 1.39*(data('h1')/data('h2'))^0.5-0.39;
C = (data('Sbs')*data('lf'))/(data('S')*data('b'));

Nvmid = -(A*B*C);
Nvwb = Nvmid + ((data('XcgAFT')-0.5*data('lf'))/data('b'))*Yv;

% Fin conponent. (Nv)F - ESDU 82010
NvF = YvF*(((data('nosetoVtpMAC')-data('cgPos'))+0.7*0.59*tan(deg2rad(30)))*cos(deg2rad(data('alpha')))+2.19+0.85*0.59*sin(deg2rad(data('alpha'))))/data('b');

% Flap component. (Nv)f - ESDU 82010
deltaClf = .7; %Increment increase in lift coefficient due to flap deployment
if data('flapsDep') == 1
    Nvf = NvF*.225*deltaClf;
else
    Nvf=0;
end
Nv = Nvwb+NvF+Nvf;

%% Calculation of rolling moment due to sideslip derrivatiives. Lv
% Wing Planform component (Lv)w - ESDU 80033
LvwCl = 0.04; % (Lv)w/Cl. Calculated using Figure 1a-1d
Lvw = LvwCl*data('Clp');

% Body Component. (Lv)b - ESDU 73006
Lvb = -data('ZLA')*(0.014*(data('lf')/data('b'))*(data('Sbs')/data('S')));

% Wing body interfearence component. (Lv)h = ESDU 73006
Lvh = 0.015*(1+(data('Zf')/data('Zf')))*1.265;

% Fin Component. (Lv)F - Esdu 82010
LvF = (YvF*((2.19+0.85*0.59)*cos(deg2rad(data('alpha')))-(data('nosetoVtpMAC')-data('cgPos'))+0.7*0.59*tan(deg2rad(30))*sin(deg2rad(data('alpha')))))/data('b');

%Flap Contribution. (Lv)f - ESDU 80034
% Only applicable f flaps are deployed
if data('flapsDep') == 1
    Lvf = deltaClf*0.035;
else
    Lvf=0;
end

% Calculating rolling moment due to sideslip
Lv = Lvw+Lvb+Lvh+LvF+Lvf;

end

