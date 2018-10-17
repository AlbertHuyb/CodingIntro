function [ result ] = judge( out, num, mode, amp)
%JUDGE �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
%   result = judge( out, num, mode, p ,amp)
%       out   �յ��ĵ�ƽ
%       num   �ܵ�ƽ������������
%       mode  �о���ʽ  1:�㶨phi  2: �Ǻ㶨phi
%       amp   ��ƽ����
%       result  ��һ����Ӳ�н�����ڶ����ǵ�ƽΪA�ĸ���

if num == 2 
    if mode == 1
        criterion = amp/2;
        result = abs(out) > criterion;
        result = amp.*result;
        result = [result;abs(out)./amp];
    elseif mode == 2
        d = abs(out);
        x = linspace(0,amp,1000);
        dtheta = 2*pi/1000;
        theta = [0:dtheta:2*pi];
        result = zeros(2,length(out));
        s = 2; %sigma used to compute probability
        for k = 1:length(out)
            distance = sqrt(d(k)^2+amp^2-2*amp*d(k).*cos(theta));
            p = 1/(sqrt(2*pi)*2*pi*amp).*exp(-distance.^2./(2*s*2*pi*amp));
            p1 = sum(p)*dtheta;
            p2 = normpdf(d(k),0,s);
            if p1 >= p2
                result(1,k) = amp;
            else
                result(1,k) = 0;
            end
            result(2,k) = p1/(p1+p2);
        end
    end
else
    result = out;
end

% total_num = length(out);
% if num == 2 && mode == 1
%     middle = sum(out)/total_num;
%     point = 0.5/p*middle;
%     direction = [real(point)/imag(point),1,-abs(point)^2/imag(point)];
%     criteron = sign(direction*[0,0,1]');
%     real_part = real(out);
%     imag_part = imag(out);
%     vectors = [reshape(real_part,1,total_num);reshape(imag_part,1,total_num);repmat([1],1,total_num)]';
%     result = direction*vectors';
%     result = sign(-criteron*result);
%     result = max(result,0);
%     result = amp*result;
% else
%     result = out;
% end

end

