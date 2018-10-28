function [Svtp, CDoei] = VTPSizing(plotVtpGraphs, yt, MAC, Ct, ScaledIntakeArea, PropNum, PropDia, S, XcgFwd, XcgAft, Vs, msTOkts, lvtp, Vmc, rho, MTOW, h0)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
MaxRudDef = 30; % Maximum rudder deflection angle. Degrees
MaxRubDefR = deg2rad(MaxRudDef); % Maximum rudder deflection angle. rad
CWMaxRubDefR = MaxRubDefR*0.7; % Maximum rudder deflection angle for cross wing landings. rad

Xcg = [XcgFwd:0.05:XcgAft]; % range of cg positions. m

h = Xcg/MAC; % range of non dimentional cg locations

Vcw = 20; % Crosswind velocity. kts
BankA = 5; % Maximum allowable bank angle during OEI. Degrees
BankAR = deg2rad(BankA); % Maximum allowable bank angle during OEI. rad

% Laterral derrivatives for low speed configurations
Cyb = -0.430; % Change in horizontal force with sideslip angle. per rad
Cnb = -0.462; % Change in normal force with sideslip angle. per rad
Cyvb = -3.726; % % Change in horizontal tailplane force with sideslip angle. per rad
Cyvr = 1.892; % Change in horizontal tailplane force with rudder angle. per rad

% Fin and rudder Effectiveness
Kr20 = 1; % Rudder effectiveness up to 20 degrees
Kr25 = 0.98; % Rudder effectiveness at 25 degrees
Kr30 = 0.90; % Rudder effectiveness at 30 degrees

% Engine Faliure Cases

% On Take Off
% Calculating Drag due to inoperative engine
WindmillDr = 0.1*(pi()/4)*((ScaledIntakeArea*4)^0.5/pi()); % Windmill drag coefficient due to jet intake area
PropDr = 0.00125*(PropNum)*(PropDia)^2; % Drag coefficient due to propellers
CDoei = WindmillDr + PropDr; % total drag coefficeint due to inoperative engine
CDoei = 0.006;
StOeiTO = ((((Ct/2)+CDoei)*(yt/MAC))/((lvtp/MAC)*Cyvr*Kr30*MaxRubDefR))*S; % Tailplane Area due to OEI on take off
% Whislt Airborne
%Constants for Overall Equation
Cl = (MTOW*9.81)/(0.5*rho*(Vmc*1.05)^2*S); % Lift coefficient at engine faliure speed
aa = (lvtp/MAC)*Cyvr*Kr30*MaxRubDefR;
bb = ((Ct/2)+CDoei)*(yt/MAC);
cc = Cyvr*Kr30*MaxRubDefR;
dd = Cnb+(Cyb*(h0-h));
ee = (lvtp/MAC)*Cyvb;
ff = cc*ee-Cyvb*aa;
gg = Cyvb*bb-cc*dd-Cyb*(aa)+Cl*BankAR*ee;
hh = -Cl*BankAR*dd+Cyb*bb;

%StOeiA = ((-gg+(gg.^2-4.*ff.*hh).^0.5)./(2.*ff))*S;
StOeiA = (hh./gg)*S;

%Cross Wind Landing
beta = atan(Vcw/(Vs*msTOkts)); % Crosswind Angle. rad
StLand = (((Cnb+Cyb*(h0-h))*beta)/((lvtp/MAC)*((Cyvr*CWMaxRubDefR)+Cyvb*beta)))*S;

%Directional Stability
CNB = 1.25; % Minimum weather cock stability
StDS =(CNB-Cnb+(Cyb*(h0-h)))./-(Cyvb*(-(h0-h)+(lvtp/MAC)))*S;

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
        aa = (lvtp/MAC)*Cyvr*Kr20*CWMaxRubDefR;
        bb = ((Ct/2)+CDoei)*(yt/MAC);
        cc = Cyvr*Kr20*CWMaxRubDefR;
        dd = Cnb+Cyb*(h0-h);
        ee = (lvtp/MAC)*Cyb;
        ff = cc*ee-Cyvb*aa;
        gg = Cyvb*bb-cc*dd-Cyb*(aa)+Cl*BA;
        hh = -Cl*BA*dd+Cyb*bb;
        StOeiDA(m, :) = ((-gg+(gg.^2-4*ff*hh).^0.5)./(2.*ff))*S;
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
else
end
end

