function [ ] = generate_table( inputdir, type, index, outdir ,block_length)
%GENERATE_TABLE 此处显示有关此函数的摘要
%   此处显示详细说明

quant_gap = index;
% img_name = strcat(repmat({inputdir},length(quant_gap),1),...
%     repmat({type},length(quant_gap),1) , ...
%     repmat({'_'},length(quant_gap),1) , ...
%     strrep(num2str(quant_gap'),' ',''), ...
%     repmat({'.bmp'},length(quant_gap),1));

for n = 1:length(quant_gap)
    img_name = [inputdir,type,'_',num2str(quant_gap(n)),'.bmp'];
    img = imread(img_name);
    code_dict = get_huffman_dict(img,block_length);
    table_name = [outdir,type,'_',num2str(quant_gap(n)),'_',num2str(block_length),'_table.txt'];
    [~,max_length_idx] = max(length(code_dict(:,2)));
    temp = code_dict{max_length_idx,2};
    out_code = [temp,1-temp(end)];
    temp = [temp,temp(end)];
    code_dict{max_length_idx,2} = temp; 
    write_code_table(table_name,code_dict,out_code);
end


end

