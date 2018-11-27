clear all;
bit_length = 16;
random_rate = 0.5;
alpha = 0.5;
single_band = 1500;
carry_f = 1850;
over_sample_rate = 20;

Rs = single_band*2/(1+alpha); 
dt = 1/Rs/over_sample_rate;
sample_rate = 1/dt;
sample_time = over_sample_rate/2;%��ƽתΪ����֮��Ĳ���ʱ�䣬Ϊ�˷�ֹ��ͨ�˲�֮����β����ʧ��

A = [1];
Iterations = 10;
n0 = 2e-5;
modulate_bit = [2];
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
        symbol_num = bit_length/modulate_bit(nn);
        t = [0:dt:1/Rs*symbol_num*repeat_time-dt];

        raw_data = random('bino',1,random_rate,1,bit_length);
        [complex_voltages,sites] = modulate_for_PSK(raw_data,2^(modulate_bit(nn)),graycode_enable,A(k),repeat_time);

        %% voltage channel
        wave = voltage2wave(complex_voltages,1/Rs,sample_rate,alpha,'sqrt',sample_time);
        % receive_voltages = wave2voltage(wave,sample_rate,sample_time, Rs,'sqrt',alpha);
        [spectrum,fs] = plot_power_spectrum(wave,10,sample_rate);
        send_wave = onto_carrywave(wave,carry_f,sample_rate);
        figure
        plot(fs,spectrum);
        title('����������ι�����')
        xlabel('f')
        ylabel('�������ܶ�')

        [spectrum,fs] = plot_power_spectrum(send_wave,10,sample_rate);
        Eb = sum(spectrum)/Rs/modulate_bit(nn);% ����ŵ�������
        figure
        plot(fs,spectrum);
        title('�����ز����ι�����')
        xlabel('f')
        ylabel('�������ܶ�')

        figure
        plot(t,[real(send_wave);imag(send_wave)])
        title('�����ز�����')
        xlabel('t')
        legend(['�ز�����ʵ��';'�ز������鲿'])
        receive_wave = wave_channel(send_wave,n0,sample_rate);

        figure
        plot(t,[real(receive_wave);imag(receive_wave)])
        title('�����ز�����')
        xlabel('t')
        legend(['�ز�����ʵ��';'�ز������鲿'])
        [spectrum,fs] = plot_power_spectrum(receive_wave,10,sample_rate);
        figure
        plot(fs,spectrum);
        title('�����ز����ι�����')
        xlabel('f')
        ylabel('�������ܶ�')
        receive_wave = off_carrywave(receive_wave,carry_f,sample_rate,single_band);
        figure
        plot(t,[real(receive_wave);imag(receive_wave)])
        title('���ջ�������')
        xlabel('t')
        legend(['�ز�����ʵ��';'�ز������鲿'])
        [spectrum,~] = plot_power_spectrum(receive_wave,10,sample_rate);
        figure
        plot(fs,spectrum);
        title('���ջ������ι�����')
        xlabel('f')
        ylabel('�������ܶ�')
        receive_voltages = wave2voltage(receive_wave,sample_rate,sample_time, Rs,'normal',alpha);
        %% 
        % figure
        % plot(real(receive_voltages),imag(receive_voltages),'o')
        [data_index,prob] = judge_for_PSK(receive_voltages,2^(modulate_bit(nn)),0,sites,repeat_time);
        receive_data = symbol2sequence_for_PSK(data_index,2^modulate_bit(nn),graycode_enable);
        % figure
        % plot(t,[wave;receive_wave]);

        ratio(nn,k)=ratio(nn,k)+10*log10(Eb/n0)
        error = (raw_data~=receive_data);
        error_rate(nn,k)=error_rate(nn,k)+sum(error)/length(raw_data);
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
title('���������������')
xlabel('E_b/n_0(dB)')
legend(['1bit';'2bit';'3bit'])
subplot(1,2,2)
for nn = 1:length(modulate_bit)
    plot(ratio(nn,:),error_rate(nn,:),'-o')
    hold on
end
set(gca,'yscale','log')
title('������ʶ�������')
xlabel('E_b/n_0(dB)')
legend(['1bit';'2bit';'3bit'])
% index = ceil(find(error == 1)/3);
% hold on
% plot(real(receive_voltages(index)),imag(receive_voltages(index)),'o')