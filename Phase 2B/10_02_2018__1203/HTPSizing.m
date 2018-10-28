function [Shtp] = HTPSizing(plotscissor, MAC, h0, a, ahtpC, Clmax, lhtp, deda, Cm0, xNLG, xMLG, hNLG, hMLG, Ct, zt, rho, Vmc, S, MTOW, cgRange, CltMin)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

knMin = 0.05; % minimum static margin stick fixed
Xcg = [12:0.1:14.5]; % range of cg positions. m
h = Xcg/MAC; % range of non dimentional cg locations.
q = 0.5*rho*(Vmc*1.05)^2; % Dynamic Pressure at 1.05*Vmc

%Finding St/S ratios based on key criteria for flight
SRatioKn = ((knMin-h0+h)*MAC*a)/(lhtp*ahtpC*(1-deda)); % St/S ratio based on KnMin
SRatioLand = ((Cm0-(h0-h)*Clmax)*MAC)/(lhtp*CltMin); % St/S ratio based on Landing Cltmin
SRatioTO = ((Cm0+(h0-h)*Clmax)+Ct*(zt/MAC)-((((MTOW*9.81)/(q*S))-Clmax)*(hMLG-h)))./((-CltMin*(hMLG-h))+(CltMin*(h0-h-(lhtp/MAC)))); % St/S ratio based on TO Rotation

%Rear CG limit due to 2.5% weight on nose wheel
xCGAftNLG=((39*xMLG)+xNLG)/40; % Aff CG limit due to the 2.5% weight requirment on nose wheel
hAftNLG = xCGAftNLG/MAC;
%Data to plot CG limit due to nose wheel weight
hAftNLGR = [hAftNLG hAftNLG];
StSAftNLGMin = [min([min(SRatioKn) min(SRatioLand) max(SRatioTO)])]; % Finding the minimum y value in the SRatio terms
StSAftNLGMax = [max([max(SRatioKn) max(SRatioLand) max(SRatioTO)])]; % Finding the Maximum y values in the SRatio terms
StSAftNLG = [StSAftNLGMin StSAftNLGMax];

%Calculations to determine required tailplane area

%the line used here will change depending on which limits the forward cg
%position assuming the rear limit is due to nose wheel
coefficients = polyfit(h, SRatioTO, 1);
m = coefficients(1); % gradient of most important fwd limit on scissor plot
c = coefficients(2); % y intercept of most important fwd limit on scissor plot
y = ((hAftNLG-cgRange)*m)+c
aa = (y-c)/m; % X position of horizontal cg line meeting fwd limit
Shtp = y*S; % Calculated Tailplane area

% Plotting Scissor Plot
if plotscissor == 1
    %Original Scissor plot
    figure
    hold on
    plot(h, SRatioKn, ':', 'LineWidth',2); % Plotting limiting lime to to min Kn
    plot(h, SRatioLand, '--', 'LineWidth',1.5); % Plotting limiting lime to to min landing
    plot(h, SRatioTO, '-.', 'LineWidth',1.5); % Plotting limiting lime to to min take off rotation
    plot(hAftNLGR, StSAftNLG, '-', 'LineWidth',1.5); % Plotting limiting lime to to min weight on NLG
    legend('Kn', 'Landing', 'Take Off', 'Nose Landing Gear','Location','southwest');
    xlabel('h')
    ylabel('St/s')
    grid on
    hold off
    
    %Scissor plot with line drawn on showing cg range
    figure
    hold on
    plot(h, SRatioKn, ':', 'LineWidth',2, 'LineWidth',2); % Plotting limiting lime to to min Kn
    plot(h, SRatioLand, '--', 'LineWidth',1.5); % Plotting limiting lime to to min landing
    plot(h, SRatioTO, '-.', 'LineWidth',1.5); % Plotting limiting lime to to min take off rotation
    plot(hAftNLGR, StSAftNLG, '-', 'LineWidth',1.5); % Plotting limiting lime to to min weight on NLG
    plot([aa hAftNLG], [y y], 'LineWidth',1.5); % Plot horizontal line indicating the specified CG range
    legend('Kn', 'Landing', 'Take Off', 'Nose Landing Gear','Location','southwest');
    x1 = aa+cgRange/2; % X Postition of text1
    y1 = y+.015; % Y position of text1
    txt1 = ['CG Range = ' num2str(cgRange)];
    text(x1,y1,txt1, 'HorizontalAlignment','center')
    xlabel('h')
    ylabel('St/s')
    grid on
    hold off
else
end
end

