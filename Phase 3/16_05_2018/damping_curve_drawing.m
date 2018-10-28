x = [1:0.1:100];

%% Oscillation graphs
P =3; %time period
t12 = 11.583; % time to half amplitude
lambda = -log(2)/t12;
omega = (1/P)*2*pi();
y = exp(1).^(lambda*x).*(cos(omega*x));
hold on
plot(x,y)
xlabel('Time (s)')
ylabel('Amplitude')

%% Roll subisdence
y = exp(1).^(-0.779*x);
plot(x,y)
xlabel('Time (s)')
ylabel('Amplitude')

%% Spiral Mode
y = 2.^(x/52);
plot(x,y)
xlabel('Time (s)')
ylabel('Amplitude')
