clear all;
A = 3; %amplify
len = [5,10,15,20]; %10 for 4symbols, 
sigma_ns = [0.41:0.2:8];
random_rate = 0.5;
sample_length = 9999;
voltage_num = 8;
wrong_rate = zeros(1,length(sigma_ns));
Iterates = 10;

temp = [];

for k = 1:length(len)
for n = 1:length(sigma_ns)
    for i = 1:Iterates
        sample = random('bino',1,random_rate,1,sample_length);
                
        channel_mode = 1;
        input = add_sequence_for_MPSK(sample,voltage_num,len(k));
        [input,sites] = modulate_for_PSK(input,voltage_num,0,A);
        out = channel(input,channel_mode,sigma_ns(n));
        [result,prob] = judge_for_PSK(out,voltage_num,len(k),sites);
        result = symbol2sequence_for_PSK(result,voltage_num,0);
        wrong_rate(1,n) = wrong_rate(1,n)+1-sum(sample == result)/sample_length;
    end
    wrong_rate(1,n)=wrong_rate(1,n)/Iterates;
end
    S1 = A^2;
    SNR1 = 10*log10(S1./(2*sigma_ns.^2));
    plot(SNR1,wrong_rate(1,:));
    hold on 
end
legend(num2str(len'))
set(gca,'yscale','log')
title('3bit映射不同前缀长度下的误比特率与信噪比曲线')
xlabel('SNR/dB')
ylabel('误比特率BER')