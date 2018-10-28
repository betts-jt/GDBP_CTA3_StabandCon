function [data] = empannageSizing(ACSize, plotHtpGraphs, plotVtpGraphs, PlotLiftDis, ASizingMethod, ESizingMethod, RSizingMethod)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%% Import data from database
%Computer
workbookFile = 'C:\Users\joebe\iCloudDrive\Documents\University\Year 3\ME30313 - Group Design and Buisness Project\Matlab\Phase 3\Data.xlsx';
%MAC
%workbookFile ='/Users/JosephBetts/Documents/University/Year 3/ME30313 - Group Design and Buisness Project/Matlab/Phase 3/Data.xlsx';
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
Shtp = HTPSizing(plotHtpGraphs, data);

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
knFWD = (data('h0')-(data('XcgFWD')/data('MAC')))+ (Shtp*data('lhtp'))/(data('S')*data('MAC'))*(data('ahtpNC')/data('a'))*(1-data('deda'));
knAFT = (data('h0')-(data('XcgAFT')/data('MAC')))+ (Shtp*data('lhtp'))/(data('S')*data('MAC'))*(data('ahtpNC')/data('a'))*(1-data('deda'));

%% Construct output variable
data = table(Shtp, Svtp, Se, eHinge, Sr, rHinge, Sa, Vbar, knFWD, knAFT);
end
