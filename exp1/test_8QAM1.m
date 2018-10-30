clear all;
%bias_ratio = [0.1:0.1:0.5]; %0.2 is best
bias_ratio = 0.5;
sigma_ns = 1;
% SNR=[-20:2.5:30];
SNR = 20;
random_rate = 0.5;
sample_length = 999;
voltage_num = 8;
wrong_rate = zeros(1,length(SNR));
Iterates = 10;

temp = [];

for k = 1:length(bias_ratio)
for n = 1:length(SNR)
    for i = 1:Iterates
        sample = random('bino',1,random_rate,1,sample_length);
                
        channel_mode = 1;
        input = sample;
        [input,sites,~] = modulate_for_ask_qam('8QAM1',log2(voltage_num),input,SNR(n),bias_ratio(k),0);
        %out = channel(input,channel_mode,sigma_ns);
        out = input;
        [result,~] = demodulate_for_ask_qam('8QAM1',log2(voltage_num),out,sites);
        result = result -1;
        result = symbol2sequence_for_PSK(result,voltage_num,0);
        wrong_rate(1,n) = wrong_rate(1,n)+1-sum(sample == result)/sample_length;
        
    end
    wrong_rate(1,n)=wrong_rate(1,n)/Iterates;
end
    plot(SNR,wrong_rate(1,:));
    hold on 
end
legend(num2str(bias_ratio'))
set(gca,'yscale','log')
title('1bitӳ�䲻ͬƫ��ϵ���µ�������������������')
xlabel('SNR/dB')
ylabel('�������BER')