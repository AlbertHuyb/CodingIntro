clear all;
bit_length = 2048;
random_rate = 0.5;
alpha = 0.5;
single_band = 1500;
carry_f = 1850;
over_sample_rate = 20;
spectrum_windowsize = 200;

Rs = single_band*2/(1+alpha); 
dt = 1/Rs/over_sample_rate;
sample_rate = 1/dt;
sample_time = over_sample_rate/2;%电平转为波形之后的采样时间，为了防止低通滤波之后首尾出现失真

% A = [0.25];
Iterations = 5;
n0 = 2e-5;
h = rcosdesign(alpha,6,1/Rs/dt,'sqrt');
max_h = max(h);
h = h/max_h;
Eh = 1;
% modulate_bit = [1,2,3];
modulate_bit = 2;
Eb_n0_ratio = repmat([-3],length(modulate_bit),1);
% Eb_n0_ratio = repmat([-30:2.5:30],length(modulate_bit),1);%载波信噪比
SNR = 10*log10(10.^(Eb_n0_ratio/10).*modulate_bit*Rs/sample_rate);
% Eb_n0_ratio = repmat([8],length(modulate_bit),1);
repeat_time = 1;
graycode_enable = 1;

conv_param = [15,17];
A = sqrt(modulate_bit*n0*10.^(Eb_n0_ratio/10)/Eh);
conv_memory = (conv_param(1)<=17 & conv_param(1)>7)*4+(conv_param(1)<=7 & conv_param(1)>3)*3;
conv_tail_enable = 1;
viterbi_hard = 1;
viterbi_soft = ~viterbi_hard;

ratio = zeros(length(modulate_bit),length(A));
error_rate2 = zeros(length(modulate_bit),length(A));
error_rate3 = zeros(length(modulate_bit),length(A));
for i = 1:Iterations
    for k=1:length(A)
        k
        symbol_num = bit_length/modulate_bit;
        t = [0:dt:1/Rs*symbol_num*repeat_time*length(conv_param)-dt];
        %genearate data
        raw_data = random('bino',1,random_rate,1,bit_length);
        safe_data = ECC_encrypt(raw_data,1,1,10007,1,1477,10065,11);
        conv_raw_data = convcode(safe_data,conv_param,conv_tail_enable);
        
        % moduate to voltages
        [complex_voltages,sites] = modulate_for_PSK(conv_raw_data,2^(modulate_bit),graycode_enable,A(k),repeat_time);
        % voltage to wave
        wave = voltage2wave(complex_voltages,1/Rs,sample_rate,alpha,'sqrt',sample_time);
        %onto carry wave
        send_wave = onto_carrywave(wave,carry_f,sample_rate);
        %wave channel
        receive_wave = wave_channel(send_wave,n0,sample_rate,SNR(k));
        % off cary wave
        receive_wave = off_carrywave(receive_wave,carry_f,sample_rate,single_band);
        % wave to voltage
        receive_voltages = wave2voltage(receive_wave,sample_rate,sample_time, Rs,'sqrt',alpha);
        % judge voltages
        [data_index,prob] = judge_for_PSK(receive_voltages,2^(modulate_bit),0,sites,repeat_time);
        receive_data = symbol2sequence_for_PSK(data_index,2^modulate_bit,graycode_enable);
        % 信道出错
        error = (conv_raw_data~=receive_data);
        figure
        subplot(3,1,1)
        plot(error(1:100))
        title('无信道编码')
%         deconv_receive_data = viterbi(length(conv_param),conv_memory,conv_param,viterbi_hard,...
%             conv_tail_enable,receive_data,modulate_bit);
%         error = (safe_data~=deconv_receive_data);
%         figure
%         plot(error(1:100))
%         title('卷积码硬判决')
        error_rate2(k)=error_rate2(k)+sum(error)/length(raw_data);
        
        % 软判决出错
        deconv_receive_data = viterbi(length(conv_param),conv_memory,conv_param,viterbi_soft,...
            conv_tail_enable,prob(:),modulate_bit);
        error = (safe_data~=deconv_receive_data);
        subplot(3,1,2)
        plot(error(1:100))
        title('卷积码软判决-无安全编码')
        %安全编码出错
        receive_safe_data = ECC_decrypt();%%%%%这里修改参数
        error = (raw_data~=receive_safe_data);
        subplot(3,1,3)
        plot(error(1:100))
        title('卷积码软判决-有安全编码')
        error_rate3(k)=error_rate3(k)+sum(error)/length(raw_data);
        
    end
end
error_rate2 = error_rate2/Iterations;
error_rate3 = error_rate3/Iterations;
figure
subplot(1,2,1)
load nocode
plot(Eb_n0_ratio(1,:),[error_rate2;error_rate3;error_rate],'-o')
title('误比特率线性曲线')
xlabel('E_b/n_0(dB)')
legend(['QPSK卷积码硬判决';'QPSK卷积码软判决';'BPSK无信道编码 ';'QPSK无信道编码 ';'8PSK无信道编码 '])
subplot(1,2,2)
plot(Eb_n0_ratio(1,:),[error_rate2;error_rate3;error_rate],'-o')
set(gca,'yscale','log')
title('误比特率对数曲线')
xlabel('E_b/n_0(dB)')
legend(['QPSK卷积码硬判决';'QPSK卷积码软判决';'BPSK无信道编码 ';'QPSK无信道编码 ';'8PSK无信道编码 '])
save('error1','Eb_n0_ratio','error_rate2','error_rate3')