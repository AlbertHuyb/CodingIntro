function [ output ] = safe_encoder( input,key )
%SAFE_ENCODER 此处显示有关此函数的摘要
%   此处显示详细说明
input = double(input);
output = zeros(1,length(input));
key = double(key);
key_move = key;
for i = 1:size(key_move,1)
    key_move(i,:)=circshift(key_move(i,:)',5-i+1)';
end
key
key_move
block_size = [32,64];
block_length = block_size(1)*block_size(2);
block_num = floor(length(input)/block_length);
front = input(1:block_length*block_num);
tail = input(block_length*block_num+1:end);
if length(tail)>0
    tail = [tail,zeros(1,block_length-length(tail))];
    input_data = [front,tail];
    block_num = block_num + 1;
else
    input_data = front;
end
Iterations = 1;
for n = 0:block_num-1
    data = input_data(n*block_length+1:(n+1)*block_length);
    data_mat = reshape(data,block_size);
    for t=1:Iterations
        left_part = data_mat(:,1:block_size(2)/2);
        right_part = data_mat(:,block_size(2)/2+1:end);
        right_part_move = right_part;
        for i = 1:size(right_part_move,1)
            right_part_move(i,:)=circshift(right_part_move(i,:)',i-1)';
        end
        right_result1 = conv2(right_part,key);
        right_result1 = right_result1(ceil(size(key,1)/2):end-floor(size(key,1)/2),...
            ceil(size(key,2)/2):end-floor(size(key,2)/2));
        right_result2 = conv2(right_part_move,key_move);
        right_result2 = right_result2(ceil(size(key,1)/2):end-floor(size(key,1)/2),...
            ceil(size(key,2)/2):end-floor(size(key,2)/2));
        right_result = right_result1+right_result2;
        right_result = right_result + left_part;
        right_result = mod(right_result,2);
        left_result = right_part;
        data_mat = [left_result,right_result];
    end
    block_output = data_mat';
    block_output = block_output(:);
    output(n*block_length+1:(n+1)*block_length) = block_output;
end

end

