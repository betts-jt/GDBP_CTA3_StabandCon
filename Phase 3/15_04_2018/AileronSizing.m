function [Sa] = AileronSizing(data, Shtp, Svtp, ASizingMethod)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
%Generic Variables
aileronDefMax = 25; % Maxinum aileron deflection. Degrees
aileronDefMaxR = deg2rad(aileronDefMax); % Maxinum aileron deflection. Radians
CDR = 0.9; % Aircraft drag coefficient in rolling motion. Taken from other aircraft data. Need to calculate.

yD = ((data('b')/2)*0.4)+data('yCroot'); 

phiDes = 30; % Desired bank angle. degrees
phiDesR = deg2rad(phiDes); % Desired bank angle. Rad


if ASizingMethod == 0
    %First Pass of Sizing
    % Data taken form Roskam II
    SaS = 0.03; % Aileron area/wing area ratio
    
    Sa = SaS*data('S'); %Elevator area using area ratio
else if ASizingMethod == 1
        %Detailed Aileron Sizing
        bab = 0.36; % Aileron span/wing span ratio. Used to approximate the span of the aileron. Eventually improve based on flap posision.
        baob = 0.9; % Outer Aileron span position relative to wingspan
        baib = baob-bab/2;  % Inner Aileron span position relative to wingspan
        
        CaC = 0.2; %Initial estimate for aileron choprd legnth/wing chord legnth ratio. Need to improve when spar position is fixed.
        
        AileronEff = 0.41; % Aileron effectiveness factor
        
        yo = (baob*data('b'))/2; % Outer aileron position from fusalage center. m
        yi = (baib*data('b'))/2; % Inner aileron position from fusalage center. m
        
        Clda = ((2*data('a')*AileronEff*data('Croot'))/(data('S')*data('b')))*((yo^2/2+(2/3)*((data('TaperR')-1)/data('b'))*(yo)^3)-(yi^2/2+(2/3)*((data('TaperR')-1)/data('b'))*(yi)^3)); % Aileron rolling moment coefficient
        
        Croll = Clda*aileronDefMaxR; % Aircraft rolling moment coefficient with max aileron deflection.
        
        LA = (0.5*data('rhoSL')*(data('Vmc')*1.05)^2)*data('S')*Croll*data('b'); % Aircraft rolling moment.
        
        Pss = ((2*LA)/(data('rhoSL')*(data('S')+Shtp+Svtp)*CDR*yD^3)); %Steady state roll rate
        
        Ixx = (data('b')^2*data('MTOW')*9.81*data('RxBar')^2)/(4*9.81); %Initial class 1 calculation of moment of intetia using radius of gyration
       
        phi1 = (Ixx/(data('rhoSL')*yD^3*(data('S')+Shtp+Svtp)*CDR))*log(Pss^2); % Bank angle at which aircraft achienes a steady roll rate.
        
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
        
        Sa = bab*(data('b')/2)*data('MAC')*CaC; %Size the elevator based on the dimention ratios assuming it is a rectangle
    end


end

