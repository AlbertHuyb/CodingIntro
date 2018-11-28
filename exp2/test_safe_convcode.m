clear all;
bit_length = 1024;
random_rate = 0.5;
alpha = 0.5;
single_band = 1500;
carry_f = 1850;
over_sample_rate = 20;

Rs = single_band*2/(1+alpha); 
dt = 1/Rs/over_sample_rate;
sample_rate = 1/dt;
sample_time = over_sample_rate/2;%电平转为波形之后的采样时间，为了防止低通滤波之后首尾出现失真

A = [0.5];
Iterations = 5;
n0 = 2e-5;
modulate_bit = 2;
repeat_time = 1;
graycode_enable = 1;

conv_param = [15,17];
conv_memory = (conv_param(1)<=17 & conv_param(1)>7)*4+(conv_param(1)<=7 & conv_param(1)>3)*3;
conv_tail_enable = 1;
viterbi_hard = 1;
viterbi_soft = ~viterbi_hard;

ratio = zeros(length(modulate_bit),length(A));
error_rate = zeros(length(modulate_bit),length(A));
for i = 1:Iterations
    for nn = 1:length(modulate_bit)
    for k=1:length(A)
        k
        symbol_num = bit_length/modulate_bit;
        t = [0:dt:1/Rs*symbol_num*repeat_time*length(conv_param)-dt];

        safe_raw_data = random('bino',1,random_rate,1,bit_length);
        conv_safe_data = convcode(raw_data,conv_param,~conv_tail_enable);
        %safe_conv_data = safe_decoder(conv_raw_data,generate_key('SCODE'));
        safe_data = ECC_encrypt(conv_safe_data,1,1,10007,1,1477,10065,11);
        raw_data = viterbi(length(conv_param),conv_memory,conv_param,viterbi_hard,~conv_tail_enable,safe_data,1);
        [complex_voltages,sites] = modulate_for_PSK(safe_data,2^(modulate_bit),graycode_enable,A(k),repeat_time);

        %% voltage channel
        wave = voltage2wave(complex_voltages,1/Rs,sample_rate,alpha,'sqrt',sample_time);
        % receive_voltages = wave2voltage(wave,sample_rate,sample_time, Rs,'sqrt',alpha);
        [spectrum,fs] = plot_power_spectrum(wave,10,sample_rate);
        send_wave = onto_carrywave(wave,carry_f,sample_rate);
%         figure
%         plot(fs,spectrum);
%         title('发射基带波形功率谱')
%         xlabel('f')
%         ylabel('功率谱密度')

        [spectrum,fs] = plot_power_spectrum(send_wave,10,sample_rate);
        Eb = sum(spectrum)/Rs/modulate_bit;% 如果信道编码是
%         figure
%         plot(fs,spectrum);
%         title('发射载波波形功率谱')
%         xlabel('f')
%         ylabel('功率谱密度')
        
%         figure
%         plot(t,[real(send_wave);imag(send_wave)])
%         title('发射载波波形')
%         xlabel('t')
%         legend(['载波波形实部';'载波波形虚部'])
        receive_wave = wave_channel(send_wave,n0,sample_rate);
%         figure
%         plot(t,[real(receive_wave);imag(receive_wave)])
%         title('接收载波波形')
%         xlabel('t')
%         legend(['载波波形实部';'载波波形虚部'])
        [spectrum,fs] = plot_power_spectrum(receive_wave,10,sample_rate);
%         figure
%         plot(fs,spectrum);
%         title('接收载波波形功率谱')
%         xlabel('f')
%         ylabel('功率谱密度')
        receive_wave = off_carrywave(receive_wave,carry_f,sample_rate,single_band);
%         figure
%         plot(t,[real(receive_wave);imag(receive_wave)])
%         title('接收基带波形')
%         xlabel('t')
%         legend(['基带波形实部';'基带波形虚部'])
        [spectrum,~] = plot_power_spectrum(receive_wave,10,sample_rate);
%         figure
%         plot(fs,spectrum);
%         title('接收基带波形功率谱')
%         xlabel('f')
%         ylabel('功率谱密度')
        receive_voltages = wave2voltage(receive_wave,sample_rate,sample_time, Rs,'normal',alpha);
        %% 
