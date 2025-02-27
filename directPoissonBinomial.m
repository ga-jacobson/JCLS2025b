function prob = directPoissonBinomial(p, k)
    % p is vector of probabilities for each trial
    % k is desired number of successes
    n = length(p);
    
    % Get all possible combinations of k successes
    combinations = nchoosek(1:n, k);
    
    prob = 0;
    % For each combination
    for i = 1:size(combinations, 1)
        curr_prob = 1;
        success_indices = combinations(i,:);
        
        % Multiply probabilities of success for chosen indices
        for j = 1:n
            if ismember(j, success_indices)
                curr_prob = curr_prob * p(j);
            else
                curr_prob = curr_prob * (1 - p(j));
            end
        end
        
        prob = prob + curr_prob;
    end
end