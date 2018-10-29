clear all;
A = 3; %amplify
len = 10; %10 for 4symbols, 
SNR = [-20:2.5:30];
S1 = A^2;
sigma_ns = sqrt(S1/2./10.^(SNR/10));
random_rate = 0.5;
sample_length = 2*[10000,10000,9999];
voltage_num = [2,4,8];
wrong_rate = zeros(length(voltage_num),length(sigma_ns));
Iterates = 10;

for k = 1:length(voltage_num)
for n = 1:length(sigma_ns)
    for i = 1:Iterates
        sample = random('bino',1,random_rate,1,sample_length(k));
                
        channel_mode = 1;
        input = add_sequence_for_MPSK(sample,voltage_num(k),len);
        input = modulate_for_PSK(input,voltage_num(k),1,A);
        out = channel(input,channel_mode,sigma_ns(n));
        result = judge_for_PSK(out,voltage_num(k),len);
        result = symbol2sequence_for_PSK(result,voltage_num(k),1);
        wrong_rate(k,n) = wrong_rate(k,n)+1-sum(sample == result)/sample_length(k);
    end
    wrong_rate(k,n)=wrong_rate(k,n)/Iterates;
end
end

subplot(1,2,1)
plot(SNR,wrong_rate(1,:),'-o');
hold on 
plot(SNR,wrong_rate(2,:),'-s');
plot(SNR,wrong_rate(3,:),'-^');
legend(['1bit';'2bit';'3bit']);
xlabel('SNR/dB')
ylabel('误比特率BER')
title('BER SNR curve')

subplot(1,2,2)
plot(SNR,wrong_rate(1,:),'-o');
hold on 
plot(SNR,wrong_rate(2,:),'-s');
plot(SNR,wrong_rate(3,:),'-^');
legend(['1bit';'2bit';'3bit'],'Location','southwest');
set(gca,'yscale','log')
xlabel('SNR/dB')
ylabel('误比特率BER')
title('BER SNR log curve')

for k = 1:length(voltage_num)
    sample = random('bino',1,random_rate,1,sample_length(k));
                
    channel_mode = 1;
    input = add_sequence_for_MPSK(sample,voltage_num(k),len);
    input = modulate_for_PSK(input,voltage_num(k),1,A);
    out = channel(input,channel_mode,sigma_ns(15));
    figure
    subplot(1,2,1)
    plot(real(input),imag(input),'o')
    title(['信噪比',num2str(SNR(15)),'dB 时',num2str(k),'bit 发端星座图'])
    axis([-5 5 -6 6])
    subplot(1,2,2)
    plot(real(out),imag(out),'o')
    title(['信噪比',num2str(SNR(15)),'dB 时',num2str(k),'bit 收端星座图'])
    axis([-5 5 -6 6])
end
    