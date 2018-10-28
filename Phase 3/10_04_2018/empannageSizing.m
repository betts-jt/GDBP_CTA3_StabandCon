function [data] = empannageSizing(plotHtpGraphs, plotVtpGraphs, PlotLiftDis, ASizingMethod, ESizingMethod, RSizingMethod)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%% Import data from database
%Computer
workbookFile = 'C:\Users\joebe\iCloudDrive\Documents\University\Year 3\ME30313 - Group Design and Buisness Project\Matlab\Phase 3\Data.xlsx';
%MAC
%workbookFile ='/Users/JosephBetts/Documents/University/Year 3/ME30313 - Group Design and Buisness Project/Matlab/Phase 3/Data.xlsx';

% Set the correct sheet to draw data from
% 100 Seat Aricraft
Sheet = '100 Seat';
%80 Seat Aircraft
%Sheet = '80 Seat';

importVar = importData(workbookFile, Sheet,'A2:B109');
data = containers.Map(importVar(:,1),importVar(:,2));

%% Run the Functioin to size the horizontai tailplane
Shtp = HTPSizing(plotHtpGraphs, data);

%% Run the function to size the vertical tailplane
[Svtp, CDoei] = VTPSizing(plotVtpGraphs, data);

%% Run the fuction to size the elevator
[Se, eHinge] = ElevatorSizing(PlotLiftDis, ESizingMethod, data, Shtp);

%% Run the function to size the rudder
[Sr, rHinge] = RudderSizing(data, Svtp, RSizingMethod);

%% Run the function to size the Aileron
Sa = AileronSizing(data, Shtp, Svtp, ASizingMethod);

%% Calculate Kn
knFWD = (data('h0')-(data('XcgFWD')/data('MAC')))+ ((Shtp*data('lhtp')/(data('S')*data('MAC'))));
knAFT = (data('h0')-(data('XcgAFT')/data('MAC')))+ ((Shtp*data('lhtp')/(data('S')*data('MAC'))));

%% Construct output variable
data = table(Shtp, Svtp, Se, eHinge, Sr, rHinge, Sa, knFWD, knAFT);
end
