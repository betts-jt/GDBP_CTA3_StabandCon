function [] = derrivatives(ACSize)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
format SHORTG
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

%% Calculate VTP size
Svtp = data('Svtp');

%% Calculate HTP Size
Shtp = data('Shtp');
%% Lateral derrivatives due to Sideslip
[Yv, Yvwb, YvF,  Nv, Nvwb, Lv] = LateralDerrivativesSideslip(Svtp, data);
% Could be checked with ESDU 00025
%% Lateral derrivatives due to yaw
[Yr, YrF, Nr, Lr] = LateralDerrivativesYaw(Svtp,data);

%% Tabulate Results
derrivatives = table(Lv, Yv, Nv, Lr, Yr, Nr)

Cyb = Yvwb;
Cnb = Nv;
Cyvb = YvF;
Cyvr = 2.24;

derrivs = table(Cyb, Cnb, Cyvb, Cyvr)
%% Laterial derrivatives due to roll
%Using ESDU 85010
InputVar(1,1) = 1;
InputVar(2,1) = data('Mac'); % Mach numebr
InputVar(3,1) = data('Re'); % Reynolds numebr
InputVar(4,1) = data('alpha'); % Angle of Attack
InputVar(5,1) = 0;
InputVar(6,1) = data('Zf'); % Body Diameter
InputVar(7,1) = data('Zf'); % Body Height
InputVar(8,1) = data('b'); % Wingspan
InputVar(9,1) = data('nosetoMAC'); % Distance from nose to MAC/4
InputVar(10,1) = data('Croot'); %Root chord
InputVar(11,1) = 1; % numebr of sweep sections
InputVar(12,1) = 0; % Span Coordinate
InputVar(13,1) = 4; % Sweepback LE
InputVar(13,2) = 0; % Sawtooth LE
InputVar(14,1) = -4; % Sweep TE
InputVar(14,2) = 0; % Swatooth TE
InputVar(15,1) = 0; % No of dehedral section
InputVar(16,1) = 0; % Outbound limit
InputVar(16,2) = 0; % Angle
InputVar(17,1) = 0; %Tip deflection due to load
InputVar(18,1) = 1;
InputVar(19,1) = data('a');
InputVar(20,1) = data('Zw'); % Height of wing above fuse center
InputVar(21,1) = data('ZLA'); %Zero lift angle
InputVar(22,1) = data('zt'); % distance of c/4 form vertical cg psoition
InputVar(23,1) = data('0.25MACtoCG'); % distance from MAC/4 to horizontal cg
InputVar(24,1) = 0;
InputVar(25,1) = 0.0006;
InputVar(26,1) = 2;
InputVar(27,1) = data('lvtp'); % Horizontal moment arm
InputVar(28,1) = data('VTPhCenter'); %Fin height from fuselage center
InputVar(29,1) = data('VTPhRoot'); % distance from MAC/4 to horizontal cg
InputVar(30,1) = data('CrootV'); % VTP root chord
InputVar(31,1) = data('CtipV'); % VTP Tip chord
InputVar(32,1) = 30; % Fin sweep angle
InputVar(33,1) = Shtp; %HTP Area
InputVar(34,1) = data('bh'); % HTP Span
InputVar(35,1) = data('MACh'); % HTP MAc
InputVar(36,1) = data('TaperRh'); % HTP Taper ratio
InputVar(37,1) = 12; % Htp C/4 sweep
InputVar(38,1) = 1;
InputVar(39,1) = data('ahtpNC');
InputVar(40,1) = data('VTPhRoot')-0.1;
%{
Example 5(i) cruise condition
alpha = 0 deg, Mach number = 0.78, Reynolds number = 7.5E6 per metre
Wing and tailplane sectional lift-curves - calculated within program
1
0.3
7.5e+06
2
0
3.4231
3.4231
25
12
3.8
1
2
4 0
-4 0
1
0 0
0
1
7.066
1.5763
-2.1
1.2
0.5
0
0.0006
2
12.149
1
5.811
4.23
2.982
30
19
8.5
2.452
0.515
12
1
4.3557
5.711
%}
end

