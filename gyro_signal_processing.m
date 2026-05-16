%  Gyroscope Signal Processing
%  FFT + Allan Variance Analysis
%  Using Workspace Variable: simGyro

close all;
clc;


%% Load Signal From Workspace
gyro_signal = double(out.simGyro);

%% Sampling Parameters

Fs = 100;                 % Sampling frequency [Hz]
dt = 1/Fs;

N = length(gyro_signal);

t = (0:N-1)*dt;

%% Remove Mean
gyro_detrended = gyro_signal - mean(gyro_signal);


%% FFT ANALYSIS

Y = fft(gyro_detrended);

P2 = abs(Y/N);

P1 = P2(1:N/2+1);

P1(2:end-1) = 2*P1(2:end-1);

f = Fs*(0:(N/2))/N;

%% FFT Plot

figure;

plot(f, P1, 'LineWidth', 1.2);

xlabel('Frequency [Hz]');
ylabel('Magnitude');

title('Gyroscope FFT Spectrum');

grid on;

%% PSD Plot

figure;

periodogram(gyro_detrended, [], [], Fs);

title('Gyroscope Power Spectral Density');

%% ALLAN VARIANCE ANALYSIS

tau0 = dt;

maxM = floor(N/2);

m = logspace(0, log10(maxM), 100);

m = unique(ceil(m));

tau = m * tau0;

adev = zeros(size(tau));

%% Allan Deviation Computation

for i = 1:length(m)

    mi = m(i);

    K = floor(N/(2*mi));

    if K < 2
        continue;
    end

    avgs = zeros(K,1);

    for k = 1:K

        idx1 = (k-1)*mi + 1;
        idx2 = k*mi;

        avgs(k) = mean(gyro_detrended(idx1:idx2));

    end

    sum_term = 0;

    for k = 1:(K-1)

        sum_term = sum_term + ...
            (avgs(k+1)-avgs(k))^2;

    end

    adev(i) = sqrt(sum_term/(2*(K-1)));

end

%% =========================================================
% Allan Deviation Plot
%% =========================================================

figure;

loglog(tau, adev, 'LineWidth', 1.5);

xlabel('\tau [s]');
ylabel('Allan Deviation [deg/s]');

title('Gyroscope Allan Deviation');

grid on;

%% Bias Instability Estimate

[min_adev, idx] = min(adev);

bias_instability = min_adev;

fprintf('\nEstimated Bias Instability:\n');
fprintf('%.6f deg/s\n', bias_instability);

fprintf('Occurs at tau = %.3f s\n', tau(idx));

%% Save Results

results.fft_frequency = f;
results.fft_magnitude = P1;

results.tau = tau;
results.allan_deviation = adev;

save('gyro_analysis_results.mat', 'results');

disp('Analysis Complete');

