clear all;
%% BPSK
% 绘图内容
% 硬判决和软判决
% 映射方法有8电平bPSK，8QAM1,8QAM2
% 1/2 效率卷积， 得到800个有效内容
% wrong_rate共6行，硬判决1-3，软判决4-6
bias_ratio = 0.2; 
len = 20;
SNR = [-20:2.5:30];
% SNR = 30;
random_rate = 0.5;
sample_length = 1200;
voltage_num = [8];
A = 3;
S = (bias_ratio^2+1)*A^2;
sigma_ns = sqrt(S/2./10.^(SNR/10));
wrong_rate = zeros(6,length(sigma_ns));
Iterates = 12;

for k = 1:length(voltage_num)
for n = 1:length(sigma_ns)
    for i = 1:Iterates
        sample = random('bino',1,random_rate,1,sample_length);
%       硬判决      
        channel_mode = 1;
        input = convcode(sample,[15,17],0);
        [input,sites] = modulate_for_BPSK(input,voltage_num(k),1,A,bias_ratio);
        out = channel(input,channel_mode,sigma_ns(n));
        [result,~] = judge_for_BPSK(out,voltage_num(k),bias_ratio*A,sites);
        result = symbol2sequence_for_PSK(result,voltage_num(k),1);
        [real_seq,~] = viterbi(2,4,[15,17],1,0,result,log2(voltage_num(k)));
        result = real_seq;
        wrong_rate(k,n) = wrong_rate(k,n)+1-sum(sample == result)/sample_length;
        
        if voltage_num(k)==8
            input0 = convcode(sample,[15,17],0);
            [input,sites] = modulate_for_ask_qam('8QAM1',log2(voltage_num(k)),input0,SNR(n),bias_ratio,1);
            out = channel(input,channel_mode,1);
            [result,~] = demodulate_for_ask_qam('8QAM1',log2(voltage_num(k)),out,sites);
            result = symbol2sequence_for_PSK(result,voltage_num(k),1);
            [real_seq,~] = viterbi(2,4,[15,17],1,0,result,1);
            result = real_seq;
            wrong_rate(2,n) = wrong_rate(2,n)+1-sum(sample == result)/sample_length;
            
            [input,sites] = modulate_for_ask_qam('8QAM2',log2(voltage_num(k)),input0,SNR(n),bias_ratio,1);
            out = channel(input,channel_mode,1);
            [result,~] = demodulate_for_ask_qam('8QAM2',log2(voltage_num(k)),out,sites);
            result = symbol2sequence_for_PSK(result,voltage_num(k),1);
            [real_seq,~] = viterbi(2,4,[15,17],1,0,result,1);
            result = real_seq;
            wrong_rate(3,n) = wrong_rate(3,n)+1-sum(sample == result)/sample_length;
        end
        
%         %软判决
%         sample = random('bino',1,random_rate,1,sample_length);
%                 
%         channel_mode = 1;
%         input = convcode(sample,[15,17],0);
%         [input,sites] = modulate_for_BPSK(input,voltage_num(k),1,A,bias_ratio);
%         real_input = [repmat(input(1:100),1,2),input];
%         out = channel(real_input,channel_mode,sigma_ns(n));
%         [~,prob] = judge_for_BPSK(out,voltage_num(k),bias_ratio*A,sites);
%         head_prob = (prob(:,1:100)+prob(:,101:200)+prob(:,201:300))/3;
%         real_prob = [head_prob,prob(:,301:end)];
%         data = real_prob(:);
%         [real_seq,~] = viterbi(2,4,[15,17],0,0,data,log2(voltage_num(k)));
%         result = real_seq;
%         wrong_rate(k+3,n) = wrong_rate(k+3,n)+1-sum(sample == result)/sample_length;
%         
%         if voltage_num(k)==8
%             input0 = convcode(sample,[15,17],0);
%             [input,sites] = modulate_for_ask_qam('8QAM1',log2(voltage_num(k)),input0,SNR(n),bias_ratio,1);
%             out = channel(input,channel_mode,sigma_ns(n));
%             [~,prob] = demodulate_for_ask_qam('8QAM1',log2(voltage_num),out,sites);
%             head_prob = (prob(:,1:100)+prob(:,101:200)+prob(:,201:300))/3;
%             real_prob = [head_prob,prob(:,301:end)];
%             data = real_prob(:);
%             [real_seq,~] = viterbi(2,4,[15,17],0,0,data,3);
%             result = real_seq;
%             wrong_rate(5,n) = wrong_rate(5,n)+1-sum(sample == result)/sample_length;
%             
%             [input,sites] = modulate_for_ask_qam('8QAM2',log2(voltage_num(k)),input0,SNR(n),bias_ratio,1);
%             out = channel(input,channel_mode,sigma_ns(n));
%             [~,prob] = demodulate_for_ask_qam('8QAM2',log2(voltage_num),out,sites);
%             head_prob = (prob(:,1:100)+prob(:,101:200)+prob(:,201:300))/3;
%             real_prob = [head_prob,prob(:,301:end)];
%             data = real_prob(:);
%             [real_seq,~] = viterbi(2,4,[15,17],0,0,data,3);
%             result = real_seq;
%             wrong_rate(6,n) = wrong_rate(6,n)+1-sum(sample == result)/sample_length;
%         end
    end
    wrong_rate(k,n)=wrong_rate(k,n)/Iterates;
%     wrong_rate(k+3,n)=wrong_rate(k+3,n)/Iterates;
    if voltage_num(k)==8
        wrong_rate(2,n)=wrong_rate(2,n)/Iterates;
        wrong_rate(3,n)=wrong_rate(3,n)/Iterates;
%         wrong_rate(5,n)=wrong_rate(5,n)/Iterates;
%         wrong_rate(6,n)=wrong_rate(6,n)/Iterates;
    end
    n
end
k
end

for t = 1:3
    if t <=3
        plot((SNR),wrong_rate(t,:),'-o');
    else
        plot((SNR),wrong_rate(t,:),':o');
    end
    hold on
end
set(gca,'yscale','log');
legends = ['8bPSK 硬判决';'8QAM1 硬判决';'8QAM2 硬判决'];
legend(legends,'Location','southwest')
title('800次使用信道 固定相位')