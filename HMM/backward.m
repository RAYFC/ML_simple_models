function [beta] = backward(O, A, B)
% Given the size-T observation, O, and and HMM parameters corresponding to k states,
% backward.m computes and returns the "backward" matrix, beta, of size T*k, where
% beta( t, i) = Prob( O_{t+1}, ... O_{T-1} O_T | D_t = i )
% 
% Input:
%   O: sequence of Observations (1*T)
%   A: HMM transition matrix (k*k)
%   B: HMM emission matrix (m*k)
%
% Returns:
%   beta: a T*k matrix with probability of observation sequence from t+1 to
%   T. So beta(t,i)=Prob( O_{t+1}, ... O_{T-1} O_T | D_t = i )
%
%See Eqn 24-25 in Rabiner 1989 for details
T = length(O); % size of observation sequence
m= size(B,1);  % number of possible observed values
k = size(A,1);  % number of possible states
beta = zeros(T, k);


%Your code goes here 
for i = 10:-1:1
    %index = O(i);
    %conditional_p = B(index,:);
    if i == 10
        beta(i,:) = [1 1];
    else
        beta(i,:) = sum((beta(i+1,:).*A) .* B(O(i+1),:),2);
    end
end
end