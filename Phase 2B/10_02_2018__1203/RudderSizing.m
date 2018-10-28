function [Sr, rHinge] = RudderSizing(Svtp, TRot, yt, rho, S, b, bv, avtpNC, lvtp, MACv, CDoei, Vmc, RSizingMethod)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

%Geneic Variables
rudderDefMax = 30; % Maxinum aileron deflection. Degrees
rudderDefMaxR = deg2rad(rudderDefMax); % Maxinum aileron deflection. Radians
VTDPR = 1; % Vertical tail dynamic pressure ratio. Need to calculate as somepoint assumed to be one for now.
if RSizingMethod == 0
    
    %First Pass of Sizing
    % Data taken form Roskam II
    SrSv = 0.27; % Ruder area/horizontail area ratio
    rHinge = 0.70; %Rudder hinge lotation of percentace of vtp MAC
    
    Sr = SrSv*Svtp; %Elevator area using area ratio
    
elseif RSizingMethod == 1
    
    %Detailed rudder Sizing
    
    brbv = 0.85; %Rudder VTP span ratio
    VbarV = (Svtp*lvtp)/(S*b); %Vertical tail volume coefficient
    
    NA = (-TRot-(CDoei*0.5*rho*(Vmc*1.05)^2*S))*yt; % Max required yawing moment for directional control
    
    Cndr = (-NA)/(-0.5*rho*(Vmc*1.05)^2*S*b*rudderDefMaxR); % Rudder control derrivative
    
    rudderEff = Cndr/(-avtpNC*VTDPR*brbv*VbarV); % Rudder effectiveness at max deflection
    
    CrCv = 0.27; % Rudder/VTP chord ratio determined using rudderEff and figure 12.12. see notes
    
    Sr = CrCv*MACv*brbv*bv; % Area of rudder assuming it is a rectangle
    rHinge = 1-CrCv; %Rudder hinge lotation of percentace of vtp MAC
end

end

