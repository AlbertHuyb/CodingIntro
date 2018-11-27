function [ out ] = wave_channel( wave,noise_density, sample_rate)
%WAVE_CHANNEL 此处显示有关此函数的摘要
%   此处显示详细说明
noise_power = noise_density/2*sample_rate;
fake_SNR = -10*log10(noise_power);
out = awgn(wave,fake_SNR);
% 10*log10(sum(wave*wave')/sum((out-wave)*(out-wave)'))

end

