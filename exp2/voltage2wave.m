function [ wave ] = voltage2wave( voltages,Ts,sample_rate,alpha ,type,sample_time)
%VOLTAGE2WAVE 此处显示有关此函数的摘要
%   此处显示详细说明

dt = 1/sample_rate;
block_length = Ts/dt;
if block_length ~= ceil(block_length)
    error('invalid Ts and dt input!')
end
total_time = length(voltages)*Ts;
t = [0:dt:total_time-dt];
indexs = [0:1:length(t)-1];
pulse_signal = repmat(voltages,block_length,1);
pulse_signal = pulse_signal(:).';
pulse_signal(mod(indexs,block_length) ~= 0)=0;
h = rcosdesign(alpha,6,Ts/dt,type);
[~,start_index] = max(h);
% coefficient = 1/max_value;
% h = h*coefficient;
wave = conv(pulse_signal,h);
wave = wave(start_index-sample_time:end-start_index+1-sample_time);
temp = conv(wave,h);
temp = temp(start_index-1:end-start_index);
% figure
% plot(t,real(wave))
% hold on
% plot(t,imag(wave))
% plot(t+sample_time*dt,real(pulse_signal))
% plot(t+sample_time*dt,imag(pulse_signal))
% title('发射基带波形实虚部')
% xlabel('t')
% legend(['基带波形实部';'基带波形虚部';'脉冲波形实部';'脉冲波形虚部'])
% plot(t,[real(temp);imag(temp)]);
end

