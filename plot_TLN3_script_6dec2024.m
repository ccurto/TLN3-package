% plot_TLN3_script_6dec2024.m
%
% script to generate W for target chirotope class, choose many b's,
% and then plot the dynamics for (W,b)'s selected
%
% calls: get_TLN3.m, plot_TLN3.m, and get_bvecs.m functions
% created by carina on dec 6, 2024, updated 7:10pm


% step 1: load pre-saved (W,B) or get a new one........................

foldername = 'examples/';

% first, load previous data or generate a new network?
loadflag = 1; % 0 to select a new W, or 1 to load previously saved

% load a previously-saved (W,B), where B is a matrix of b's
loadstr = 'P5_ex2_dec6'; % modify this to load!
if loadflag
    load([foldername loadstr],'W','B','titlestr')
    savestr = []; % don't save
    % savestr = [foldername loadstr]; % save under same name
end

% OR
% generate W matrix for target chirotope class, and select b's
if ~loadflag
    chir_str = 'P6'; % P1-P14 or M1-M12, target chirotope class
    example_tag = '_ex2_dec6';
    savestr = [foldername chir_str example_tag]; % update this!
    lambda_flag = 1; % to force lambda_max>0 for P6-P10 (ignored otherwise)
    m = 3; % number of values of b to select
    % first get W matrix
    [W,class_str,k,idx123,lambda_max] = get_TLN3(chir_str,lambda_flag);
    titlestr = [class_str ' (k=' int2str(k) '), ' ...
        ' (\lambda_{max} = ' num2str(lambda_max) ')'];
    % second, select b's for B matrix
    figure(1)
    [P,B,FP_str] = get_bvecs(W,m,titlestr);
end


% step 2: plot figures with dynamics!..................................

% make one plot for each column of B (each b choice)
for i=1:size(B,2)
    figure(1+i)
    b = B(:,i); % select i-th b vector
    % tailor initial conditions to fixed points
    [FP,FP_str,fixpts,idx] = get_FP(W,b,0);
    fp = fixpts(end,:); % largest support fixed point
    fp1 = fp+.01*rand(1,3); % + perturbation
    fp2 = fp-.01*rand(1,3); % - perturbation
    bs = -W^(-1)*b; % balanced state
    % specify 3 initial conditions in X0 (transpose to make them columns)
    X0 = [fp1; fp2; bs']';
    % plot the matrix, simplex, chirotope, and ratecurves
    T = 100; % time length for simulation
    clf % clear prior plots and text
    plot_TLN3(W,b,X0,T);
    subplot(1,5,2:3)
    title(['b vector no. ' int2str(i)])
end


% step 3: save example and figures.....................................

if ~isempty(savestr)

% save example data
save(savestr,'W','B','titlestr','X0')

% give a chance to resize before saving
fprintf('Resize windows before saving, then hit spacebar\n')
pause 

% save figures
figure(1)
set(gcf,'PaperPositionMode','auto');
exportgraphics(gcf, [savestr '_simplex.png'], 'Resolution', 300);

for i=1:size(B,2)
    figure(i+1)
    file_i = [savestr '_b' int2str(i)];
    set(gcf,'PaperPositionMode','auto');
    exportgraphics(gcf, [file_i '.png'], 'Resolution', 300);
end

end