%         figure
%         plot(real(receive_voltages),imag(receive_voltages),'o')
        [data_index,prob] = judge_for_PSK(receive_voltages,2^(modulate_bit),0,sites,repeat_time);
        receive_data = symbol2sequence_for_PSK(data_index,2^modulate_bit,graycode_enable);
        error = (safe_data~=receive_data);
        figure
        plot(error(1:100))
        title('无信道编码')
        receive_safe_data = safe_decoder(safe_data,generate_key('SCODE'));
        error = (conv_safe_data~=receive_safe_data);
        figure
        plot(error(1:100))
        title('无信道编码+安全编码')
        deconv_receive_data = viterbi(length(conv_param),conv_memory,conv_param,viterbi_hard,...
            ~conv_tail_enable,receive_data,modulate_bit);
        error = (raw_data~=deconv_receive_data);
        figure
        plot(error(1:100))
        title('卷积码硬判决')
        deconv_receive_data = viterbi(length(conv_param),conv_memory,conv_param,viterbi_hard,...
            ~conv_tail_enable,receive_safe_data,modulate_bit);
        error = (safe_raw_data~=deconv_receive_data);
        figure
        plot(error(1:100))
        title('卷积码硬判决+安全编码')
        deconv_receive_data = viterbi(length(conv_param),conv_memory,conv_param,viterbi_soft,...
            ~conv_tail_enable,prob(:),modulate_bit);
        % figure
        % plot(t,[wave;receive_wave]);

        ratio(nn,k)=ratio(nn,k)+10*log10(Eb/n0);
        error_rate(nn,k)=error_rate(nn,k)+sum(error)/length(raw_data);
        %%
        safe_data = safe_encoder(conv_raw_data,generate_key('SCODE'));
        [complex_voltages,sites] = modulate_for_PSK(safe_data,2^(modulate_bit),graycode_enable,A(k),repeat_time);

        %% voltage channel
        wave = voltage2wave(complex_voltages,1/Rs,sample_rate,alpha,'sqrt',sample_time);
        % receive_voltages = wave2voltage(wave,sample_rate,sample_time, Rs,'sqrt',alpha);
        [spectrum,fs] = plot_power_spectrum(wave,10,sample_rate);
        send_wave = onto_carrywave(wave,carry_f,sample_rate);
%         figure
%         plot(fs,spectrum);
%         title('发射基带波形功率谱')
%         xlabel('f')
%         ylabel('功率谱密度')

        [spectrum,fs] = plot_power_spectrum(send_wave,10,sample_rate);
        Eb = sum(spectrum)/Rs/modulate_bit;% 如果信道编码是
%         figure
%         plot(fs,spectrum);
%         title('发射载波波形功率谱')
%         xlabel('f')
%         ylabel('功率谱密度')
        
%         figure
%         plot(t,[real(send_wave);imag(send_wave)])
%         title('发射载波波形')
%         xlabel('t')
%         legend(['载波波形实部';'载波波形虚部'])
        receive_wave = wave_channel(send_wave,n0,sample_rate);
%         figure
%         plot(t,[real(receive_wave);imag(receive_wave)])
%         title('接收载波波形')
%         xlabel('t')
%         legend(['载波波形实部';'载波波形虚部'])
        [spectrum,fs] = plot_power_spectrum(receive_wave,10,sample_rate);
%         figure
%         plot(fs,spectrum);
%         title('接收载波波形功率谱')
%         xlabel('f')
%         ylabel('功率谱密度')
        receive_wave = off_carrywave(receive_wave,carry_f,sample_rate,single_band);
%         figure
%         plot(t,[real(receive_wave);imag(receive_wave)])
%         title('接收基带波形')
%         xlabel('t')
%         legend(['基带波形实部';'基带波形虚部'])
        [spectrum,~] = plot_power_spectrum(receive_wave,10,sample_rate);
%         figure
%         plot(fs,spectrum);
%         title('接收基带波形功率谱')
%         xlabel('f')
%         ylabel('功率谱密度')
        receive_voltages = wave2voltage(receive_wave,sample_rate,sample_time, Rs,'normal',alpha);
        %% 
%         figure
%         plot(real(receive_voltages),imag(receive_voltages),'o')
        [data_index,prob] = judge_for_PSK(receive_voltages,2^(modulate_bit),0,sites,repeat_time);
        receive_data = symbol2sequence_for_PSK(data_index,2^modulate_bit,graycode_enable);
        
        deconv_receive_data = viterbi(length(conv_param),conv_memory,conv_param,viterbi_hard,...
            ~conv_tail_enable,receive_data(1:length(conv_raw_data)),modulate_bit);
        error = (raw_data~=deconv_receive_data);
        figure
        plot(error(1:100))
        title('卷积码硬判决+安全编码')
        prob = prob(:,1:length(conv_raw_data)/modulate_bit);
        deconv_receive_data = viterbi(length(conv_param),conv_memory,conv_param,viterbi_soft,...
            ~conv_tail_enable,prob(:),modulate_bit);
        % figure
        % plot(t,[wave;receive_wave]);

        ratio(nn,k)=ratio(nn,k)+10*log10(Eb/n0);
        error = (raw_data~=deconv_receive_data);
        figure
        plot(error(1:100))
        title('卷积码软判决+安全编码')
    end
    end
end
error_rate = error_rate/Iterations;
ratio = ratio/Iterations;
figure
subplot(1,2,1)
for nn = 1:length(modulate_bit)
    plot(ratio(nn,:),error_rate(nn,:),'-o')
    hold on
end
title('误比特率线性曲线')
xlabel('E_b/n_0(dB)')
legend(['1bit';'2bit';'3bit'])
subplot(1,2,2)
for nn = 1:length(modulate_bit)
    plot(ratio(nn,:),error_rate(nn,:),'-o')
    hold on
end
set(gca,'yscale','log')
title('误比特率对数曲线')
xlabel('E_b/n_0(dB)')
legend(['1bit';'2bit';'3bit'])
% index = ceil(find(error == 1)/2);
% hold on
% plot(real(receive_voltages(index)),imag(receive_voltages(index)),'o')