function [ans]=viterbi_Hamming(L,seq1,seq2)
    ans=0;
    for i=1:L
        if (seq1(i)~=seq2(i))
            ans=ans+1;
        end
    end
end