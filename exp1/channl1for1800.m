clear all;
%% BPSK
% 绘图内容
% 硬判决和软判决
% 映射方法有4电平bPSK
% 1/2 效率卷积， 得到1800个有效内容
% wrong_rate共2行，硬判决1，软判决2
bias_ratio = 0.2; 
len = 20;
SNR = [-20:2.5:30];
% SNR = 30;
random_rate = 0.5;
sample_length = 1200;
voltage_num = [4];
A = 3;
S = (bias_ratio^2+1)*A^2;
sigma_ns = sqrt(S/2./10.^(SNR/10));
wrong_rate = zeros(2,length(sigma_ns));
Iterates = 12;

for k = 1:length(voltage_num)
for n = 1:length(sigma_ns)
    for i = 1:Iterates
        sample = random('bino',1,random_rate,1,sample_length);
%       硬判决      
        channel_mode = 1;
        input = convcode(sample,[13,15,17],0);
        [input,sites] = modulate_for_BPSK(input,voltage_num(k),1,A,bias_ratio);
        out = channel(input,channel_mode,sigma_ns(n));
        [result,~] = judge_for_BPSK(out,voltage_num(k),bias_ratio*A,sites);
        result = symbol2sequence_for_PSK(result,voltage_num(k),1);
        [real_seq,~] = viterbi(3,4,[13,15,17],1,0,result,log2(voltage_num(k)));
        result = real_seq;
        wrong_rate(k,n) = wrong_rate(k,n)+1-sum(sample == result)/sample_length;
        
        
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
%         wrong_rate(k+1,n) = wrong_rate(k+1,n)+1-sum(sample == result)/sample_length;
%         
%        
    wrong_rate(k,n)=wrong_rate(k,n)/Iterates;
%     wrong_rate(k+1,n)=wrong_rate(k+1,n)/Iterates;
    end
    n
end
k
end

for t = 1:2
    if t <=1
        plot((SNR),wrong_rate(t,:),'-o');
    else
        plot((SNR),wrong_rate(t,:),':o');
    end
    hold on
end
set(gca,'yscale','log');
legends = ['4bPSK 硬判决'];
legend(legends,'Location','southwest')
title('1800次使用信道 固定相位')