clear all;
bit_length = 2400;
random_rate = 0.5;
alpha = 0.5;
single_band = 1500;
carry_f = 1850;
over_sample_rate = 20;

Rs = single_band*2/(1+alpha); 
dt = 1/Rs/over_sample_rate;
sample_rate = 1/dt;
sample_time = over_sample_rate/2;%电平转为波形之后的采样时间，为了防止低通滤波之后首尾出现失真

A = 0.5;
n0 = 2e-5;
modulate_bit = 2;
repeat_time = 1;
graycode_enable = 1;

conv_param = [15,17];
conv_memory = (conv_param(1)<=17 & conv_param(1)>7)*4+(conv_param(1)<=7 & conv_param(1)>3)*3;
conv_tail_enable = 1;
viterbi_hard = 1;
viterbi_soft = ~viterbi_hard;

symbol_num = bit_length/modulate_bit;
t = [0:dt:1/Rs*symbol_num*repeat_time*length(conv_param)-dt];

raw_data = random('bino',1,random_rate,1,bit_length);
conv_raw_data = convcode(raw_data,conv_param,~conv_tail_enable);
[complex_voltages,sites] = modulate_for_PSK(conv_raw_data,2^(modulate_bit),graycode_enable,A,repeat_time);

%% voltage channel
wave = voltage2wave(complex_voltages,1/Rs,sample_rate,alpha,'sqrt',sample_time);
% receive_voltages = wave2voltage(wave,sample_rate,sample_time, Rs,'sqrt',alpha);
send_wave = onto_carrywave(wave,carry_f,sample_rate);

[spectrum,fs] = plot_power_spectrum(send_wave,10,sample_rate);
Eb = sum(spectrum)/Rs/modulate_bit;% 如果信道编码是
% plot(fs,spectrum);
% hold on
% plot(t,[real(send_wave);imag(send_wave)])
receive_wave = wave_channel(send_wave,n0,sample_rate);
% hold on 
% plot(t,[real(receive_wave);imag(receive_wave)])
[spectrum,fs] = plot_power_spectrum(receive_wave,10,sample_rate);
% plot(fs,spectrum);
receive_wave = off_carrywave(receive_wave,carry_f,sample_rate,single_band);
receive_voltages = wave2voltage(receive_wave,sample_rate,sample_time, Rs,'normal',alpha);
%% 
figure
plot(real(receive_voltages),imag(receive_voltages),'o')
[data_index,prob] = judge_for_PSK(receive_voltages,2^(modulate_bit),0,sites,repeat_time);
receive_data = symbol2sequence_for_PSK(data_index,2^modulate_bit,graycode_enable);
deconv_receive_data = viterbi(length(conv_param),conv_memory,conv_param,viterbi_hard,...
    conv_tail_enable,receive_data,modulate_bit);
% figure
% plot(t,[wave;receive_wave]);

10*log10(Eb/n0)
error = raw_data~=deconv_receive_data;
sum(error)
index = ceil(find(error == 1)/2);
hold on
plot(real(receive_voltages(index)),imag(receive_voltages(index)),'o')