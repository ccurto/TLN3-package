function [W,class_str,k,idx123,lambda_max] = get_TLN3(chir_str,lambda_flag)

% function [W,class_str,k,idx123,lambda_max] = get_TLN3(chir_str,lambda_flag)
%
% chir_str = 'P1',..,'P14','M1',...,'M12' - string indicating chir class
% lambda_flag = 0 (default), but set to 1 to require lambda_max > 0
%   -> this is only used if chir_str is one of P6-P10
%
% W = 3x3 TLN matrix
% class_str = chir_str, just returning it for completeness of output
% k = chirotope table number out of 512 possible tables
% idx123 = idx(123) (+1 for P classes, -1 for M classes)
% lambda_max = maximal real part of eigenvalues of -I+W
%   -> if lambda_max > 0, any 123 fixed point is unstable
%
% created by Carina on Dec 5, 2024

% note this flag is only used for P6-P10
if nargin<2 || isempty(lambda_flag)
    lambda_flag = 0;
end

% use P5 as the default chir_str if none provided
if nargin<1 || isempty(chir_str)
    chir_str = 'P5';
end

all_chir_strs = {'P1','P2','P3','P4','P5','P6','P7','P8','P9','P10',...
        'P11','P12','P13','P14','M1','M2','M3','M4','M5','M6','M7',...
        'M8','M9','M10','M11','M12'};

% return an error of chir_str is not legit
if ~ismember(chir_str,all_chir_strs)
    error('Need to pass a valid chir_str!')
end

% flag the chirotope classes where lambda_max can be either positive
% or negative: only P6-P10. 
% (P1-P5 have lambda_max > 0, P11-P14 and M1-M12 have lambda_max < 0)

class_flag = 0; 
if ismember(chir_str,{'P6','P7','P8','P9','P10'})
    class_flag = 1;
end

hit = 0;
while ~hit
    U = rand(3);
    [W,class_str,sA,graph_str,k,idx123] = get_Wchir_graph(U);
    lambda_max = max(real(eig(-eye(3)+W))); % compute lambda_max 
    if strcmp(class_str,chir_str)
        hit = 1; 
    end
    if class_flag && (lambda_max>0) ~= lambda_flag
        hit = 0; % try again on P6-P10 if lambda_max is wrong sign
    end
end