# Gyroscope Sensor Modeling and Signal Analysis

## Overview

This project presents a realistic gyroscope sensor model implemented in MATLAB/Simulink based on the behavior of the L3GD20 MEMS gyroscope.

The model simulates:

* Sensor dynamics
* Low-pass filtering
* Static bias
* Bias instability
* Measurement noise
* Misalignment / scale-factor error
* ADC quantization and signed integer output

The generated gyroscope signal is then analyzed using:

* Fast Fourier Transform (FFT)
* Power Spectral Density (PSD)
* Allan Variance / Allan Deviation

---

# Sensor Model Architecture

```text
True Angular Velocity
        ↓
Misalignment / Scale Error
        ↓
Static Bias
        ↓
Bias Instability (Random Walk)
        ↓
Measurement Noise
        ↓
2nd Order LPF
        ↓
ADC Quantization
        ↓
Signed Integer Output (int16)
```

---

# Dynamic Sensor Model

The gyroscope low-pass dynamics are modeled using a second-order Butterworth filter:

$$
H(s)=\frac{\omega_n^2}{s^2+2\zeta\omega_n s+\omega_n^2}
$$

For:

* Cutoff frequency:

$$
f_c = 12.5\ \text{Hz}
$$

* Natural frequency:

$$
\omega_n = 2\pi f_c \approx 78.54\ \text{rad/s}
$$

* Damping ratio:

$$
\zeta = 0.707
$$

Resulting transfer function:

$$
H(s)=\frac{6168.5}{s^2+111.1s+6168.5}
$$

---

# Bias Modeling

## Static Bias

A constant offset is added to the angular velocity measurement:

$$
\omega_{meas}=\omega_{true}+b
$$

with:

```matlab
b = -0.6851; % deg/s
```

---

## Bias Instability

Bias instability is modeled as a random walk:

$$
b(t+\Delta t)=b(t)+\sigma_b\sqrt{\Delta t}n
$$

where:

* (n \sim \mathcal{N}(0,1))
* (\sigma_b) controls drift intensity.

This generates realistic low-frequency MEMS drift.

---

# Misalignment / Scale Error

For the single-axis model, misalignment is approximated as a scale-factor error:

$$
\omega_{meas}=(1+\epsilon)\omega
$$

where:

* (\epsilon) is a small calibration/misalignment factor.

---

# Quantization and Digital Output

The gyroscope output is converted to signed 16-bit integer format:

```matlab
int16
```

with range:

$$
-32768 \le x \le 32767
$$

---

# Signal Processing and Analysis

The simulated gyroscope output signal is analyzed using:

1. FFT Spectrum Analysis
2. Power Spectral Density (PSD)
3. Allan Variance / Allan Deviation

---

# FFT Analysis

The Fast Fourier Transform (FFT) is used to inspect:

* dominant frequencies,
* harmonic content,
* spectral behavior of the gyro signal.

### MATLAB Figure Generation

```matlab
figure;
plot(f, P1, 'LineWidth', 1.2);
xlabel('Frequency [Hz]');
ylabel('Magnitude');
title('Gyroscope FFT Spectrum');
grid on;
```

### Example FFT Plot

<img src="fft_plot.png" width="700">

---

# Power Spectral Density (PSD)

The PSD is used to estimate:

* white noise behavior,
* noise density,
* spectral distribution.

### MATLAB Figure Generation

```matlab
figure;
periodogram(gyro_detrended, [], [], Fs);
title('Gyroscope Power Spectral Density');
```

### Example PSD Plot

<img src="psd_plot.png" width="700">

---

# Allan Variance / Allan Deviation

Allan deviation is used to characterize:

* bias instability,
* angular random walk,
* low-frequency drift.

The Allan deviation equation:

$$
\sigma(\tau)=\sqrt{\frac{1}{2(K-1)}\sum_{k=1}^{K-1}(\bar{y}_{k+1}-\bar{y}_k)^2}
$$

### MATLAB Figure Generation

```matlab
figure;
loglog(tau, adev, 'LineWidth', 1.5);
xlabel('\\tau [s]');
ylabel('Allan Deviation [deg/s]');
title('Gyroscope Allan Deviation');
grid on;
```

### Example Allan Deviation Plot

<img src="allan_plot.png" width="700">

---

# Saving Figures Automatically

To save all plots automatically:

```matlab
saveas(1, 'fft_plot.png');
saveas(2, 'psd_plot.png');
saveas(3, 'allan_plot.png');
```

These images can then be referenced directly inside the README/report.

---

# Extracted Performance Metrics

The MATLAB analysis script estimates:

* Mean bias
* Bias instability
* Noise RMS
* Noise standard deviation
* Peak-to-peak noise
* Angular Random Walk (ARW)
* Noise density

These metrics are compared against typical L3GD20 datasheet values.

---

# Applications

This framework can be extended for:

* IMU simulation
* INS/GNSS integration
* Kalman filtering
* Sensor fusion
* Robotics
* UAV simulation
* Physics-Informed Neural Networks (PINNs)
* Navigation research

---

# Future Improvements

Possible future extensions include:

* Full 3-axis gyro modeling
* Temperature drift modeling
* Flicker noise modeling
* Cross-axis sensitivity
* Nonlinear saturation
* Experimental Allan variance fitting
* Hardware-in-the-loop (HIL) simulation

---

# Conclusion

A realistic MEMS gyroscope model was successfully implemented and analyzed. The model reproduces important real-world sensor behaviors including:

* dynamic filtering,
* stochastic drift,
* bias instability,
* digital quantization,
* and spectral noise characteristics.

The resulting framework provides a strong basis for advanced navigation, estimation, and machine learning applications involving inertial sensors.

# References
Used this as a base: https://www.youtube.com/watch?v=P1OEoA70YJo then added bias instability and misalignment.
