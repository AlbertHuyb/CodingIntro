clearvars;
close all;
clc;

SNR = -20:1:30;
len = length(SNR);
symbol1 = zeros(len,2);
symbol2 = zeros(len,4);
symbol3 = zeros(len,8);
p_correct1 = zeros(1,len);
p_correct2 = zeros(1,len);
p_correct3 = zeros(1,len);


load ('ask.mat');

tic
for n = 1:length(SNR)
    [symbol1(n,:),p_correct1(n)] = designask(1,SNR(n));
end
toc

tic
parfor n = 1:length(SNR)
    [symbol2(n,:),p_correct2(n)] = designask(2,SNR(n));
end
toc


tic
parfor n = 1:length(SNR)
    [~,symbol3(n,:),p_correct3(n)] = designask(3,SNR(n));
end
toc

save ('ask.mat');