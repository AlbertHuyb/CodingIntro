clear all;
bias_ratio = [0.05:0.03:0.2]; %0.2 is best
% bias_ratio = 0.5;
sigma_ns = 1;
SNR=[-20:2.5:30];
random_rate = 0.5;
sample_length = 9999;
voltage_num = 8;
wrong_rate = zeros(length(bias_ratio),length(SNR));
Iterates = 10;

temp = [];

for k = 1:length(bias_ratio)
for n = 1:length(SNR)
    for i = 1:Iterates
        sample = random('bino',1,random_rate,1,sample_length);
                
        channel_mode = 1;
        input = sample;
        [input,sites,~] = modulate_for_ask_qam('8QAM3',log2(voltage_num),input,SNR(n),bias_ratio(k),0);
        out = channel(input,channel_mode,sigma_ns);
%         out = input;
        [result,~] = demodulate_for_ask_qam('8QAM3',log2(voltage_num),out,sites);
        result = symbol2sequence_for_PSK(result,voltage_num,0);
        wrong_rate(k,n) = wrong_rate(k,n)+1-sum(sample == result)/sample_length;
        
    end
    wrong_rate(k,n)=wrong_rate(k,n)/Iterates;
end
end
for k = 1:length(bias_ratio)
    plot(SNR,wrong_rate(k,:));
    hold on
end
legend(num2str(roundn(bias_ratio,-2)'),'Location','southwest')
set(gca,'yscale','log')
title('3bitӳ�䲻ͬƫ��ϵ���µ�������������������')
xlabel('SNR/dB')
ylabel('�������BER')

figure
input = sample;
[input,sites,~] = modulate_for_ask_qam('8QAM3',log2(voltage_num),input,18,bias_ratio(k),0);
out = channel(input,channel_mode,sigma_ns);
figure
subplot(1,2,1)
plot(real(input),imag(input),'o')
title(['�����',num2str(18),'dB ʱ','��������ͼ'])

subplot(1,2,2)
plot(real(out),imag(out),'o')
title(['�����',num2str(18),'dB ʱ','�ն�����ͼ'])
