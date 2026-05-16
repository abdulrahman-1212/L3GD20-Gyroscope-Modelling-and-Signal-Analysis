%% Gyroscope Parameters (L3GD20 Approximate Model)

clear all; close all;

% Gyro Mechanical/System Model
wn   = 1000*2*pi;      % Natural frequency [rad/s]
zeta = 0.707;      % Damping ratio (Butterworth approximation)

% LPF Parameters (12.5 Hz)
w = 2*pi*12.5;     % LPF cutoff angular frequency [rad/s]
z = 0.707;         % LPF damping ratio

% Bias
static_bias = -0.6851;    % Constant bias [deg/sec]
bias_sigma = 0.003;

% Misalignment
epsilon = 0.0035;
K_misalign = 1 + epsilon;
