clearvars;
close all;
clc;

SNR = -20:2.5:30;
random_rate = 0.5;
sample_length = 10000;
alphabetabits = [1,2,3];
Iterates = 10;

p_wrong = zeros(2,length(alphabetabits),length(SNR));
wrong_rate = zeros(2,length(alphabetabits),length(SNR));


parfor n = 1:length(SNR)
    p_correct_temp = zeros(2,length(alphabetabits),Iterates);
    wrong_rate_temp = zeros(2,length(alphabetabits));
    for k = 1:length(alphabetabits)
        for i = 1:Iterates
            sample = random('bino',1,random_rate,1,sample_length);
            channel_mode = 2;
            input = sample;
            [input,symbol,p_correct_temp(1,k,i)] = modulate_for_ask_qam('ASK',alphabetabits(k),input,SNR(n),0,1);
            out = channel(input,channel_mode,1);
            [result,~]= demodulate_for_ask_qam('ASK',alphabetabits(k),out,symbol);
            result = symbol2sequence_for_PSK(result,2^alphabetabits(k),1);
            wrong_rate_temp(1,k) = wrong_rate_temp(1,k)+1-sum(sample == result)/sample_length;
            sample = random('bino',1,random_rate,1,sample_length);
            channel_mode = 2;
            input = sample;
            [input,symbol,p_correct_temp(2,k,i)] = modulate_for_ask_qam('ASK',alphabetabits(k),input,SNR(n),0,0);
            out = channel(input,channel_mode,1);
            result = demodulate_for_ask_qam('ASK',alphabetabits(k),out,symbol);
            result = symbol2sequence_for_PSK(result,alphabetabits(k),0);
            wrong_rate_temp(2,k) = wrong_rate_temp(2,k)+1-sum(sample == result)/sample_length;
        end
    end
    wrong_rate(:,:,n) = wrong_rate_temp/Iterates;
    p_wrong = 1-mean(p_correct_temp,3);
end


subplot(1,2,1)
plot(SNR,wrong_rate(1,1,:),'-o');
hold on
plot(SNR,wrong_rate(1,2,:),'-s');
plot(SNR,wrong_rate(1,3,:),'-^');
plot(SNR,wrong_rate(2,1,:),'--o');
plot(SNR,wrong_rate(2,2,:),'--s');
plot(SNR,wrong_rate(2,3,:),'--^');
legend(['BPSK  1bit';'BPSK  2bit';'BPSK  3bit';'s-PSK 1bit';'s-PSK 2bit';'s-PSK 3bit']);
xlabel('SNR/dB')
ylabel('误比特率BER')
title('BER SNR curve')

subplot(1,2,2)
plot(SNR,wrong_rate(1,1,:),'-o');
hold on
plot(SNR,wrong_rate(1,2,:),'-s');
plot(SNR,wrong_rate(1,3,:),'-^');
plot(SNR,wrong_rate(2,1,:),'--o');
plot(SNR,wrong_rate(2,2,:),'--s');
plot(SNR,wrong_rate(2,3,:),'--^');
legend(['BPSK  1bit';'BPSK  2bit';'BPSK  3bit';'s-PSK 1bit';'s-PSK 2bit';'s-PSK 3bit']...
    ,'Location','southwest');
set(gca,'yscale','log')
xlabel('SNR/dB')
ylabel('误比特率BER')
title('BER SNR log curve')


tic;

for k = 1:length(alphabetabits)
    sample = random('bino',1,random_rate,1,sample_length);
    channel_mode = 2;
    input = sample;
    [input,~,~] = modulate_for_ask_qam('ASK',alphabetabits(k),input,15,0,1);
    out = channel(input,channel_mode,1);
    figure
    subplot(1,2,1)
    plot(real(input),imag(input),'o')
    title(['信噪比',num2str(15),'dB 时',num2str(k),'bit 发端星座图'])
    axis([-15 15 -15 15])
    subplot(1,2,2)
    plot(real(out),imag(out),'o')
    title(['信噪比',num2str(15),'dB 时',num2str(k),'bit 收端星座图'])
    axis([-15 15 -15 15])
end

toc;