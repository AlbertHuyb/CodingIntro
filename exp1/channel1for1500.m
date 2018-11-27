clear all;
%% BPSK
% 绘图内容
% 硬判决和软判决
% 映射方法有8电平bPSK，8QAM1,8QAM2
% 1/2 效率卷积， 得到800个有效内容，富余200，
% 对前150个重复两次，考虑到数据头中可能包含关键信息
% wrong_rate共6行，硬判决1-3，软判决4-6
bias_ratio = 0.2; 
len = 20;
SNR = [-20:2.5:30];
% SNR = 30;
random_rate = 0.5;
sample_length = 1200;
voltage_num = [2];
head_length = 150;
A = 3;
S = (bias_ratio^2+1)*A^2;
sigma_ns = sqrt(S/2./10.^(SNR/10));
wrong_rate = zeros(9,length(sigma_ns));
Iterates = 5;

for k = 1:length(voltage_num)
for n = 1:length(sigma_ns)
    for i = 1:Iterates
        sample = random('bino',1,random_rate,1,sample_length);
%       硬判决       
        channel_mode = 1;
        if voltage_num(k)==4
            input = convcode(sample,[15,17],0);
        elseif voltage_num(k)==8
            input = convcode(sample,[13,15,17],0);
        elseif voltage_num(k)==2
            input = sample;
        end
        [input,sites] = modulate_for_BPSK(input,voltage_num(k),1,A,bias_ratio);
        real_input = [repmat(input(1:head_length),1,2),input];
        out = channel(real_input,channel_mode,sigma_ns(n));
        [result,~] = judge_for_BPSK(out,voltage_num(k),bias_ratio*A,sites);
        result = symbol2sequence_for_PSK(result,voltage_num(k),1);
        head_sequence1 = result(1:log2(voltage_num(k))*head_length);
        head_sequence2 = result(log2(voltage_num(k))*head_length+1:2*log2(voltage_num(k))*head_length);
        real_result = result(2*log2(voltage_num(k))*head_length+1:end);
        temp = sum([head_sequence1;head_sequence2;real_result(1:log2(voltage_num(k))*head_length)]);
        headseq = zeros(1,log2(voltage_num(k))*head_length);
        headseq(temp>=2)=1;
        headseq(temp<=1)=0;
        if voltage_num(k)==4
            [real_seq,sym] = viterbi(2,4,[15,17],1,0,[headseq,real_result(log2(voltage_num(k))*head_length+1:end)],log2(voltage_num(k)));
        elseif voltage_num(k)==8
            [real_seq,sym] = viterbi(3,4,[13,15,17],1,0,[headseq,real_result(log2(voltage_num(k))*head_length+1:end)],log2(voltage_num(k)));
        elseif voltage_num(k)==2
            real_seq = [headseq,real_result(log2(voltage_num(k))*head_length+1:end)];
        end
        result = real_seq;
        wrong_rate(k,n) = wrong_rate(k,n)+1-sum(sample == result)/sample_length;
        
        if voltage_num(k)==8
            input0 = convcode(sample,[13,15,17],0);
            [input,sites] = modulate_for_ask_qam('8QAM1',log2(voltage_num(k)),input0,SNR(n),bias_ratio,1);
            real_input = [repmat(input(1:head_length),1,2),input];
            out = channel(real_input,channel_mode,1);
            [result,~] = demodulate_for_ask_qam('8QAM1',log2(voltage_num(k)),out,sites);
            result = symbol2sequence_for_PSK(result,voltage_num(k),1);
            head_sequence1 = result(1:log2(voltage_num(k))*head_length);
            head_sequence2 = result(log2(voltage_num(k))*head_length+1:2*log2(voltage_num(k))*head_length);
            real_result = result(2*log2(voltage_num(k))*head_length+1:end);
            temp = sum([head_sequence1;head_sequence2;real_result(1:log2(voltage_num(k))*head_length)]);
            headseq = zeros(1,log2(voltage_num(k))*head_length);
            headseq(temp>=2)=1;
            headseq(temp<=1)=0;
            [real_seq,~] = viterbi(3,4,[13,15,17],1,0,[headseq,real_result(log2(voltage_num(k))*head_length+1:end)],1);
            result = real_seq;
            wrong_rate(4,n) = wrong_rate(4,n)+1-sum(sample == result)/sample_length;
            
            [input,sites] = modulate_for_ask_qam('8QAM2',log2(voltage_num(k)),input0,SNR(n),bias_ratio,1);
            real_input = [repmat(input(1:head_length),1,2),input];
            out = channel(real_input,channel_mode,1);
            [result,~] = demodulate_for_ask_qam('8QAM2',log2(voltage_num(k)),out,sites);
            result = symbol2sequence_for_PSK(result,voltage_num(k),1);
            head_sequence1 = result(1:log2(voltage_num(k))*head_length);
            head_sequence2 = result(log2(voltage_num(k))*head_length+1:2*log2(voltage_num(k))*head_length);
            real_result = result(2*log2(voltage_num(k))*head_length+1:end);
            temp = sum([head_sequence1;head_sequence2;real_result(1:log2(voltage_num(k))*head_length)]);
            headseq = zeros(1,log2(voltage_num(k))*head_length);
            headseq(temp>=2)=1;
            headseq(temp<=1)=0;
            [real_seq,~] = viterbi(3,4,[13,15,17],1,0,[headseq,real_result(log2(voltage_num(k))*head_length+1:end)],1);
            result = real_seq;
            wrong_rate(5,n) = wrong_rate(5,n)+1-sum(sample == result)/sample_length;
        end
        
        %软判决
        sample = random('bino',1,random_rate,1,sample_length);
                
        channel_mode = 1;
        if voltage_num(k)==4
            input = convcode(sample,[15,17],0);
        elseif voltage_num(k)==8
            input = convcode(sample,[13,15,17],0);
        elseif voltage_num(k)==2
            continue
        end
        [input,sites] = modulate_for_BPSK(input,voltage_num(k),1,A,bias_ratio);
        real_input = [repmat(input(1:head_length),1,2),input];
        out = channel(real_input,channel_mode,sigma_ns(n));
        [~,prob] = judge_for_BPSK(out,voltage_num(k),bias_ratio*A,sites);
        head_prob = (prob(:,1:head_length)+prob(:,head_length+1:2*head_length)...
            +prob(:,2*head_length+1:3*head_length))/3;
        real_prob = [head_prob,prob(:,3*head_length+1:end)];
        data = real_prob(:);
        if voltage_num(k)==4
            [real_seq,sym] = viterbi(2,4,[15,17],0,0,data,log2(voltage_num(k)));
        elseif voltage_num(k)==8
            [real_seq,sym] = viterbi(3,4,[13,15,17],0,0,data,log2(voltage_num(k)));
        end
        result = real_seq;
        wrong_rate(k+5,n) = wrong_rate(k+5,n)+1-sum(sample == result)/sample_length;
        
        if voltage_num(k)==8
            input0 = convcode(sample,[13,15,17],0);
            [input,sites] = modulate_for_ask_qam('8QAM1',log2(voltage_num(k)),input0,SNR(n),bias_ratio,1);
            real_input = [repmat(input(1:head_length),1,2),input];
            out = channel(real_input,channel_mode,sigma_ns(n));
            [~,prob] = demodulate_for_ask_qam('8QAM1',log2(voltage_num(k)),out,sites);
            head_prob = (prob(:,1:head_length)+prob(:,head_length+1:2*head_length)...
                +prob(:,2*head_length+1:3*head_length))/3;
            real_prob = [head_prob,prob(:,3*head_length+1:end)];
            data = real_prob(:);
            [real_seq,~] = viterbi(3,4,[13,15,17],0,0,data,3);
            result = real_seq;
            wrong_rate(8,n) = wrong_rate(8,n)+1-sum(sample == result)/sample_length;
            
            [input,sites] = modulate_for_ask_qam('8QAM2',log2(voltage_num(k)),input0,SNR(n),bias_ratio,1);
            real_input = [repmat(input(1:head_length),1,2),input];
            out = channel(real_input,channel_mode,sigma_ns(n));
            [~,prob] = demodulate_for_ask_qam('8QAM2',log2(voltage_num(k)),out,sites);
            head_prob = (prob(:,1:head_length)+prob(:,head_length+1:2*head_length)...
                +prob(:,2*head_length+1:3*head_length))/3;
            real_prob = [head_prob,prob(:,3*head_length+1:end)];
            data = real_prob(:);
            [real_seq,~] = viterbi(3,4,[13,15,17],0,0,data,3);
            result = real_seq;
            wrong_rate(9,n) = wrong_rate(9,n)+1-sum(sample == result)/sample_length;
        end
    end
    wrong_rate(k,n)=wrong_rate(k,n)/Iterates;
    wrong_rate(k+4,n)=wrong_rate(k+4,n)/Iterates;
    if voltage_num(k)==8
        wrong_rate(4,n)=wrong_rate(4,n)/Iterates;
        wrong_rate(5,n)=wrong_rate(5,n)/Iterates;
        wrong_rate(8,n)=wrong_rate(8,n)/Iterates;
        wrong_rate(9,n)=wrong_rate(9,n)/Iterates;
    end
    n
end
k
end

for t = 1:9
    if t <=5
        plot((SNR),wrong_rate(t,:),'-o');
    else
        plot((SNR),wrong_rate(t,:),':o');
    end
    hold on
end
set(gca,'yscale','log');
legend(['2bPSK 直接传';'4bPSK 硬判决';'8bPSK 硬判决';'8QAM1 硬判决';'8QAM2 硬判决';...
    '4bPSK 软判决';'8bPSK 软判决';'8QAM1 软判决';'8QAM2 软判决'],...
    'Location','southwest')