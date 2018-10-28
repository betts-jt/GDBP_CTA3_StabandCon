function [Clh2] = LiftingLineTheory(PlotLiftDis, ARh, bh, delta_a_0, TaperRh, ahtp2D, bebh, etaT, MACh)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

N = 15; % (number of segments-1)
alpha_twist = -2; % Twist angle (deg)
i_w = etaT; % wing setting angle (deg)
a_0 = 0.00001; % zero-lift angle of attack htp
a_0_fd = -delta_a_0; % flap down zero-lift angle of attack (deg)

theta = pi/(2*N):pi/(2*N):pi/2;
alpha=i_w+alpha_twist:-alpha_twist/(N-1):i_w;
Croot = (1.5*(1+TaperRh)*MACh)/(1+TaperRh+TaperRh^2); % root chord

% segment’s angle of attack
for i=1:N
    if (i/N)>(1-bebh)
        alpha_0(i)=a_0_fd; %flap down zero lift AOA Wing Design 257
    else
        alpha_0(i)=a_0; %flap up zero lift AOA
    end
end
z = (bh/2)*cos(theta);
c = Croot * (1 - (1-TaperRh)*cos(theta)); % MAC at each segment
mu = c * ahtp2D / (4 * bh);
LHS = mu .* (alpha-alpha_0)/57.3; % Left Hand Side
% Solving N equations to find coefficients A(i):
for i=1:N
    for j=1:N
        B(i,j) = sin((2*j-1) * theta(i)) * (1 + (mu(i) * (2*j-1)) / sin(theta(i)));
    end
end
A=B\transpose(LHS);
for i = 1:N
    sum1(i) = 0;
    sum2(i) = 0;
    for j = 1 : N
        sum1(i) = sum1(i) + (2*j-1) * A(j)*sin((2*j-1)*theta(i));
        sum2(i) = sum2(i) + A(j)*sin((2*j-1)*theta(i));
    end
end
CL = 4*bh*sum2 ./ c;

CL1=[0 CL(1) CL(2) CL(3) CL(4) CL(5) CL(6) CL(7) CL(8) CL(9) CL(10) CL(11) CL(12) CL(13) CL(14) CL(15)];
y_s=[bh/2 z(1) z(2) z(3) z(4) z(5) z(6) z(7) z(8) z(9) z(10) z(11) z(12) z(13) z(14) z(15)];

if PlotLiftDis ==1
    %Plot lift distribution
    figure
    plot(y_s,CL1,'-o')
    grid
    title('Lift distribution')
    xlabel('Semi-span location (m)')
    ylabel ('Lift coefficient')
else
end

Clh2 = - pi * ARh * A(1);
end
