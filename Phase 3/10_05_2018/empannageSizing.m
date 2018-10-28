function [data] = empannageSizing(ACSize, plotHtpGraphs, plotVtpGraphs, PlotLiftDis, ASizingMethod, ESizingMethod, RSizingMethod)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
close all
%% Import data from database
%Computer
workbookFile = 'C:\Users\joebe\iCloudDrive\Documents\University\Year 3\ME30313 - Group Design and Buisness Project\Matlab\Phase 3\Data new.xlsx';
%MAC
%workbookFile ='/Users/JosephBetts/Documents/University/Year 3/ME30313 - Group Design and Buisness Project/Matlab/Phase 3/Data new.xlsx';
importVar = importData(workbookFile, 'Sheet1', 'A2:C155');

% Set the correct sheet to draw data from
if ACSize == 100
    % 100 Seat Aricraft8i
    data = containers.Map(importVar(:,1),importVar(:,2));
elseif ACSize == 80
    %80 Seat Aircraft
    data = containers.Map(importVar(:,1),importVar(:,3));
end



%% Run the Functioin to size the horizontai tailplane
Shtp = HTPSizing(plotHtpGraphs, ACSize, data);

%% Run the function to size the vertical tailplane
[Svtp, CDoei] = VTPSizing(plotVtpGraphs, data);

%% Run the fuction to size the elevator
[Se, eHinge] = ElevatorSizing(PlotLiftDis, ESizingMethod, data, Shtp);

%% Run the function to size the rudder
[Sr, rHinge] = RudderSizing(data, Svtp, CDoei, RSizingMethod);

%% Run the function to size the Aileron
Sa = AileronSizing(data, Shtp, Svtp, ASizingMethod);

%% Calculate Kn
Vbar = (Shtp*data('lhtp'))/(data('S')*data('MAC'));
knFWD = (data('h0')-(data('XcgFWD')/data('MAC')))+ (Shtp*data('lhtp'))/(data('S')*data('MAC'))*((data('ahtpNC'))/data('a'))*(1-data('deda'));
knAFT = (data('h0')-(data('XcgAFT')/data('MAC')))+ (Shtp*data('lhtp'))/(data('S')*data('MAC'))*((data('ahtpNC'))/data('a'))*(1-data('deda'));
data('a')
data('ahtpNC')
%% Calculate Kn'

b1 = -0.103;
b2 = -0.410;
a1bar = data('ahtpNC')*(1-((data('ahtpNC')*b1)/(data('ahtpNC')*b2)))
knnFWD = (data('h0')-(data('XcgFWD')/data('MAC')))+ (Shtp*data('lhtp'))/(data('S')*data('MAC'))*(a1bar/data('a'))*(1-data('deda'));
knnAFT = (data('h0')-(data('XcgAFT')/data('MAC')))+ (Shtp*data('lhtp'))/(data('S')*data('MAC'))*(a1bar/data('a'))*(1-data('deda'));

%% Calcualting Cma (longitudinal stability derrivative)
CmaFWD = (data('a')*((data('XcgFWD')/data('MAC'))-data('h0')))-data('ahtpNC')*(18.685/data('S'))*((data('lhtp')/data('MAC'))-(data('XcgFWD')/data('MAC')))*(1-data('deda'));
CmaAFT = (data('a')*(-(data('XcgAFT')/data('MAC'))+data('h0')))-data('ahtpNC')*(18.685/data('S'))*((data('lhtp')/data('MAC'))-(data('XcgAFT')/data('MAC')))*(1-data('deda'));

%% Calculating stiock force speed gradient. Roskam 7 pg 437
Cmih = -data('ahtpNC')*(Vbar);
ade = 0.9*1*4.5*(.6/data('ahtpNC'))*1.9;

Cmde = Cmih*ade;

Cha = b1;

Chde = b2;

StickForceGradient = -(2/100)*6.228*0.656*((33720*9.81)/data('S'))*(Chde/Cmde)*(knAFT)
%% Construct output variable
ShtpS = Shtp/data('S');
SvtpS = Svtp/data('S');
data = table(Shtp, ShtpS, Svtp, SvtpS, Se, eHinge, Sr, rHinge, Sa, Vbar, knFWD, knAFT, knnFWD, knnAFT, CmaFWD, CmaAFT);

end
