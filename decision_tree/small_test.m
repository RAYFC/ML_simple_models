clear
clc
%load planets
load breast_cancer_dataset
tree = learnDecisionTree(train_set, attribute, 0);
print_tree(tree);

train_num_correct = 0;
for i = 1:size(train_set,1)
    classification = classify(tree, train_set(i,:));
    if classification == train_set(i,end)
        train_num_correct = train_num_correct + 1;
    end
end
train_num_correct

test_num_correct = 0;
for i = 1:size(test_set,1)
    classification = classify(tree, test_set(i,:));
    if classification == test_set(i,end)
        test_num_correct = test_num_correct + 1;
    end
end

test_num_correct
%% If your learnDecisionTree() and classify() functions work,
%  you should see the following output:
%
% Root
%  |-Attribute ID 1 = 0 
%  | |-Attribute ID 2 = 0 Class : 1   +/- = [127 , 11] 
%  | |-Attribute ID 2 = 1 Class : 0   +/- = [43 , 238] 
%  |-Attribute ID 1 = 1 
%  | |-Attribute ID 2 = 0 Class : 0   +/- = [16 , 123] 
%  | |-Attribute ID 2 = 1 Class : 1   +/- = [163 , 29] 
% 
% classification =
% 
%      0
