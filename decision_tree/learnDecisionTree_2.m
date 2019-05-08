%% learnDecisionTree
% The algorithm for this code was outlined in the lecture notes:
%  https://eclass.srv.ualberta.ca/pluginfile.php/2897723/mod_resource/content/5/6a-DecisionTree.pdf
% on slide labeled with the number 29.
% 
% Inputs: 
%       examples            - set of examples [X1, ..., Xn, Class_label]
%                             where each row is an example and Xi (1<=i<=n)
%                             is the ith attribute (see 'id' below)
%       attributes          - attribute descriptions: a [num_attributes x 1]
%                             vector of structs with fields: 
%                                   'id'    - a unique id number
%                                   'name'  - human understandable name of attribute
%                                   'value' - possible attribute values
%
%                             Example: attribute(1) = 
%                                      id: 1
%                                      name: 'Clump Thickness'
%                                      value: [1 2 3 4 5 6 7 8 9 10]
%       default             - default predicted label
% 
% Outputs:
%       tree                - Decision Tree

function tree = learnDecisionTree_2(examples, attributes, default,depth)
    %attributes
    %% Here's a helpful structure for creating a tree in MATLAB
    %  Each node in the tree is struct with five fields. 
    %         'attribute_id'- integer id of the attribute we split on
    %         'isleaf'      - is 'true' if the node is a leaf 
    %                         and 'false' otherwise (This should be a
	%						  boolean, not a string)
    %         'class'       - is empty if the node is not a leaf. 
    %                         If node is a leaf, class = 0 or 1
    %         'children'    - is empty if the node is a leaf. 
    %                         Otherwise, it is a cell {} where 
    %                         tree.children{i} is the subtree when the 
    %                         tree.attribute_id takes on value tree.value(i).
    %         'value'       - a vector of values that the attribute can
    %                         take. Is empty if the node is a leaf.
    %         'num_1'       - The number of training examples in class = 1
    %                         at the node.
    %         'num_0'       - The number of training examples in class = 0
    %                         at the node.
    %         'num_tot'     - The total number of training examples at the
    %                         node.
    %
    %  Example (non-leaf node):
    % 
    %     attribute_id: 1
    %           isleaf: 0
    %            class: []
    %         children: {1x10 cell}
    %            value: [1 2 3 4 5 6 7 8 9 10]
    %            num_1: 43
    %            num_0: 2
    %          num_tot: 45
    %  
    %  Example (leaf node):
    %  
    %     attribute_id: []
    %           isleaf: 1
    %            class: 0
    %         children: []
    %            value: []
    %            num_1: 43
    %            num_0: 2
    %          num_tot: 45
    
    tree = struct('attribute_id',[],...
                  'isleaf',true,...
                  'class',default,...
                  'children',[],...
                  'value',[],...
                  'num_1',-1,...
                  'num_0',-1,...
                  'num_tot',-1);             

    %% 0. If there are no examples to classify, return
    num_examples = size(examples,1);
    if num_examples == 0
        return;
    end    
    %% 1. If all examples have the same classification, create a 
    %      tree leaf node with that classification and return
    labels = examples(:, end);
    % <ENTER YOUR CODE HERE>
    if (size(unique(labels),1) == 1)
        tree.isleaf = 1;
        tree.class = labels(1);
        tree.num_0 = length(find(labels==0));
        tree.num_1 = length(find(labels==1));
        tree.num_tot = length(labels);
        return;
    end
    %% 2. If attributes is empty, create a leaf node with the
    %      majority classification and return.

    % <ENTER YOUR CODE HERE>
    if isempty(attributes) == 1
        tree.isleaf = 1;
        if length(find(labels==0)) > length(find(labels==1))
            tree.class = 0;
            %disp(1);
        else
            tree.class = 1;
            %disp(2);
        end
        tree.num_0 = length(find(labels==0));
        tree.num_1 = length(find(labels==1));
        tree.num_tot = length(labels);
        %disp(3)
        return;
    end
     if depth < 1
         tree.isleaf = 1;
        if length(find(labels==0)) > length(find(labels==1))
            tree.class = 0;
        else
            tree.class = 1;
        end
        tree.num_0 = length(find(labels==0));
        tree.num_1 = length(find(labels==1));
        tree.num_tot = length(labels);
        return;
    end                    
    %% 3. Find the best attribute -- the attribute with the lowest uncertainty
    % <ENTER YOUR CODE HERE>
    temp = 1;
    num_features = size(attributes,1);
    id_list = [attributes.id];
    for i = 1 : num_features
        possible_val = unique(examples(:, i));
        if uncert(i,possible_val,examples) < temp
            temp = uncert(i, possible_val, examples);
            best = id_list(i);
            best_index = i;
        end
    end
    %% 4. Make a non-leaf tree node with root 'best'
    % 
    % <ENTER YOUR CODE HERE>
    tree.attribute_id = best;
    tree.isleaf = 0;
    tree.value = attributes(best_index).value;
    tree.num_0 = length(find(labels==0));
    tree.num_1 = length(find(labels==1));
    tree.num_tot = length(labels);
    %% 5. For each value v_i that the best attribute can take, do the following:
    %     a. examples_i <-- elements of examples where the best attribute has value v_i
    %     b. subtree <-- recursive call to learnDecisionTree with inputs:
    %              examples_i
    %              all attributes but the best
    %              the majority value of the examples
    %     c. add branch to tree with label vi and subtree
    num_options = length(tree.value);
    %if num_options == 0
    %    return;
    %end
    tree.children = cell(1,num_options);
    for i = 1 : num_options
        value = tree.value(i);
        new_examples = [];
        for j = 1 : num_examples
            if examples(j,best_index) == value
                new_examples = [new_examples;examples(j,:)];
            end
        end
        if ~isempty(new_examples)
            new_examples(:,best_index) = [];
        end
        temp = attributes;
        temp(best_index) = [];
        tree.children{i} = learnDecisionTree_2(new_examples, temp, default,depth-1);
    end
end


%% You may wish to write a function that...
%  Computes the uncertainty of the i-th attribute when given:
%        i                - the id of the attribute
%        attribute_vals   - the vector of possible values that attribute
%                           can take
%        examples         - the set of examples on which you'll compute
%                           the information gain
%% 
function value = uncert(i, attribute_vals, examples)
%      <ENTER CODE HERE>
    classes = examples(:,end);
    num_examples = length(classes);
    features_val = examples(:,i);       
    value = 0;
    len = length(attribute_vals); 
    for j = 1:len
        S = 0 ;
        num_1 = 0;
        num_0 = 0;
        for m = 1:num_examples
            if features_val(m) == attribute_vals(j)
                S = S + 1;
                if classes(m) == 1
                    num_1 = num_1 + 1;
                end
                if classes(m) == 0
                    num_0 = num_0 + 1;     
                end
            end
        end
        e = entropy(num_1,num_0);
        temp = (S/num_examples) * e;
        value = value + temp;
    end
end


%% You may wish to have an entropy function that...
%  Computes entropy when given:
%        p               - the number of class = 1 examples
%        n               - the number of class = 0 examples
% [Hint: what if input is zero?]
%%
function en = entropy(p,n)
%        <ENTER CODE HERE>
    p0 = n/(n+p);
    p1 = p/(n+p);
    if p0 == 0
        p0 = 1;
    end
    if p1 == 0
        p1 = 1;
    end
    en = - p0*log2(p0) - p1*log2(p1);
end
