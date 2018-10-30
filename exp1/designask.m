function [ symbol, judgethreshold, pcorrect ] = designask(alphabetabits, SNR)
%   function [ symbol pcorrect ]=designask( alphabetabits ,SNR )
%   symbol, pcorrect:  arg max P(correct)
%   judgethreshold: judgethreshold of amplitude, first element is zero
%   alphabetbits:   number of bits containing in an alphabet
%   SNR: average, sigma=1;

alphabetalen = 2^alphabetabits;
aver_power = 10^(SNR/10);

if alphabetabits==1
    symbol=[0,sqrt(aver_power)*2];
    [ judgethreshold, ~ ] = threshold( symbol );
    pcorrect = 1-10^(-6)*pcorr(symbol);
else
    %   init_solution
    symbol0 = (1:alphabetalen)-1;
    symbol0 = sqrt(aver_power/(symbol0*symbol0'/length(symbol0))).*symbol0;
    pcbaseline = 1-10^(-6)*pcorr(symbol0);
    
    %   constraint
    lowerbound = zeros(1,alphabetalen);
    upperbound = sqrt(alphabetalen*aver_power./(alphabetalen:-1:1));
    upperbound(1)=0;
    Aeq = [-eye(alphabetalen-1) zeros(alphabetalen-1,1)] + [zeros(alphabetalen-1,1) eye(alphabetalen-1)];
    beq = ones(alphabetalen-1,1)*symbol0(alphabetalen)*0.1;
    nonlcon = @(symbol)nonlcyccon(symbol,aver_power*alphabetalen);
    
    %   optimization
    options = optimoptions('fmincon','Display','off','Algorithm','sqp','MaxFunctionEvaluations',ceil(pcorr(symbol0)+4000));
    [symbol] = fmincon(@pcorr,symbol0,[],[],Aeq,beq,lowerbound,upperbound,nonlcon,options);
    % [symbol, ~, ~, ~, ~, ~, ~] = fmincon(@pcorr,symbol,[],[],Aeq,beq,lowerbound,upperbound,nonlcon,options);
    
    %   regularization
    symbol = sqrt(aver_power/(symbol*symbol'/length(symbol))).*symbol;
    [judgethreshold, ~] = threshold(symbol);
    pcorrect = 1-10^(-6)*pcorr(symbol);
    %   baseline
    if pcorrect < pcbaseline
        symbol = symbol0;
        [judgethreshold, ~] = threshold(symbol);
        pcorrect = 1-10^(-6)*pcorr(symbol);
    end
end
end

function [ threshold, pcorrecti ] = threshold( symbol )
%   function [ threshold, pcorrect ] = threshold( symbol )
%   find threshould by solving transcendental equation
len = length(symbol);
threshold = zeros(1,len);
pcorrecti = zeros(1,len);
threshold(1) = 0;
syms x;
for i = 2:len
    eqn = besseli(0,symbol(i-1)*x)==besseli(0,symbol(i)*x)*exp((symbol(i-1)^2-symbol(i)^2)/2);
    threshold(i) = vpasolve(eqn,x,[0 Inf]);
    pcorrecti(i-1) = marcumq(symbol(i-1),threshold(i-1))-marcumq(symbol(i-1),threshold(i));
end
pcorrecti(len) = marcumq(symbol(len),threshold(len));
end


function pcorrect = pcorr(symbol)
[ ~, pcorrecti ] = threshold(symbol);
pcorrect = 10^6*(1-mean(pcorrecti));
end


function [c, ceq] = nonlcyccon(symbol,radiussqure)
%   S^n non-line-con
c = [];
ceq = symbol*symbol' - radiussqure;
end