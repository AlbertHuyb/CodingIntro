function [ans]=viterbi_Euclid(L,seq1,seq2)
    ans=0;
    for i=1:L
        if (seq2(i)==0)
            ans=ans+seq1(i*2);
        else
            ans=ans+seq1(i*2-1);
        end
    end
end