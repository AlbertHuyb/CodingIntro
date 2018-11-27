function [ out ] = onto_carrywave( wave,f,sample_rate )
%ONTO_CARRYWAVE 此处显示有关此函数的摘要
%   此处显示详细说明
dt = 1/sample_rate;
t = [0:dt:dt*(length(wave)-1)];
max_f = sample_rate;
fs = [0:max_f/length(t):max_f-max_f/length(t)];
% plot(fs,real(fft(wave)));
carry = cos(2*pi*f*t);
out = carry.*wave;
% hold on 
% plot(fs,real(fft(out)))
% figure
% plot(t,wave)
% hold on
% plot(t,out)
end

