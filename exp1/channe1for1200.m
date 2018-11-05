clear all;
%% BPSK
% 绘图内容
% 硬判决和软判决
% 映射方法有4电平bPSK，8电平bPSK，8QAM1,8QAM2
% wrong_rate共8行，硬判决1-4，软判决5-8
bias_ratio = 0.2; 
len = 20;
% SNR = [-20:2.5:30];
SNR = 30;
random_rate = 0.5;
sample_length = 1200;
voltage_num = [8];
A = 3;
S = (bias_ratio^2+1)*A^2;
sigma_ns = sqrt(S/2./10.^(SNR/10));
wrong_rate = zeros(8,length(sigma_ns));
Iterates = 1;

for k = 1:length(voltage_num)
for n = 1:length(sigma_ns)
    for i = 1:Iterates
        sample = random('bino',1,random_rate,1,sample_length);
        %硬判决        
        channel_mode = 1;
        if voltage_num(k)==4
            input = convcode(sample,[15,17],0);
        elseif voltage_num(k)==8
            input = convcode(sample,[13,15,17],0);
        end
        [input,sites] = modulate_for_BPSK(input,voltage_num(k),1,A,bias_ratio);
        out = channel(input,channel_mode,sigma_ns(n));
        [result,~] = judge_for_BPSK(out,voltage_num(k),bias_ratio*A,sites);
        result = symbol2sequence_for_PSK(result,voltage_num(k),1);
        if voltage_num(k)==4
            [seq,sym] = viterbi(2,4,[15,17],1,0,result,1);
        elseif voltage_num(k)==8
            [seq,sym] = viterbi(3,4,[13,15,17],1,0,result,1);
        end
        result = seq;
        wrong_rate(k,n) = wrong_rate(k,n)+1-sum(sample == result)/sample_length;
        
        if voltage_num(k)==8
            input0 = convcode(sample,[13,15,17],0);
            [input,sites] = modulate_for_ask_qam('8QAM1',log2(voltage_num(k)),input0,SNR(n),bias_ratio,1);
            out = channel(input,channel_mode,sigma_ns(n));
            [result,~] = demodulate_for_ask_qam('8QAM1',log2(voltage_num),out,sites);
            result = symbol2sequence_for_PSK(result,voltage_num(k),1);
            [seq,sym] = viterbi(3,4,[13,15,17],1,0,result,1);
            result = seq;
            wrong_rate(3,n) = wrong_rate(3,n)+1-sum(sample == result)/sample_length;
            
            [input,sites] = modulate_for_ask_qam('8QAM2',log2(voltage_num(k)),input0,SNR(n),bias_ratio,1);
            out = channel(input,channel_mode,sigma_ns(n));
            [result,~] = demodulate_for_ask_qam('8QAM2',log2(voltage_num),out,sites);
            result = symbol2sequence_for_PSK(result,voltage_num(k),1);
            [seq,sym] = viterbi(3,4,[13,15,17],1,0,result,1);
            result = seq;
            wrong_rate(4,n) = wrong_rate(4,n)+1-sum(sample == result)/sample_length;
        end
        
        %软判决
        sample = random('bino',1,random_rate,1,sample_length);
                
        channel_mode = 1;
        if voltage_num(k)==4
            input = convcode(sample,[15,17],0);
        elseif voltage_num(k)==8
            input = convcode(sample,[13,15,17],0);
        end
        [input,sites] = modulate_for_BPSK(input,voltage_num(k),1,A,bias_ratio);
        out = channel(input,channel_mode,sigma_ns(n));
        [~,prob] = judge_for_BPSK(out,voltage_num(k),bias_ratio*A,sites);
        data = prob(:);
        if voltage_num(k)==4
            [seq,sym] = viterbi(2,4,[15,17],0,0,data,1);
        elseif voltage_num(k)==8
            [seq,sym] = viterbi(3,4,[13,15,17],0,0,data,1);
        end
        result = seq;
        wrong_rate(k+4,n) = wrong_rate(k+4,n)+1-sum(sample == result)/sample_length;
        
        if voltage_num(k)==8
            input0 = convcode(sample,[13,15,17],0);
            [input,sites] = modulate_for_ask_qam('8QAM1',log2(voltage_num(k)),input0,SNR(n),bias_ratio,1);
            out = channel(input,channel_mode,sigma_ns(n));
            [~,prob] = demodulate_for_ask_qam('8QAM1',log2(voltage_num),out,sites);
            data = prob(:);
            [seq,sym] = viterbi(3,4,[13,15,17],0,0,data,1);
            result = seq;
            wrong_rate(7,n) = wrong_rate(7,n)+1-sum(sample == result)/sample_length;
            
            [input,sites] = modulate_for_ask_qam('8QAM2',log2(voltage_num(k)),input0,SNR(n),bias_ratio,1);
            out = channel(input,channel_mode,sigma_ns(n));
            [~,prob] = demodulate_for_ask_qam('8QAM2',log2(voltage_num),out,sites);
            data = prob(:);
            [seq,sym] = viterbi(3,4,[13,15,17],1,0,data,1);
            result = seq;
            wrong_rate(8,n) = wrong_rate(8,n)+1-sum(sample == result)/sample_length;
        end
    end
    wrong_rate(k,n)=wrong_rate(k,n)/Iterates;
    wrong_rate(k+4,n)=wrong_rate(k+4,n)/Iterates;
    if voltage_num(k)==8
        wrong_rate(3,n)=wrong_rate(3,n)/Iterates;
        wrong_rate(4,n)=wrong_rate(4,n)/Iterates;
        wrong_rate(7,n)=wrong_rate(7,n)/Iterates;
        wrong_rate(8,n)=wrong_rate(8,n)/Iterates;
    end
end
end