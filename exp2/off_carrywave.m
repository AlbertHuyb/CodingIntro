function [ out ] = off_carrywave( wave,f,sample_rate,band )
%OFF_CARRYWAVE 此处显示有关此函数的摘要
%   此处显示详细说明

dt = 1/sample_rate;
t = [0:dt:dt*(length(wave)-1)];
carry = cos(2*pi*f*t);
out = carry.*wave;
freq = fft(out);
max_f = sample_rate;
f = [0:max_f/length(t):max_f-max_f/length(t)];
% figure
% plot(f,real(fft(wave)));
freq(f>band & f<max_f-band)=0;
out = ifft(freq)*2;
% hold on 
% plot(f,real(fft(out)))
% figure
% plot(t,wave)
% hold on
% plot(t,out)

end

