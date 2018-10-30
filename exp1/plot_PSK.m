clear all;
A = 3; %amplify
len = 10; %10 for 4symbols, 
SNR = [-20:2.5:20];
S1 = A^2;
sigma_ns = sqrt(S1/2./10.^(SNR/10));
random_rate = 0.5;
sample_length = [1000,1000,999];
voltage_num = [2,4,8];
wrong_rate = zeros(length(voltage_num),length(sigma_ns));
Iterates = 10;

for k = 1:length(voltage_num)
for n = 1:length(sigma_ns)
    for i = 1:Iterates
        sample = random('bino',1,random_rate,1,sample_length(k));
                
        channel_mode = 1;
        input = convcode(sample,[15,17],1);
        input = add_sequence_for_MPSK(input,voltage_num(k),len);
        [input,sites] = modulate_for_PSK(input,voltage_num(k),1,A);
        out = channel(input,channel_mode,sigma_ns(n));
        [result,prob] = judge_for_PSK(out,voltage_num(k),len,sites);
        result = symbol2sequence_for_PSK(result,voltage_num(k),1);
        [seq,sym] = viterbi(2,4,[15,17],1,1,result,log2(voltage_num(k)));
        seq = seq(1:end-4);
        wrong_rate(k,n) = wrong_rate(k,n)+1-sum(sample == seq)/sample_length(k);
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
    