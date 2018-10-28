function [data] = empannageSizing(plotHtpGraphs, plotVtpGraphs, PlotLiftDis, ASizingMethod, ESizingMethod, RSizingMethod)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%Generic Variables
rho = 1.225; % Density of air at sea level
msTOkts = 1.94384; % Conversiton between m/s and kts

%100 Seat Data

%Wing Data
S = 97.1092; % Main Wing area. m^2
b = 35.48; % Wing Span m
AR = 12.96; %Aspect ratio
MAC = 2.83; % Mean aerodynamic chord of wing. m 
noseToMAC = 12.762; %Distance from nose datum to MAC leading edge. m
noseTo25MAC = noseToMAC+(0.25*MAC); % Distance from datum to 0.25 MAC. m
h0 = noseTo25MAC/MAC; % Non dimentional legnth to aerodynamic center
a = 5.968902168; % Lift curve slope of main wing
ZLA = -0.05; % Main wing Zero lift angle. rad
deda = 0.2; % downwash guess taken from stability notes
TaperR = 0.332; %Wing Taper ratio
Croot = 3.92; % Wing root Chord legnth. m
yCroot = 1.712; % Distance of wing root chord from centerline. m
a_0 = -2.87; % zero-lift angle of attack (deg)

%Overall Aircraft Data
MTOW = 35000; % Max Take off Weight of the aircraft. kg
Clmax = 2.7; % Maximum aircraft lift coefficient at landing
LD = 15.5; % Lift / Drag ratio for aircraft
XcgFwd = noseToMAC+(0.10*MAC); % Fwd CG Limit
XcgAft = noseToMAC+(0.43*MAC); % Aft CG Limit
Vs = ((MTOW*9.81)/(0.5*rho*Clmax*S))^0.5; % stall speed of the aircraft. m/s
Vmc = 1.2*Vs; % Minimuim control speed airborne. m/s
Cm0 = -0.13067; % Zero lift pitching moment coefficient
cgRange = 0.33; % Center of gravity range of percentage of MAC
zcg = 3.059; %Vertical CG postion.m
zd = 1.2; % Distance of drag from vertical CG position. Initial estimate need to ask richard. m

%Horizontail tailplane Data (NACA 0010)
lhtp = 13; % Horizontal tail plane moment arm distance. m
ahtpNC = 4.355697004; % HTP lift curve slope non compressible
ahtpC = 4.5832596912; % HTP lift curve slope compressible
ahtp2D = 6.767; % HTP 2D lift curve slope non compressible
CltMin = -1; % Minimum tailplane lift coefficient taken as Clmax for naca 0010 plus safety margin
etaT = 0; % Initial tailplane setting. Degrees
etaTR = deg2rad(etaT); % Initial tailplane setting. Rad
bh = 11.348; %HTP span. m
MACh = 2.699; %HTP MAC. m
TaperRh = 0.515; %HTP Taper ratio
ARh = 4.802; % Aspect ratio of HTP

%Vertical Tailplane Data (NACA 0010)
lvtp = 11; % Vertical tail plane moment arm distance. m
avtpNC = 6.766990576; % VTP lift curve slope non compressible
avtpC = 7.763049542; % VTP lift curve slope compressible
MACv = 3.867; %VTP MAC. m
bv = 6.182; %VTP span.m

%Engine Data
InitialMaxPower = 4745; % Max power of the given unscaled engines. kW
EngineScale = 0.805; %Scale factor of our engines
MaxPower = InitialMaxPower*EngineScale; % Max power of our engines. kW
TRot = (MaxPower*1000)/(1.05*Vmc); %Thrust at rotation point 1.05*Vmc. N
TotalTRot = 2*TRot; % Total thrust from all engines at rotation point. N
zt = 1.4714; % Distance of engine from vertical CG position. m
yt = 4.577; % Distance of engine from aircraft centerline. m
Ct = TotalTRot/(0.5*rho*(Vmc*1.05)^2*S); %Thrust coefficient at rotation
PropDia = 4.174; % Propeller Diameter. m
PropNum = 6; % Numeber of propellers
IntakeArea = 0.16; % Engine intake area. m^2
ScaledIntakeArea = 0.16*EngineScale; % Scaled intake engine area  

%Landing Gear Data
xNLG = 1.8; % Distance of nose landing gear from datum. m
hNLG = xNLG/MAC; % Non dimentional distance of nose landing gear from datum.
xMLG = 14.1975; %Distance of main landing gear from datum. m
hMLG = xMLG/MAC; % Non dimentional distance of main landing gear from datum.
zMLG = 1; % Height of main landing gear

%Run the Functioin to size the horizontai tailplane
Shtp = HTPSizing(plotHtpGraphs, MAC, h0, a, ahtpC, Clmax, lhtp, deda, Cm0, xNLG, xMLG, hNLG, hMLG, Ct, zt, rho, Vmc, S, MTOW, cgRange, CltMin);

% Run the function to size the vertical tailplane
[Svtp, CDoei] = VTPSizing(plotVtpGraphs, yt, MAC, Ct, ScaledIntakeArea, PropNum, PropDia, S, XcgFwd, XcgAft, Vs, msTOkts, lvtp, Vmc, rho, MTOW, h0);

%Run the fuction to size the elevator
[Se, eHinge] = ElevatorSizing(PlotLiftDis, ESizingMethod, Shtp, MTOW, rho, Vmc, S,MAC, XcgFwd, xMLG, noseTo25MAC, lhtp, CltMin, TotalTRot, zd, zt, zMLG, zcg, b, etaTR, ahtpNC, ahtp2D, bh, Cm0, ARh, TaperRh, MACh, etaT);

%Run the function to size the rudder
[Sr, rHinge] = RudderSizing(Svtp, TRot, yt, rho, S, b, bv, avtpNC, lvtp, MACv, CDoei, Vmc, RSizingMethod);

% Run the function to size the Aileron
Sa = AileronSizing(S, Croot, b, MTOW, rho, a, TaperR, Shtp, Svtp, yCroot, Vmc, MAC, ASizingMethod);

%Construct output variable
data = table(Shtp, Svtp, Se, eHinge, Sr, rHinge, Sa);
end

