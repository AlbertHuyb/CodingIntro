clearvars;
close all;
clc;

SNR = -20:2.5:30;
% SNR=30;
random_rate = 0.5;
sample_length = 1200;
alphabetabits = [3];
Iterates = 10;

p_wrong = zeros(2*length(alphabetabits),length(SNR));
wrong_rate = zeros(2*length(alphabetabits),length(SNR));
tic
parfor n = 1:length(SNR)
    p_correct_temp = zeros(2*length(alphabetabits),Iterates);
    wrong_rate_temp = zeros(2*length(alphabetabits),1);
    for k = 1:length(alphabetabits)
        for i = 1:Iterates
            sample = random('bino',1,random_rate,1,sample_length);
            channel_mode = 2;
            input0 = convcode(sample,[15,17],0);
            [input,symbol,p_correct_temp(k,i)] = modulate_for_ask_qam('ASK',alphabetabits(k),input0,SNR(n),0,1);
            out = channel(input,channel_mode,1);
            [result,~] = demodulate_for_ask_qam('ASK',alphabetabits(k),out,symbol);
            result = symbol2sequence_for_PSK(result,2^alphabetabits(k),1);
            [real_seq,sym] = viterbi(2,4,[15,17],1,0,result,alphabetabits(k));
            result = real_seq;
            wrong_rate_temp(k) = wrong_rate_temp(k)+1-sum(sample == result)/sample_length;            
        end
    end
    wrong_rate(:,n) = wrong_rate_temp/Iterates;
    p_wrong(:,n) = 1-mean(p_correct_temp,2);
    n
end
toc

subplot(1,2,1)
plot(SNR,wrong_rate(1,:),'-o');
hold on
plot(SNR,wrong_rate(2,:),'-s');
plot(SNR,wrong_rate(3,:),'-^');
plot(SNR,wrong_rate(4,:),'--o');
plot(SNR,wrong_rate(5,:),'--s');
plot(SNR,wrong_rate(6,:),'--^');
legend(['ASK-gray 1bit';'ASK-gray 2bit';'ASK-gray 3bit';'ASK-nogy 1bit';'ASK-nogy 2bit';'ASK-nogy 3bit']);
xlabel('SNR/dB')
ylabel('误比特率BER')
title('BER SNR curve')

subplot(1,2,2)
plot(SNR,wrong_rate(1,:),'-o');
hold on
plot(SNR,wrong_rate(2,:),'-s');
plot(SNR,wrong_rate(3,:),'-^');
plot(SNR,wrong_rate(4,:),'--o');
plot(SNR,wrong_rate(5,:),'--s');
plot(SNR,wrong_rate(6,:),'--^');
legend(['ASK-gray 1bit';'ASK-gray 2bit';'ASK-gray 3bit';'ASK-nogy 1bit';'ASK-nogy 2bit';'ASK-nogy 3bit']...
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