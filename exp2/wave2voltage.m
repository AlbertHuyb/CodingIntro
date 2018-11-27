function [ out ] = wave2voltage( wave, sample_rate, sample_time, Rs,type,alpha )
%WAVE2VOLTAGE 此处显示有关此函数的摘要
%   此处显示详细说明
Ts=1/Rs;
dt = 1/sample_rate;
symbol_length = Ts/dt;
total_time = length(wave)/sample_rate;
symbol_num = total_time*Rs;
t = [0:dt:total_time-dt];
h = rcosdesign(alpha,6,Ts/dt,type);
[max_value,start_index] = max(h);
coefficient = 1/max_value;
h = h*coefficient;
wave = conv(wave,h)/sum(h.^2);
% figure
% hold on
% plot(t,real(wave(61:end-60)))
% plot(t,imag(wave(61:end-60)))
% title('匹配滤波波形实虚部')
% xlabel('t')
% legend(['基带波形实部';'基带波形虚部'])
sample_indexs = start_index+sample_time+[0:1:symbol_num-1]*symbol_length;
out = wave(sample_indexs);
end

