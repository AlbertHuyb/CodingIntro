clear all;
A = 3; %amplify
sigma_ns = [0:0.01:1];
random_rate = 0.5;
sample_length = 5000;
voltage_num = 2;
wrong_rate = zeros(2,length(sigma_ns));
Iterates = 10;

for n = 1:length(sigma_ns)
    for i = 1:Iterates
        sample = random('bino',1,random_rate,1,sample_length);
        input = A*sample;
        channel_mode = 1;
        out = channel(input,channel_mode,sigma_ns(n));
        result = judge(out,voltage_num,channel_mode,A);
        wrong_rate(1,n) = wrong_rate(1,n)+1-sum(input == result(1,:))/length(out);
    
        channel_mode = 2;
        out = channel(input,channel_mode,sigma_ns(n));
        result = judge(out,voltage_num,channel_mode,A);
        wrong_rate(2,n) = wrong_rate(2,n)+1-sum(input == result(1,:))/length(out);
    end
    wrong_rate(1,n)=wrong_rate(1,n)/Iterates;
    wrong_rate(2,n)=wrong_rate(2,n)/Iterates;
end

figure
SNR = 10*log10(0.5*A^2./(2*sigma_ns.^2));
plot(20*log10(SNR),wrong_rate(1,:));
hold on
plot(20*log10(SNR),wrong_rate(2,:));
set(gca,'yscale','log')
xlabel('复电平信噪比/dB')
ylabel('误比特率')

figure
plot(input,repmat(0,1,length(sample)),'o')
axis([-A A -A A])
axis equal
grid on
title('发端星座图')

figure
channel_mode = 1;
out = channel(input,channel_mode,sigma_ns(3));
plot(real(out),imag(out),'o')
axis equal
title('第一类信道收端星座图')

figure
channel_mode = 2;
out = channel(input,channel_mode,sigma_ns(3));
plot(real(out),imag(out),'o')
axis equal
title('第二类信道收端星座图')