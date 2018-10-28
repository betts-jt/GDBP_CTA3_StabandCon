function [Sa] = AileronSizing(S, Croot, b, MTOW, rho, a, TaperR, Shtp, Svtp, yCroot, Vmc, MAC, ASizingMethod)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
%Generic Variables
aileronDefMax = 25; % Maxinum aileron deflection. Degrees
aileronDefMaxR = deg2rad(aileronDefMax); % Maxinum aileron deflection. Radians
CDR = 0.9; % Aircraft drag coefficient in rolling motion. Taken from other aircraft data. Need to calculate.

yD = ((b/2)*0.4)+yCroot; 

phiDes = 30; % Desired bank angle. degrees
phiDesR = deg2rad(phiDes); % Desired bank angle. Rad

% Non Dimentional Radius of gyration
Rxbar = 0.5330;
Rzbar = 0.5152;

if ASizingMethod == 0
    %First Pass of Sizing
    % Data taken form Roskam II
    SaS = 0.03; % Aileron area/wing area ratio
    
    Sa = SaS*S; %Elevator area using area ratio
else if ASizingMethod == 1
        %Detailed Aileron Sizing
        bab = 0.36; % Aileron span/wing span ratio. Used to approximate the span of the aileron. Eventually improve based on flap posision.
        baob = 0.9; % Outer Aileron span position relative to wingspan
        baib = baob-bab/2;  % Inner Aileron span position relative to wingspan
        
        CaC = 0.2; %Initial estimate for aileron choprd legnth/wing chord legnth ratio. Need to improve when spar position is fixed.
        
        AileronEff = 0.41; % Aileron effectiveness factor
        
        yo = (baob*b)/2; % Outer aileron position from fusalage center. m
        yi = (baib*b)/2; % Inner aileron position from fusalage center. m
        
        Clda = ((2*a*AileronEff*Croot)/(S*b))*((yo^2/2+(2/3)*((TaperR-1)/b)*(yo)^3)-(yi^2/2+(2/3)*((TaperR-1)/b)*(yi)^3)); % Aileron rolling moment coefficient
        
        Croll = Clda*aileronDefMaxR; % Aircraft rolling moment coefficient with max aileron deflection.
        
        LA = (0.5*rho*(Vmc*1.05)^2)*S*Croll*b; % Aircraft rolling moment.
        
        Pss = ((2*LA)/(rho*(S+Shtp+Svtp)*CDR*yD^3)); %Steady state roll rate
        
        Ixx = (b^2*MTOW*9.81*Rxbar^2)/(4*9.81); %Initial class 1 calculation of moment of intetia using radius of gyration
        
        phi1 = (Ixx/(rho*yD^3*(S+Shtp+Svtp)*CDR))*log(Pss^2); % Bank angle at which aircraft achienes a steady roll rate.
        
        Pdot = Pss^2/(2*phi1); % Aircraft roll rate produced by rolling moment untill the aircraft reaches Pss.
        
        t =((2*phiDesR)/Pdot)^0.5;
        
        %Check if requirments have been met. Eventually add a if statement to
        %optimise the dimentions to meet requirment.

        %For now check that the value of t is approximatly equat to the t required
        %2.3
        if t > 2.3 %Change 2.3 to tReq
            error 'Please increase the elevator size'
        elseif t < 2.3 %Change 2.3 to tReq
            disp('The elevator can possbly be made smaller. treq = 2.3')
            t
        end
        
        Sa = bab*(b/2)*MAC*CaC; %Size the elevator based on the dimention ratios assuming it is a rectangle
    end


end

