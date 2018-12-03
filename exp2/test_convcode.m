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
sample_time = over_sample_rate/2;%��ƽתΪ����֮��Ĳ���ʱ�䣬Ϊ�˷�ֹ��ͨ�˲�֮����β����ʧ��

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
% Eb_n0_ratio = repmat([-30:2.5:30],length(modulate_bit),1);%�ز������
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

        raw_data = random('bino',1,random_rate,1,bit_length);
%         safe_raw_data = safe_decoder(raw_data,generate_key('SCODE'));
        conv_raw_data = convcode(raw_data,conv_param,conv_tail_enable);
        [complex_voltages,sites] = modulate_for_PSK(conv_raw_data,2^(modulate_bit),graycode_enable,A(k),repeat_time);

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
%         Eb = sum(spectrum)/Rs/modulate_bit;% ����ŵ�������
%         figure
%         plot(fs,spectrum);
%         title('�����ز����ι�����')
%         xlabel('f')
%         ylabel('�������ܶ�')
%         set(gca,'yscale','log')
        
%         figure
%         plot(t,[real(send_wave);imag(send_wave)])
%         title('�����ز�����')
%         xlabel('t')
%         legend(['�ز�����ʵ��';'�ز������鲿'])
        receive_wave = wave_channel(send_wave,n0,sample_rate,SNR(k));
%         figure
%         plot(t,[real(receive_wave);imag(receive_wave)])
%         title('�����ز�����')
%         xlabel('t')
%         legend(['�ز�����ʵ��';'�ز������鲿'])
        [spectrum,fs] = plot_power_spectrum(receive_wave,spectrum_windowsize,sample_rate);
%         figure
%         plot(fs,spectrum);
%         title('�����ز����ι�����')
%         xlabel('f')
%         ylabel('�������ܶ�')
%         set(gca,'yscale','log')
        receive_wave = off_carrywave(receive_wave,carry_f,sample_rate,single_band);
%         figure
%         plot(t,[real(receive_wave);imag(receive_wave)])
%         title('���ջ�������')
%         xlabel('t')
%         legend(['��������ʵ��';'���������鲿'])
%         
        [spectrum,~] = plot_power_spectrum(receive_wave,spectrum_windowsize,sample_rate);
%         figure
%         plot(fs,spectrum);
%         title('���ջ������ι�����')
%         xlabel('f')
%         ylabel('�������ܶ�')
%         set(gca,'yscale','log')
        receive_voltages = wave2voltage(receive_wave,sample_rate,sample_time, Rs,'sqrt',alpha);
        %% 
%         figure
%         plot(real(receive_voltages),imag(receive_voltages),'o')
        [data_index,prob] = judge_for_PSK(receive_voltages,2^(modulate_bit),0,sites,repeat_time);
        receive_data = symbol2sequence_for_PSK(data_index,2^modulate_bit,graycode_enable);
        error = (conv_raw_data~=receive_data);
%         figure
%         subplot(3,1,1)
%         plot(error(1:100))
%         title('���ŵ�����')
        deconv_receive_data = viterbi(length(conv_param),conv_memory,conv_param,viterbi_hard,...
            conv_tail_enable,receive_data,modulate_bit);
        error = (raw_data~=deconv_receive_data);
%         figure
%         plot(error(1:100))
%         title('�����Ӳ�о�')
        error_rate2(k)=error_rate2(k)+sum(error)/length(raw_data);
        deconv_receive_data = viterbi(length(conv_param),conv_memory,conv_param,viterbi_soft,...
            conv_tail_enable,prob(:),modulate_bit);
        error = (raw_data~=deconv_receive_data);
%         subplot(3,1,2)
%         plot(error(1:100))
%         title('��������о�-�ް�ȫ����')
%         receive_safe_data = safe_decoder(deconv_receive_data,generate_key('SCODE'));
%         error = (safe_raw_data~=receive_safe_data);
%         subplot(3,1,3)
%         plot(error(1:100))
%         title('��������о�-�а�ȫ����')
        error_rate3(k)=error_rate3(k)+sum(error)/length(raw_data);
        % figure
        % plot(t,[wave;receive_wave]);

%         ratio(k)=ratio(k)+10*log10(Eb/n0)     
    end
end
error_rate2 = error_rate2/Iterations;
error_rate3 = error_rate3/Iterations;
% ratio = ratio/Iterations;
figure
subplot(1,2,1)
load nocode
plot(Eb_n0_ratio(1,:),[error_rate2;error_rate3;error_rate],'-o')
title('���������������')
xlabel('E_b/n_0(dB)')
legend(['QPSK�����Ӳ�о�';'QPSK��������о�';'BPSK���ŵ����� ';'QPSK���ŵ����� ';'8PSK���ŵ����� '])
subplot(1,2,2)
plot(Eb_n0_ratio(1,:),[error_rate2;error_rate3;error_rate],'-o')
set(gca,'yscale','log')
title('������ʶ�������')
xlabel('E_b/n_0(dB)')
legend(['QPSK�����Ӳ�о�';'QPSK��������о�';'BPSK���ŵ����� ';'QPSK���ŵ����� ';'8PSK���ŵ����� '])
save('error1','Eb_n0_ratio','error_rate2','error_rate3')
% index = ceil(find(error == 1)/2);
% hold on
% plot(real(receive_voltages(index)),imag(receive_voltages(index)),'o')
% figure
% subplot(1,2,1)
% plot(total_ratio,[error1],'-o');
% hold on 
% plot(new_ratio,[error2;error3],'-o');
% title('���������������')
% xlabel('E_b/n_0(dB)')
% legend(['���ŵ����� ';'�����Ӳ�о�';'��������о�'])
% subplot(1,2,2)
% plot(total_ratio,[error1],'-o');
% hold on 
% plot(new_ratio,[error2;error3],'-o');
% set(gca,'yscale','log')
% title('������ʶ�������')
% xlabel('E_b/n_0(dB)')
% legend(['���ŵ����� ';'�����Ӳ�о�';'��������о�'])