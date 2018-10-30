clear all;
bias_ratio = [0.2,0.15]; %0.2 is best
% bias_ratio = 0.5;
sigma_ns = 1;
SNR=[-20:2.5:30];
A = sqrt(10.^(SNR/10)*2*sigma_ns^2/(1+bias_ratio(1))^2);
random_rate = 0.5;
sample_length = 9999;
voltage_num = 8;
wrong_rate = zeros(3,length(SNR));
Iterates = 10;

for k = 1:length(bias_ratio)
for n = 1:length(SNR)
    for i = 1:Iterates
        sample = random('bino',1,random_rate,1,sample_length);
                
        channel_mode = 1;
        input = sample;
        [input,sites,~] = modulate_for_ask_qam('8QAM1',log2(voltage_num),input,SNR(n),bias_ratio(2),0);
        out = channel(input,channel_mode,sigma_ns);
%         out = input;
        [result,~] = demodulate_for_ask_qam('8QAM1',log2(voltage_num),out,sites);
        result = symbol2sequence_for_PSK(result,voltage_num,0);
        wrong_rate(2,n) = wrong_rate(2,n)+1-sum(sample == result)/sample_length;
        
        input = sample;
        input = modulate_for_BPSK(input,voltage_num,1,A(n),bias_ratio(1));
        out = channel(input,channel_mode,sigma_ns);
        result = judge_for_BPSK(out,voltage_num,bias_ratio(1)*A(n));
        result = symbol2sequence_for_PSK(result,voltage_num,1);
        wrong_rate(1,n) = wrong_rate(1,n)+1-sum(sample == result)/sample_length;
        
        input = sample;
        [input,sites,~] = modulate_for_ask_qam('8QAM2',log2(voltage_num),input,SNR(n),bias_ratio(k),0);
        out = channel(input,channel_mode,sigma_ns);
%         out = input;
        [result,~] = demodulate_for_ask_qam('8QAM2',log2(voltage_num),out,sites);
        result = symbol2sequence_for_PSK(result,voltage_num,0);
        wrong_rate(3,n) = wrong_rate(3,n)+1-sum(sample == result)/sample_length;      
    end    
end
end
wrong_rate(1,:)=wrong_rate(1,:)/Iterates;
wrong_rate(2,:)=wrong_rate(2,:)/Iterates;
wrong_rate(3,:)=wrong_rate(3,:)/Iterates;
subplot(1,2,1)
plot(SNR,wrong_rate(1,:),'-o');
hold on 
plot(SNR,wrong_rate(2,:),'-s');
plot(SNR,wrong_rate(3,:),'-^');
legend(['8BPSK';'8BQAM';'8PQAM']);
% legend(['8BPSK';'8BQAM']);
xlabel('SNR/dB')
ylabel('误比特率BER')
title('BER SNR curve')

subplot(1,2,2)
plot(SNR,wrong_rate(1,:),'-o');
hold on 
plot(SNR,wrong_rate(2,:),'-s');
plot(SNR,wrong_rate(3,:),'-^');
set(gca,'yscale','log')
xlabel('SNR/dB')
ylabel('误比特率BER')
title('BER SNR log curve')
legend(['8BPSK';'8BQAM';'8PQAM'],'Location','southwest')
% legend(['8BPSK';'8BQAM'],'Location','southwest')
set(gca,'yscale','log')
title('BER SNR log curve')
xlabel('SNR/dB')
ylabel('误比特率BER')