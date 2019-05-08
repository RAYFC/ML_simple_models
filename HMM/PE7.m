function [phi_a, alpha, P_O, beta, qstar, P_b, P_c, prob_watch, ...
    prob_not_watch] = PE7()
% CMPUT 466/551 (2016)
% PE#7 script

% HMM State transition matrix
A = [0.8, 0.2; ...
     0.1, 0.9];

% HMM Emission Matrix
B = [1/6 4/5; ...
	1/6 1/25;...
	1/6 1/25;...
	1/6 1/25;...
	1/6 1/25;...
	1/6 1/25];

% Observations from HMM
O = [4, 1, 2, 3, 1, 3, 1, 1, 5, 6];

% Initial state distribution
% This is P(D_0). Note that phi_0 = [P(D_0 = f), P(D_0 = r)]
phi_0 = [0.5 0.5];

% Using the initial state distribution, predict the state distribution
% before evidence i.e. P(D1)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Your code here for (a)
% Modify this variable as needed.
phi_a = phi_0 * A
% Complete the file forward.m
[alpha, P_O] = forward(O, phi_a, A, B);
% Complete the file backward.m
beta = backward(O, A, B);
% Now answer the Questions:


% (b): Compute P_b = P(D_t = r | O_1:t) for t = 1,2,...10
% Hint :  Alpha is needed here
% Modify this variable as needed.
P_b = alpha(:,2)./sum(alpha,2)
% (c): Compute P_c = P(D_t = r | O_1:10)
% gamma is needed here (See Eqn 27 in Rabiner 1989 for details)
% Modify this variable as needed.
temp = alpha .* beta;
gamma = temp ./sum(temp,2);
P_c = gamma(:,2)



% (d): q_star = argmax_d P(D=d | O_1:10)
% use viterbi algorithm
% Complete the file viterbi.m
qstar = viterbi(O, phi_a, A, B)


% (e): P_+L(O_1:10) and P_-L(O_1:10)
% Modify these variable as needed.
prob_not_watch = P_O(end)
A_new = [0.75, 0.25; ...
     0.05, 0.95];
phi_a = phi_0 * A_new;
[alpha, P_O] = forward(O, phi_a, A_new, B);
prob_watch = P_O(end)
% P_+L(O_1:10)% P_-L(O_1:10)

end
