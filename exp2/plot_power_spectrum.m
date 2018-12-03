function [ spectrum,fs ] = plot_power_spectrum( wave,window_size,sample_rate )
%PLOT_POWER_SPECTRUM 此处显示有关此函数的摘要
%   此处显示详细说明
dt = 1/sample_rate;
T = dt*length(wave);
max_f = 1/dt;
df = max_f/length(wave);
fs = [0:df:max_f-df];
window = repmat(1/window_size,1,window_size)*df;
f_domain = fft(wave)/sample_rate;
f_domain = abs(f_domain).^2;
result = conv(f_domain,window);
spectrum = result(window_size:end)/T;
spectrum = spectrum*sample_rate;
end

