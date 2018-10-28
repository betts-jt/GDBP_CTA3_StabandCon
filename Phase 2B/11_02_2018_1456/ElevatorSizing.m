function [Se, eHinge] = ElevatorSizing(PlotLiftDis, ESizingMethod, Shtp, MTOW, rho, Vmc, S,MAC, XcgFwd, xMLG, noseTo25MAC, lhtp, CltMin, TotalTRot, zd, zt, zMLG, zcg, b, etaTR, ahtpNC, ahtp2D, bh, Cm0, ARh, TaperRh, MACh, etaT)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%Generic Variables
ElevatorDefMax = 25; % Maxinum aileron deflection. Degrees
ElevatorDefMaxR = deg2rad(ElevatorDefMax); % Maxinum aileron deflection. Radians
Clto = (MTOW*9.81)/(0.5*rho*(Vmc*1.05)^2*S); % Lift coefficient at TO. 1.05 Vmc
Cdto = 0.0176; %Drag Coefficient at take off taken from aerodynacics spreadsheer
Vbar = (Shtp/S)*(lhtp/MAC);
PitchAngAcc = 5; % Required pitch angular acceleration for aircraft. deg/s^2
PitchAngAccR = deg2rad(5); % Required pitch angular acceleration for aircraft. rad/s^2

% Non Dimentional Radius of gyration
Rybar = 0.4535;

if ESizingMethod ==0
    %First Pass of Sizing
    % Data taken form Roskam II
    SeSh = 0.40; % Elevator area/horizontail area ratio
    eHinge = 0.70; %Elevator hinge lotation of percentace of htp MAC
    
    Se = SeSh*Shtp; %Elevator area using area ratio
    
else
    %Detailed Evelator Sizing
    bebh = 1; % Elevator area/horizontail span ratio
    
    Lwf = 0.5*rho*(Vmc*1.05)^2*Clto*S; % Wing Fusalage Lift
    Lhtp = 0.5*rho*(Vmc*1.05)^2*CltMin*Shtp;
    Dto = 0.5*rho*(Vmc*1.05)^2*Cdto*S; % TO Drag
    Mac = 0.5*rho*(Vmc*1.05)^2*Cm0*S*MAC; %Pitching moment about aerodynamic center
    
    LinAcc = (TotalTRot-Dto)/MTOW; % Linear acceleration during TO rotation.
    
    Mw = MTOW*(XcgFwd-xMLG); % Weight moment contribution
    Md = Dto*(zd); % Drag moment contribution
    Mt = -(TotalTRot*(zt)); % Thrust moment contribution
    Mlwf = -(Lwf*(XcgFwd-noseTo25MAC)); % Wing lift moment contribution
    Ma = LinAcc*MTOW*(zcg-zMLG); % Linear Acceleration moment contribution
    
    Iyy = (b^2*MTOW*Rybar^2)/(4*9.81); %Initial class 1 calculation of moment of intetia using radius of gyration
    
    Lh = (Mlwf+Mac+Ma-Mw+Md-Mt-(Iyy*(PitchAngAcc)))/((noseTo25MAC+lhtp)-xMLG); % Required tailplane lift for rotation
    
    Clh1 = Lh/(0.5*rho*(Vmc*1.05)^2*Shtp); % Required tailplane lift coefficient to rotation
    Clh1 = -Clh1;
    
    e = 1.5; % Downwash angle due to ground effect during TO. Degrees
    eR = deg2rad(e); % Downwash angle due to ground effect during TO. Rad
    
    ElevatorEff = ((Clh1/ahtpNC)-(etaTR-eR))/ElevatorDefMaxR; % Elevator effectiveness
    
    CeCh = 0.36; % Dependent on ElevatorEff
    
    %Run function to use lifting line theory to find HTP lift coeffitient using
    %elevator infomation
    delta_a_0 = -1.15*(CeCh)*ElevatorDefMax;
    Clh2 = LiftingLineTheory(PlotLiftDis, ARh, bh, delta_a_0, TaperRh, ahtp2D, bebh, etaT, MACh);
    
    if Clh1*0.95<Clh2<Clh1*1.05
        Clh1
        Clh2
    else
        Clh1
        Clh2
        disp('Required lift coefficient does not match actual lift coefficient please change bebh')
    end
    Se = MACh*CeCh*bh*bebh;
    eHinge = 1-CeCh;
end
end
