function [  ] = write_code_table( table_name,dict,out_code)
%WRITE_CODE_TABLE �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
fileID = fopen(table_name,'w');
dict(:,2) = strrep(cellfun(@num2str,dict(:,2), 'UniformOutput',false),' ','' );
dict(:,1) = cellfun(@num2str,dict(:,1), 'UniformOutput',false);
out = strcat(dict(:,1),repmat({' '},length(dict(:,1)),1),dict(:,2));
fprintf(fileID,'%s\r\n',out{:});
fprintf(fileID,'%s\n',strrep(num2str(out_code),' ',''));
fclose(fileID);

end

