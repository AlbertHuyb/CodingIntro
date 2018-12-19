function [ dict ] = get_huffman_dict( img ,block_length)
%HUFFMAN_ENCODER 此处显示有关此函数的摘要
%   此处显示详细说明
img_value = reshape(img',block_length,floor(size(img,1)*size(img,2)/block_length))';
% img_value = num2str(img_value);
if block_length == 1
    temp = num2str(img_value);
    temp = mat2cell(temp,repmat(1,1,length(img_value)));
    temp = strrep(temp,' ','');
elseif block_length == 2
    temp1 = num2str(img_value(:,1));
    temp2 = num2str(img_value(:,2));
    temp1 = mat2cell(temp1,repmat(1,1,length(img_value(:,1))));
    temp2 = mat2cell(temp2,repmat(1,1,length(img_value(:,2))));
    temp1 = strrep(temp1,' ','');
    temp2 = strrep(temp2,' ','');
    temp = strcat(temp1,repmat({' '},length(temp1),1),temp2);
else
    error('block_length should be 1 or 2!')
end
% img(:);
raw_dict = tabulate(temp);
temp = cell2mat(raw_dict(:,3))/100;
raw_dict(:,3) = mat2cell(temp,repmat([1],1,length(temp)));
% raw_dict(:,3)=cellfun(@div,raw_dict(:,3),repmat({100},length(raw_dict(:,3)),1));
% raw_dict(:,3)/100;
appear_num = cell2mat(raw_dict(:,2));
appear_index = appear_num~=0;
dict = raw_dict(appear_index,:);
[dict,~] = huffmandict(dict(:,1),cell2mat(dict(:,3)));
end

