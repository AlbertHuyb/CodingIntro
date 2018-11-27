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
        if ((seq2(1)==0)&&(seq2(2)==0)&&(seq2(3)==0))
            ans=seq1(5);
        elseif ((seq2(1)==0)&&(seq2(2)==0)&&(seq2(3)==1))
            ans=seq1(6);
        elseif ((seq2(1)==0)&&(seq2(2)==1)&&(seq2(3)==0))
            ans=seq1(8);
        elseif ((seq2(1)==0)&&(seq2(2)==1)&&(seq2(3)==1))
            ans=seq1(7);
        elseif ((seq2(1)==1)&&(seq2(2)==0)&&(seq2(3)==0))
            ans=seq1(3);
        elseif ((seq2(1)==1)&&(seq2(2)==0)&&(seq2(3)==1))
            ans=seq1(4);
        elseif ((seq2(1)==1)&&(seq2(2)==1)&&(seq2(3)==0))
            ans=seq1(2);
        else
            ans=seq1(1);
        end
    end
end