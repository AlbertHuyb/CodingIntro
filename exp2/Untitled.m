clear all;
a = random('bino',1,0.5,1,2048);
b = safe_encoder(a,generate_key('SCODE'));
bb = b;
bb(20:20)=~bb(20:20);
c = safe_decoder(b,generate_key('SCODE'));
cc = safe_decoder(bb,generate_key('SCODE'));
sum(a==cc)
plot(b(1:100)~=bb(1:100))
figure
plot(cc(1:100)~=a(1:100))