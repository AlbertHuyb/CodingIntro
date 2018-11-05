clear all;
%% BPSK
% 绘图内容
% 硬判决和软判决
% 映射方法有8电平bPSK，8QAM1,8QAM2
% 1/2 效率卷积， 得到800个有效内容，富余200，
% 对前100个重复两次，考虑到数据头中可能包含关键信息
% wrong_rate共6行，硬判决1-3，软判决4-6
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
wrong_rate = zeros(6,length(sigma_ns));
Iterates = 1;

for k = 1:length(voltage_num)
for n = 1:length(sigma_ns)
    for i = 1:Iterates
        sample = random('bino',1,random_rate,1,sample_length);
        %硬判决        
%         channel_mode = 1;
%         input = convcode(sample,[15,17],0);
%         [input,sites] = modulate_for_BPSK(input,voltage_num(k),1,A,bias_ratio);
%         real_input = [repmat(input(1:100),1,2),input];
%         out = channel(real_input,channel_mode,sigma_ns(n));
%         [result,~] = judge_for_BPSK(out,voltage_num(k),bias_ratio*A,sites);
%         result = symbol2sequence_for_PSK(result,voltage_num(k),1);
%         head_sequence1 = result(1:300);
%         head_sequence2 = result(301:600);
%         real_result = result(601:end);
%         temp = sum([head_sequence1;head_sequence2;real_result(1:300)]);
%         headseq = zeros(1,300);
%         headseq(temp>=2)=1;
%         headseq(temp<=1)=0;
%         [real_seq,~] = viterbi(2,4,[15,17],1,0,[headseq,real_result(301:end)],1);
%         result = real_seq;
%         wrong_rate(k,n) = wrong_rate(k,n)+1-sum(sample == result)/sample_length;
%         
%         if voltage_num(k)==8
%             input0 = convcode(sample,[15,17],0);
%             [input,sites] = modulate_for_ask_qam('8QAM1',log2(voltage_num(k)),input0,SNR(n),bias_ratio,1);
%             real_input = [repmat(input(1:100),1,2),input];
%             out = channel(real_input,channel_mode,sigma_ns(n));
%             [result,~] = demodulate_for_ask_qam('8QAM1',log2(voltage_num),out,sites);
%             result = symbol2sequence_for_PSK(result,voltage_num(k),1);
%             head_sequence1 = result(1:300);
%             head_sequence2 = result(301:600);
%             real_result = result(601:end);
%             temp = sum([head_sequence1;head_sequence2;real_result(1:300)]);
%             headseq = zeros(1,300);
%             headseq(temp>=2)=1;
%             headseq(temp<=1)=0;
%             [real_seq,~] = viterbi(2,4,[15,17],1,0,[headseq,real_result(301:end)],1);
%             result = real_seq;
%             wrong_rate(2,n) = wrong_rate(2,n)+1-sum(sample == result)/sample_length;
%             
%             [input,sites] = modulate_for_ask_qam('8QAM2',log2(voltage_num(k)),input0,SNR(n),bias_ratio,1);
%             real_input = [repmat(input(1:100),1,2),input];
%             out = channel(real_input,channel_mode,sigma_ns(n));
%             [result,~] = demodulate_for_ask_qam('8QAM2',log2(voltage_num),out,sites);
%             result = symbol2sequence_for_PSK(result,voltage_num(k),1);
%             head_sequence1 = result(1:300);
%             head_sequence2 = result(301:600);
%             real_result = result(601:end);
%             temp = sum([head_sequence1;head_sequence2;real_result(1:300)]);
%             headseq = zeros(1,300);
%             headseq(temp>=2)=1;
%             headseq(temp<=1)=0;
%             [real_seq,~] = viterbi(2,4,[15,17],1,0,[headseq,real_result(301:end)],1);
%             result = real_seq;
%             wrong_rate(3,n) = wrong_rate(3,n)+1-sum(sample == result)/sample_length;
%         end
        
        %软判决
        sample = random('bino',1,random_rate,1,sample_length);
                
        channel_mode = 1;
        input = convcode(sample,[15,17],0);
        [input,sites] = modulate_for_BPSK(input,voltage_num(k),1,A,bias_ratio);
        real_input = [repmat(input(1:100),1,2),input];
        out = channel(real_input,channel_mode,sigma_ns(n));
        [~,prob] = judge_for_BPSK(out,voltage_num(k),bias_ratio*A,sites);
        head_prob = (prob(:,1:100)+prob(:,101:200)+prob(:,201:300))/3;
        real_prob = [head_prob,prob(:,301:end)];
        data = real_prob(:);
        [real_seq,~] = viterbi(2,4,[15,17],0,0,data,3);
        result = real_seq;
        wrong_rate(k+3,n) = wrong_rate(k+3,n)+1-sum(sample == result)/sample_length;
        
        if voltage_num(k)==8
            input0 = convcode(sample,[15,17],0);
            [input,sites] = modulate_for_ask_qam('8QAM1',log2(voltage_num(k)),input0,SNR(n),bias_ratio,1);
            out = channel(input,channel_mode,sigma_ns(n));
            [~,prob] = demodulate_for_ask_qam('8QAM1',log2(voltage_num),out,sites);
            head_prob = (prob(:,1:100)+prob(:,101:200)+prob(:,201:300))/3;
            real_prob = [head_prob,prob(:,301:end)];
            data = real_prob(:);
            [real_seq,~] = viterbi(2,4,[15,17],0,0,data,3);
            result = real_seq;
            wrong_rate(5,n) = wrong_rate(5,n)+1-sum(sample == result)/sample_length;
            
            [input,sites] = modulate_for_ask_qam('8QAM2',log2(voltage_num(k)),input0,SNR(n),bias_ratio,1);
            out = channel(input,channel_mode,sigma_ns(n));
            [~,prob] = demodulate_for_ask_qam('8QAM2',log2(voltage_num),out,sites);
            head_prob = (prob(:,1:100)+prob(:,101:200)+prob(:,201:300))/3;
            real_prob = [head_prob,prob(:,301:end)];
            data = real_prob(:);
            [real_seq,~] = viterbi(2,4,[15,17],0,0,data,3);
            result = real_seq;
            wrong_rate(6,n) = wrong_rate(6,n)+1-sum(sample == result)/sample_length;
        end
    end
    wrong_rate(k,n)=wrong_rate(k,n)/Iterates;
    wrong_rate(k+3,n)=wrong_rate(k+3,n)/Iterates;
    if voltage_num(k)==8
        wrong_rate(2,n)=wrong_rate(2,n)/Iterates;
        wrong_rate(3,n)=wrong_rate(3,n)/Iterates;
        wrong_rate(5,n)=wrong_rate(5,n)/Iterates;
        wrong_rate(6,n)=wrong_rate(6,n)/Iterates;
    end
end
end