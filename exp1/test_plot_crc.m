clear all;
Iterates = 10;
random_rate = 0.5;
crc_len = [1,5,7,12];
voltage_num = 4;
sample_length = 10000;%9000
A = 3;
bias_ratio = 0.2;
SNR = [-20:2.5:30];
S = (bias_ratio^2+1)*A^2;
block_len = 10;
sigma_ns = sqrt(S/2./10.^(SNR/10));
wrong_rate = zeros(5,length(sigma_ns));

for k=1:length(crc_len)
    for n = 1:length(sigma_ns)
        for i = 1:Iterates
            sample = random('bino',1,random_rate,1,sample_length);
                
            channel_mode = 1;
            input1 = crc_encoder(sample,crc_len(k),block_len);
            %input1 = convcode(input1,[15,17],1);
            %input1 = convcode(input1,[13,15,17],1);
            input = modulate_for_BPSK(input1,voltage_num,1,A,bias_ratio);
            out = channel(input,channel_mode,sigma_ns(n));
            %硬判决
            result = judge_for_BPSK(out,voltage_num,bias_ratio*A);
            result = symbol2sequence_for_PSK(result,voltage_num,1);
            %得到硬判决符号序列
            
            %软判决，直接从out出发译码
            
            %译码结果存放在一行的result中
            total_blocks = length(result)/(crc_len(k)+block_len);
            result = reshape(result,crc_len(k)+block_len,total_blocks)';
            wrong_blocks = 0;
            for t = 1:total_blocks
                flag = crc_judge(result(t,:),crc_len(k));
                if ~flag
                    wrong_blocks = wrong_blocks + 1;
                end
            end
            wrong_rate(k,n) = wrong_rate(k,n)+wrong_blocks/total_blocks;
            wrong_rate(5,n) = wrong_rate(4,n)+wrong_blocks/total_blocks;
        end
        wrong_rate(k,n)=wrong_rate(k,n)/Iterates;
    end
end
wrong_rate(5,:)=wrong_rate(5,:)/length(crc_len)/Iterates;

subplot(1,2,1)
plot(SNR,wrong_rate(1,:),'--o');
hold on 
plot(SNR,wrong_rate(2,:),'--s');
plot(SNR,wrong_rate(3,:),'--^');
plot(SNR,wrong_rate(4,:),'--*');
plot(SNR,wrong_rate(5,:),'-o');
legend(['1位crc ';'5位crc ';'7位crc ';'12位crc';'0位crc ']);
xlabel('SNR/dB')
ylabel('误块率')
title('2bit映射误块率 SNR 曲线')

subplot(1,2,2)
plot(SNR,wrong_rate(1,:),'--o');
hold on 
plot(SNR,wrong_rate(2,:),'--s');
plot(SNR,wrong_rate(3,:),'--^');
plot(SNR,wrong_rate(4,:),'--*');
plot(SNR,wrong_rate(5,:),'-o');
legend(['1位crc ';'5位crc ';'7位crc ';'12位crc';'0位crc '],'Location','southwest');
set(gca,'yscale','log')
xlabel('SNR/dB')
ylabel('误块率')
title('2bit映射误块率 SNR 对数坐标曲线')