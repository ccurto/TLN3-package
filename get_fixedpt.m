function [x_fp,y_fp,tau,TF] = get_fixedpt(W,b,sig)

% function [x_fp,y_fp,tau,TF] = get_fixedpt(W,b,sig)
%
% (W,b) = W matrix and b vector defining the TLN
% sig = index set, sigma, for linear system L_sig corresponding to fp
%       we allow sig = [] (emptyset) as a possibility
% 
% x_fp = fixed point of TLN (W,b) with support sig
% y_fp = vector of y_i values evaluated at fixed point
%        specifically: y_fp = W*x_fp+b
%        note that x_fp = [y_fp]_+ coordinate by coordinate
%        *iff* x_fp is a TLN fixed point
% tau = index set of chamber R_tau where x_fp resides
%       tau = {i \in [n] | y_i > 0}
% TF = 1 if x_fp is a fixed point of the TLN (W,b) (i.e., tau = sig)
%    = 0 if x_fp is not a fixed point of the full TLN
%
% created by carina on 12/17/22

n = size(W,1); % number of neurons
TF = 1; % assume a fixed pt exists, change to 0 if not

if nargin<2 || isempty(b)
    b = ones(n,1);
end

if nargin<3 || isempty(sig)
    sig = []; % corresponds to all-zeros fixed point, empty support
end

% if a fixed pt exists with empty supp sigma, then x_fp = 0
x_fp = zeros(n,1);

% if a fixed pt exists with *noempty* supp sigma, 
% then x_fp(sig) = (I-W_sig)^{-1}b_sig
if ~isempty(sig)
    M = eye(n)-W; % I-W matrix
    M_sig = M(sig,sig); % (I-W)_sig matrix
    x_fp(sig) = M_sig^(-1)*b(sig); % update fixed pt vector
end

% compute y_fp and tau (note that x_fp \in R_tau chamber)
y_fp = W*x_fp + b;
tau = find(y_fp>0);

% make sure sig and tau are both row vectors
sig = sort(reshape(sig,1,length(sig)));
tau = sort(reshape(tau,1,length(tau)));

% finally, determine if x_fp is a fixed point of the full TLN
if sum(x_fp>0)<length(sig) % check for violation of "on" neuron conditions
    TF = 0;
else
    TF = isequal(sig,tau); % check "off" neuron conditions
end