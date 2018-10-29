clear all;
A = 3; %amplify
bias_ratio = [0.1:0.1:0.5]; %0.2 is best
sigma_ns = [0.01:0.2:8];
random_rate = 0.5;
sample_length = 9999;
voltage_num = 8;
wrong_rate = zeros(1,length(sigma_ns));
Iterates = 10;

temp = [];

for k = 1:length(bias_ratio)
for n = 1:length(sigma_ns)
    for i = 1:Iterates
        sample = random('bino',1,random_rate,1,sample_length);
                
        channel_mode = 1;
        input = sample;
        input = modulate_for_BPSK(input,voltage_num,1,A,bias_ratio(k));
        out = channel(input,channel_mode,sigma_ns(n));
        result = judge_for_BPSK(out,voltage_num,bias_ratio(k)*A);
        result = symbol2sequence_for_PSK(result,voltage_num,1);
        wrong_rate(1,n) = wrong_rate(1,n)+1-sum(sample == result)/sample_length;
        
    end
    wrong_rate(1,n)=wrong_rate(1,n)/Iterates;
end
    S1 = sum(abs(bias_ratio(k)*A+A*exp(j*([1:voltage_num]-1)*2*pi/voltage_num)).^2)/voltage_num;
    SNR1 = 10*log10(S1./(2*sigma_ns.^2));
    plot(SNR1,wrong_rate(1,:));
    hold on 
end
legend(num2str(bias_ratio'))
set(gca,'yscale','log')
title('1bit映射不同偏置系数下的误比特率与信噪比曲线')
xlabel('SNR/dB')
ylabel('误比特率BER')