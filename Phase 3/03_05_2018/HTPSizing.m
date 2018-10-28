function [Shtp] = HTPSizing(plotscissor, data)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

knMin = 0.05;

Xcg = [data('XcgFWD')-1:0.1:data('XcgAFT')+1]; %To use after implementing data base
h = Xcg/data('MAC'); % range of non dimentional cg locations.

%Finding St/S ratios based on key criteria for flight
SRatioKn = ((data('knMin')-data('h0')+h)*data('MAC')*data('a'))/(data('lhtp')*data('ahtpC')*(1-data('deda'))); % St/S ratio based on KnMin
SRatioLand = ((data('Cm0')-(data('h0')-h)*data('ClmaxL'))*data('MAC'))/(data('lhtp')*data('CltMin')); % St/S ratio based on Landing Cltmin
SRatioTO = ((data('Cm0')+(data('h0')-h)*data('ClmaxL'))+data('Ct')*(data('zt')/data('MAC'))-((((data('MTOW')*9.81)/(data('q')*data('S')))-data('ClmaxL'))*(data('hMLG')-h)))./((-data('CltMin')*(data('hMLG')-h))-(data('CltMin')*(-(data('h0')-h)+(data('lhtp')/data('MAC'))))); % St/S ratio based on TO Rotation

%Rear CG limit due to 2.5% weight on nose wheel
xCGAftNLG =((39*data('xMLG'))+data('xNLG'))/40; % Aff CG limit due to the 2.5% weight requirment on nose wheel
hAftNLG = xCGAftNLG/data('MAC');

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
y = ((hAftNLG-(data('cgAFTMAC')-data('cgFWDMAC')))*m)+c;
aa = (y-c)/m; % X position of horizontal cg line meeting fwd limit
Shtp = y*data('S'); % Calculated Tailplane area

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
    x1 = aa+(data('cgAFTMAC')-data('cgFWDMAC'))/2; % X Postition of text1
    y1 = y+.015; % Y position of text1
    txt1 = ['CG Range = ' num2str(data('cgAFTMAC')-data('cgFWDMAC'))];
    text(x1,y1,txt1, 'HorizontalAlignment','center')
    xlabel('h')
    ylabel('St/s')
    grid on
    hold off
else
end
end

