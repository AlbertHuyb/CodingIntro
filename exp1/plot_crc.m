clear all;
Iterates = 10;
random_rate = 0.5;
crc_len = [5];
voltage_num = [4,8];
sample_length = [1000,1000,900];%9000
A = 3;
bias_ratio = 0.2;
%SNR = [-20:2.5:30];
SNR=30;
S = (bias_ratio^2+1)*A^2;
block_len = 10;
sigma_ns = sqrt(S/2./10.^(SNR/10));
wrong_rate = zeros(4,length(sigma_ns));

for k=1:length(voltage_num)
    for n = 1:length(sigma_ns)
        for i = 1:Iterates
            sample = random('bino',1,random_rate,1,sample_length(k));
                
            channel_mode = 1;
            input1 = crc_encoder(sample,crc_len,block_len);
            %tmp=input1;
            input1 = convcode(input1,[15,17],1);
            %input1 = convcode(input1,[13,15,17],1);
            [input,sites] = modulate_for_BPSK(input1,voltage_num(k),1,A,bias_ratio);
            %out = input;
            out = channel(input,channel_mode,sigma_ns(n));
            %硬判决
            [result,prob] = judge_for_BPSK(out,voltage_num(k),bias_ratio*A,sites);
            result = symbol2sequence_for_PSK(result,voltage_num(k),1);
            data = prob(:);
            [seq,sym] = viterbi(2,4,[15,17],1,1,result,log2(voltage_num(k)));
            result = seq(1:end-4);
            %得到硬判决符号序列
            
            %软判决，直接从out出发译码
            
            %译码结果存放在一行的result中
            total_blocks = length(result)/(crc_len+block_len);
            result = reshape(result,crc_len+block_len,total_blocks)';
            wrong_blocks = 0;
            for t = 1:total_blocks
                flag = crc_judge(result(t,:),crc_len);
                if ~flag
                    wrong_blocks = wrong_blocks + 1;
                end
            end
            wrong_rate(k,n) = wrong_rate(k,n)+wrong_blocks/total_blocks;
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
ylabel('误块率')
title('误块率 SNR 曲线')

subplot(1,2,2)
plot(SNR,wrong_rate(1,:),'-o');
hold on 
plot(SNR,wrong_rate(2,:),'-s');
plot(SNR,wrong_rate(3,:),'-^');
legend(['1bit';'2bit';'3bit'],'Location','southwest');
set(gca,'yscale','log')
xlabel('SNR/dB')
ylabel('误块率')
title('误块率 SNR 对数坐标曲线')