clear all;
lena = imread('lena_128_bw.bmp');
% imshow(lena)
lena_value = lena(:);
raw_dict = tabulate(lena_value);
raw_dict(:,3)=raw_dict(:,3)/100;
appear_num = raw_dict(:,2);
appear_index = appear_num~=0;
dict = raw_dict(appear_index,:);
[dict,~] = huffmandict(dict(:,1),dict(:,3));

lena_encoded = huffmanenco(lena_value,dict);
lena_decoded = huffmandeco(lena_encoded,dict);
lena_recons = reshape(lena_decoded,size(lena));
isequal(lena,lena_recons)

fileID = fopen('table.txt','w');
dict(:,2) = strrep(cellfun(@num2str,dict(:,2), 'UniformOutput',false),' ','' );
dict(:,1) = cellfun(@num2str,dict(:,1), 'UniformOutput',false);
out = strcat(dict(:,1),repmat({' '},length(dict(:,1)),1),dict(:,2));
fprintf(fileID,'%s\r\n',out{:});
fclose(fileID);

if block_length == 1
    temp = mat2cell(img_value,repmat(1,1,length(img_value)));
    temp = strrep(temp,' ','');
elseif block_length == 2
    temp1 = mat2cell(img_value(:,1),repmat(1,1,length(img_value(:,1))));
    temp2 = mat2cell(img_value(:,2),repmat(1,1,length(img_value(:,2))));
    temp1 = cellfun(@num2str,temp1, 'UniformOutput',false);
    temp2 = cellfun(@num2str,temp2, 'UniformOutput',false);
    temp1 = strrep(temp1,' ','');
    temp2 = strrep(temp2,' ','');
    temp = strcat(temp1,repmat({' '},length(temp1),1),temp2);
else
    error('block_length should be 1 or 2!')
end