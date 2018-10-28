function [Se, eHinge] = ElevatorSizing(PlotLiftDis, ESizingMethod,data, Shtp)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%Generic Variables
ElevatorDefMax = 25; % Maxinum aileron deflection. Degrees
ElevatorDefMaxR = deg2rad(ElevatorDefMax); % Maxinum aileron deflection. Radians
Clto = (data('MTOW')*9.81)/(0.5*data('rhoSL')*(data('Vmc')*1.05)^2*data('S')); % Lift coefficient at TO. 1.05 data('Vmc')
Cdto = 0.0176; %Drag Coefficient at take off taken from aerodynacics spreadsheer
Vbar = (Shtp/data('S'))*(data('lhtp')/data('MAC'));
PitchAngAcc = 5; % Required pitch angular acceleration for aircraft. deg/s^2
PitchAngAccR = deg2rad(5); % Required pitch angular acceleration for aircraft. rad/s^2


if ESizingMethod ==0
    %First Pass of Sizing
    % Data taken form Roskam II
    SeSh = 0.40; % Elevator area/horizontail area ratio
    eHinge = 0.70; %Elevator hinge lotation of percentace of htp MAC
    
    Se = data('SeSh')*Shtp; %Elevator area using area ratio
    
else
    %Detailed Evelator Sizing
    bebh = 1; % Elevator area/horizontail span ratio
    
    Lwf = 0.5*data('rhoSL')*(data('Vmc')*1.05)^2*Clto*data('S'); % Wing Fusalage Lift
    Lhtp = 0.5*data('rhoSL')*(data('Vmc')*1.05)^2*data('CltMin')*Shtp;
    Dto = 0.5*data('rhoSL')*(data('Vmc')*1.05)^2*Cdto*data('S'); % TO Drag
    Mac = 0.5*data('rhoSL')*(data('Vmc')*1.05)^2*data('Cm0')*data('S')*data('MAC'); %Pitching moment about aerodynamic center
    
    LinAcc = (data('TotalTRot')-Dto)/data('MTOW'); % Linear acceleration during TO rotation.
    
    Mw = data('MTOW')*(data('XcgFWD')-data('xMLG')); % Weight moment contribution
    Md = Dto*(data('zd')); % Drag moment contribution
    Mt = -(data('TotalTRot')*(data('zt'))); % Thrust moment contribution
    Mlwf = -(Lwf*(data('XcgFWD')-data('noseto25MAC'))); % Wing lift moment contribution
    Ma = LinAcc*data('MTOW')*(data('zcg')-data('zMLG')); % Linear Acceleration moment contribution
    
    Iyy = (data('b')^2*data('MTOW')*9.81*data('Rybar')^2)/(4*9.81); %Initial class 1 calculation of moment of intetia using radius of gyration
    
    Lh = (Mlwf+Mac+Ma-Mw+Md-Mt-(Iyy*(PitchAngAcc)))/((data('noseto25MAC')+data('lhtp'))-data('xMLG')); % Required tailplane lift for rotation
    
    Clh1 = Lh/(0.5*data('rhoSL')*(data('Vmc')*1.05)^2*Shtp); % Required tailplane lift coefficient to rotation
    Clh1 = -Clh1;
    
    e = 1.5; % Downwash angle due to ground effect during TO. Degrees
    eR = deg2rad(e); % Downwash angle due to ground effect during TO. Rad
    
    ElevatorEff = ((Clh1/data('ahtpNC'))-(data('etaTR')-eR))/ElevatorDefMaxR; % Elevator effectiveness
    
    CeCh = 0.36; % Dependent on ElevatorEff
    
    %Run function to use lifting line theory to find HTP lift coeffitient using
    %elevator infomation
    delta_a_0 = -1.15*(CeCh)*ElevatorDefMax;
    Clh2 = LiftingLineTheory(PlotLiftDis, data('ARh'), data('bh'), delta_a_0, data('TaperRh'), data('ahtp2D'), data('bebh'), data('etaTR'), data('MACh'));
    
    if Clh1*0.95<Clh2<Clh1*1.05
        Clh1
        Clh2
    else
        Clh1
        Clh2
        disp('Required lift coefficient does not match actual lift coefficient please change bebh')
    end
    Se = data('MACh')*CeCh*data('bh')*bebh;
    eHinge = 1-CeCh;
end
end
