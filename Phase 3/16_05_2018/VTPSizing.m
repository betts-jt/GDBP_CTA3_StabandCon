function [Svtp, CDoei] = VTPSizing(plotVtpGraphs, data)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
MaxRudDef = 30; % Maximum rudder deflection angle. Degrees
MaxRubDefR = deg2rad(MaxRudDef); % Maximum rudder deflection angle. rad
CWMaxRubDefR = MaxRubDefR*0.7; % Maximum rudder deflection angle for cross wing landings. rad

Xcg = [data('XcgFWD'):0.05:data('XcgAFT')]; % range of cg positions. m

h = Xcg/data('MAC'); % range of non dimentional cg locations

BankA = 5; % Maximum allowable bank angle during OEI. Degrees
BankAR = deg2rad(BankA); % Maximum allowable bank angle during OEI. rad

% Engine Faliure Cases

% On Take Off
% Calculating Drag due to inoperative engine
WindmillDr = 0.1*(pi()/4)*((data('ScaledIntakeArea')*4)^0.5/pi()); % Windmill drag coefficient due to jet intake area
PropDr = 0.00125*(data('PropNum'))*(data('PropDia'))^2; % Drag coefficient due to propellers
CDoei = WindmillDr + PropDr; % total drag coefficeint due to inoperative engine
CDoei = 0.006;
StOeiTO = ((((data('Ct')/2)+CDoei)*(data('yt')/data('MAC')))/((data('lvtp')/data('MAC'))*data('Cyvr')*data('Kr30')*MaxRubDefR))*data('S'); % Tailplane Area due to OEI on take off
% Whislt Airborne
%Constants for Overall Equation
Cl = (data('MTOW')*9.81)/(0.5*data('rhoSL')*(data('Vmc')*1.05)^2*data('S')); % Lift coefficient at engine faliure speed
aa = (data('lvtp')/data('MAC'))*data('Cyvr')*data('Kr30')*MaxRubDefR;
bb = ((data('Ct')/2)+CDoei)*(data('yt')/data('MAC'));
cc = data('Cyvr')*data('Kr30')*MaxRubDefR;
dd = data('Cnb')+(data('Cyb')*(data('h0')-h));
ee = (data('lvtp')/data('MAC'))*data('Cyvb');
ff = cc*ee-data('Cyvb')*aa;
gg = data('Cyvb')*bb-cc*dd-data('Cyb')*(aa)+Cl*BankAR*ee;
hh = -Cl*BankAR*dd+data('Cyb')*bb;

StOeiA = (hh./gg)*data('S');

%Cross Wind Landing
beta = atan(data('Vcw')/(data('Vs')*data('msTOkts'))); % Crosswind Angle. rad
StLand = -(((data('Cnb')+data('Cyb')*(h-data('h0')))*beta)/((data('lvtp')/data('MAC'))*((data('Cyvr')*CWMaxRubDefR)+data('Cyvb')*beta)))*data('S');

%Directional Stability
CNB = 1.25; % Minimum weather cock stability
StDS =(CNB-data('Cnb')+(data('Cyb')*(data('h0')-h)))./-(data('Cyvb')*(-(data('h0')-h)+(data('lvtp')/data('MAC'))))*data('S');

% Finding the largest tail plane of all the cases which is the required
% size
Svtp= max([StOeiTO max(StOeiA) max(StLand) max(StDS)]);
if plotVtpGraphs == 1 % Only plot the Vtp graph is plotVtpGraphs is 1
    %plotting a graph to show the limiting case of tail sizing
    figure
    hold on
    plot([min(h) max(h)], [StOeiTO StOeiTO]);
    plot(h, StOeiA);
    plot(h,StLand);
    plot(h, StDS);
    legend('OEI TO', 'OEI Airbourne', 'Crosswind Landing', 'Directional Stability','Location','southwest')
    xlabel('h')
    ylabel('VTP Area')
    grid on
    hold off
    
    % Plot to show how OEI Airbourne required Svtp varies with bank angle
    m=1;
    StOeiDA=zeros(6,length(h));
    for n = 0:5
        BA = deg2rad(n); % Change bank Angle between 0 and 5
        aa = (data('lvtp')/data('MAC'))*data('Cyvr')*data('Kr20')*CWMaxRubDefR;
        bb = ((data('Ct')/2)+CDoei)*(data('yt')/data('MAC'));
        cc = data('Cyvr')*data('Kr20')*CWMaxRubDefR;
        dd = data('Cnb')+data('Cyb')*(data('h0')-h);
        ee = (data('lvtp')/data('MAC'))*data('Cyb');
        ff = cc*ee-data('Cyvb')*aa;
        gg = data('Cyvb')*bb-cc*dd-data('Cyb')*(aa)+Cl*BA;
        hh = -Cl*BA*dd+data('Cyb')*bb;
        StOeiDA(m, :) = ((-gg+(gg.^2-4*ff*hh).^0.5)./(2.*ff))*data('S');
        m=m+1;
    end
    figure
    hold on
    plot(h,StOeiDA)
    xlabel('h')
    ylabel('VTP Area')
    txt1 = ['\phi = 0°'];
    txt2 = ['\phi = 1°'];
    txt3 = ['\phi = 2°'];
    txt4 = ['\phi = 3°'];
    txt5 = ['\phi = 4°'];
    txt6 = ['\phi = 5°'];
    %{
    Yadjust = 0.15; % Number to shift the line label in the y axis to above the lines
    x1=h(length(h)/2);
    y1 = StOeiDA(1, length(h)/2)+Yadjust;
    y2 = StOeiDA(2, length(h)/2)+Yadjust;
    y3 = StOeiDA(3, length(h)/2)+Yadjust;
    y4 = StOeiDA(4, length(h)/2)+Yadjust;
    y5 = StOeiDA(5, length(h)/2)+Yadjust;
    y6 = StOeiDA(6, length(h)/2)+Yadjust;
    
    text(x1,y1,txt1, 'HorizontalAlignment','center')
    text(x1,y2,txt2, 'HorizontalAlignment','center')
    text(x1,y3,txt3, 'HorizontalAlignment','center')
    text(x1,y4,txt4, 'HorizontalAlignment','center')
    text(x1,y5,txt5, 'HorizontalAlignment','center')
    text(x1,y6,txt6, 'HorizontalAlignment','center')
    grid on
    hold off
    %}
else
end
end

