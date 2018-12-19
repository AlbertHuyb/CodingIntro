clear all;
type = {'uniform','H261','middle','edge'};
gaps = {[10,28,45,60],[1,2,5,10],[13,7,4],[13,4,7]};

input_dir = '../../《编码引论》第三次大作业/report/';
output_dir = './report/';

block_length = 2;

for n = 1:length(type)
    generate_table(input_dir,type{n},gaps{n},output_dir,block_length);
end
    