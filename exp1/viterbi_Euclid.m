function [ans]=viterbi_Euclid(L,seq1,seq2,GF2n)
    ans=0;
    if (GF2n==1)
        for i=1:L
            if (seq2(i)==0)
                ans=ans+seq1(i*2);
            else
                ans=ans+seq1(i*2-1);
            end    
        end
    elseif (GF2n==2)
        if ((seq2(1)==0)&&(seq2(2)==0))
            ans=seq1(3);
        elseif ((seq2(1)==0)&&(seq2(2)==1))
            ans=seq1(4);
        elseif ((seq2(1)==1)&&(seq2(2)==0))
            ans=seq1(2);
        else
            ans=seq1(1);
        end
    else
    end
end