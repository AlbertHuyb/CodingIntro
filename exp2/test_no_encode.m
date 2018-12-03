clear all;
bit_length = 16;
random_rate = 0.5;
alpha = 0.5;
single_band = 1500;
carry_f = 1850;
over_sample_rate = 20;
spectrum_windowsize = 200;

Rs = single_band*2/(1+alpha); 
dt = 1/Rs/over_sample_rate;
sample_rate = 1/dt;
sample_time = over_sample_rate/2;%��ƽתΪ����֮��Ĳ���ʱ�䣬Ϊ�˷�ֹ��ͨ�˲�֮����β����ʧ��

% A = [0.05:0.1:3];
% A = 0.8;
Iterations = 5;
n0 = 2e-5;
h = rcosdesign(alpha,6,1/Rs/dt,'sqrt');
max_h = max(h);
h = h/max_h;
% Eh = sum(h.*h)*dt;
Eh = 1;
% modulate_bit = [1,2,3];
modulate_bit = [2];
% Eb_n0_ratio = repmat([-30:2.5:30],length(modulate_bit),1);%�ز������
Eb_n0_ratio = repmat([8],length(modulate_bit),1);
SNR = 10*log10(10.^(Eb_n0_ratio/10).*repmat(modulate_bit',1,size(Eb_n0_ratio,2))*Rs/sample_rate);
% carry_ratio = repmat([1,2,2]',1,size(Eb_n0_ratio,2));
A = sqrt(repmat(modulate_bit',1,size(Eb_n0_ratio,2)).*n0.*10.^(Eb_n0_ratio/10)/Eh);
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
    for k=1:length(A(nn,:))
        k
        symbol_num = bit_length/modulate_bit(nn);
        t = [0:dt:1/Rs*symbol_num*repeat_time-dt];

        raw_data = random('bino',1,random_rate,1,bit_length);
        [complex_voltages,sites] = modulate_for_PSK(raw_data,2^(modulate_bit(nn)),graycode_enable,A(nn,k),repeat_time);
        
        %% voltage channel
        wave = voltage2wave(complex_voltages,1/Rs,sample_rate,alpha,'sqrt',sample_time);
        % receive_voltages = wave2voltage(wave,sample_rate,sample_time, Rs,'sqrt',alpha);
        [spectrum,fs] = plot_power_spectrum(wave,spectrum_windowsize,sample_rate);
        send_wave = onto_carrywave(wave,carry_f,sample_rate);
%         figure
%         plot(fs,spectrum);
%         title('����������ι�����')
%         xlabel('f')
%         ylabel('�������ܶ�')
%         set(gca,'yscale','log')

        [spectrum,fs] = plot_power_spectrum(send_wave,spectrum_windowsize,sample_rate);
        Eb = sum(spectrum)/Rs/modulate_bit(nn);% ����ŵ�������
%         figure
%         plot(fs(fs>=0 & fs <=5000),spectrum(fs>=0 & fs <=5000));
%         title('�����ز����ι�����')
%         xlabel('f')
%         ylabel('�������ܶ�')
%         set(gca,'yscale','log')
%         figure
%         plot(fs,spectrum);
%         title('�����ز����ι�����')
%         xlabel('f')
%         ylabel('�������ܶ�')
%         set(gca,'yscale','log')

%         figure
%         plot(t,real(wave))
%         hold on
%         plot(t,imag(wave))
%         plot(t,send_wave)
%         legend(['��������ʵ��';'���������鲿';'�ز�����  ']);
%         title('���䲨��')
%         xlabel('t')

         receive_wave = wave_channel(send_wave,n0,sample_rate,SNR(nn,k));
%          receive_wave = send_wave;

%         figure
%         plot(t,real(receive_wave))
%         title('�����ز�����')
%         xlabel('t')
        [spectrum,fs] = plot_power_spectrum(receive_wave,spectrum_windowsize,sample_rate);
%         figure
%         plot(fs,spectrum);
%         title('�����ز����ι�����')
%         xlabel('f')
%         ylabel('�������ܶ�')
%         set(gca,'yscale','log')
        receive_wave = off_carrywave(receive_wave,carry_f,sample_rate,single_band);
%         figure
%         hold on
%         plot(t,[real(receive_wave);imag(receive_wave)])
%         title('���ջ�������')
%         xlabel('t')
%         legend(['��������ʵ��';'���������鲿'])
        [spectrum,~] = plot_power_spectrum(receive_wave,spectrum_windowsize,sample_rate);
%         figure
%         plot(fs,spectrum);
%         title('���ջ������ι�����')
%         xlabel('f')
%         ylabel('�������ܶ�')
%         set(gca,'yscale','log')
        receive_voltages = wave2voltage(receive_wave,sample_rate,sample_time, Rs,'sqrt',alpha);
        %% 
        % figure
        % plot(real(receive_voltages),imag(receive_voltages),'o')
        [data_index,prob] = judge_for_PSK(receive_voltages,2^(modulate_bit(nn)),0,sites,repeat_time);
        receive_data = symbol2sequence_for_PSK(data_index,2^modulate_bit(nn),graycode_enable);
        % figure
        % plot(t,[wave;receive_wave]);

%         ratio(nn,k)=ratio(nn,k)+10*log10(Eb/n0)
        error = (raw_data~=receive_data);
        sum(error)
        error_rate(nn,k)=error_rate(nn,k)+sum(error)/length(raw_data);
    end
    end
end
error_rate = error_rate/Iterations;
% ratio = ratio/Iterations;
save('nocode','Eb_n0_ratio','error_rate');
figure
subplot(1,2,1)
for nn = 1:length(modulate_bit)
    plot(Eb_n0_ratio(nn,:),error_rate(nn,:),'-o')
    hold on
end
title('���������������')
xlabel('E_b/n_0(dB)')
legend(['BPSK';'QPSK';'8PSK'])
subplot(1,2,2)
for nn = 1:length(modulate_bit)
    plot(Eb_n0_ratio(nn,:),error_rate(nn,:),'-o')
    hold on
end
set(gca,'yscale','log')
title('������ʶ�������')
xlabel('E_b/n_0(dB)')
legend(['BPSK';'QPSK';'8PSK'])
% index = ceil(find(error == 1)/3);
% hold on
% plot(real(receive_voltages(index)),imag(receive_voltages(index)),'o')