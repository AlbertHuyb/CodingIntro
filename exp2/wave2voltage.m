function [ out ] = wave2voltage( wave, sample_rate, sample_time, Rs,type,alpha )
%WAVE2VOLTAGE �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
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
% title('ƥ���˲�����ʵ�鲿')
% xlabel('t')
% legend(['��������ʵ��';'���������鲿'])
sample_indexs = start_index+sample_time+[0:1:symbol_num-1]*symbol_length;
out = wave(sample_indexs);
end

