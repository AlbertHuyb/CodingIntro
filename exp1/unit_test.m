clear all;
a = round(rand(1,500));
length(a)
c = convcode(a,[15,17],1);
length(c)
b = viterbi(2,4,[15,17],1,1,c,4);
length(b)
b = viterbi(2,4,[15,17],1,1,c,2);
length(b)
b = viterbi(2,4,[15,17],1,1,c,1);
length(b)