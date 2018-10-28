function [Cyb, Cybv, Cnb, Cydr] = RudConDer(data, Svtp, Shtp)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%% Calculating the Sideforce due to sideslip derrivative Wing/fuselage
Cybw = -0.00573*(abs(data('dihedralA'))); %Wing contribution  to sideslip derrivative

Cybf = (-2*data('Ki'))*(data('So')/data('S')); %Fuselage contribution to sideslip derrivative

Cyb = Cybw + Cybf;

%% Calculating the Sideforce due to sideslip derrivative VTP

ARv = data('bv')^2/Svtp; % Vertical taiolplane aspect Ratio

%{
ShSv = Shtp/Svtp;
disp(['Sh/Sv = ' , num2str(ShSv)]);
%getting the value of Kvh which is dependent on Svtp S htp
A = imread('Figure 10.16.jpg');
imshow(A);
prompt = 'Please enter the value of Kvh using the graph - ';
Khv = input(prompt);
%}

Khv = 0.84;

dSigmadBeta = (0.724+3.06*((Svtp/data('S'))/(1-cos(deg2rad(30))))+((0.4*data('Zw'))/(data('Zf')))+0.009*ARv)-1;

Aveff = data('AvfAv')*ARv*(1+Khv*(data('AvhfAvf')-1)); % effective VT-P aspect ratio

Cybv = -data('kv')*data('avtpNC')*(1+dSigmadBeta)*1*(Svtp/data('S')); % currently too large

%% Calculating yawing moment due to sideslip Wing/Fuselage
XmLf = data('XcgAFT')/data('lf');
AA = data('lf')^2/data('Sbs');
BB = (data('h1')/data('h2'))^0.5;

%{
disp(['Xm/lf = ' , num2str(XmLf)]);
disp(['Lf^2/Sbs = ' , num2str(AA)]);
disp(['(h1/h2)^0.5 = ' , num2str(BB)]);
disp(' Suggested value of Kn = 0.0015');


A = imread('Figure 10.28.jpg');
imshow(A);
prompt = 'Please enter the value of Kn using the graph - ';
Kn = input(prompt);

disp(['Max Reynolds numebr = ' , num2str(data('MaxReFuse'))]);
disp('Suggested value of KRl = 2.13');

A = imread('Figure 10.29.jpg');
imshow(A);

prompt = 'Please enter the value of KRl using the graph - ';
KRl = input(prompt);
%}

Kn = 0.0015;
KRl = 2.13;

Cnb = -57.3*Kn*KRl*((data('Sbs')*data('lf'))/(data('S')*data('b')));

%% Calculating side force due to rudder derrivative
Cydr = (data('avtpNC')/data('Clva'))*data('kk')*data('Kb')*data('adCladcl')*data('CldCldTheory')*data('CldTheory')*(Svtp/data('S'));

end

