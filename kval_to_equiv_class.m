function [class_str, class, class_num] = kval_to_equiv_class(k,idx123)

% function [class_str, class, class_num] = kval_to_equiv_class(k,idx123)
% 
% k = table number (1...512)
% idx123 = 1 or -1, indicating if k is a "plus" or "minus" table
% class_str = string indicating class, such as 'P4' or 'M12'
% class = number of equivalence class 
%         (1-14 for "plus" and 1-12 for "minus" tables)
% class_num = number of equiv class from 1-26 (15-26 for "minus" tables)
%
% created by carina on dec 17, 2023
% updated on dec 19, 2023 to add "class_num" as an output

% load lists of equivalence classes
load('chirotope_equiv_classes.mat','plus_eq_class','minus_eq_class',...
    's_Mcell','TF_plus1','TF_minus1','TF_pm1')

% find idx123 if not given
% set idx123 = 1 if k appears in both plus and minus tables
if nargin<2 || isempty(idx123)
    idx123 = TF_plus1(k) - TF_minus1(k) + TF_pm1(k); 
end

% unless it's explicitly a minus table, assume a plus table 
if idx123 == -1
    eq_class = minus_eq_class;
    class_str = 'M';
    shift = 14;
else
    eq_class = plus_eq_class;
    class_str = 'P';
    shift = 0;
end

% find class! return empty string if there's no class matching idx123
class = [];
class_num = [];
for j=1:length(eq_class)
    tf = ismember(k,eq_class{j});
    if tf
        class = j;
        class_num = j + shift; % add 14 if it's a minus class
    end
end

if ~isempty(class)
    class_str = [class_str int2str(class)];
else
    class_str = 'n/a';
end