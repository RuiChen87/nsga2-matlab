function [pop] = assign_rank_and_crowding_distance(pop)
%   This procedure applies the non-dominated sort and
%   then compute the crowding distance within each front.

global nreal ;
global nobj ;
global ncon ;

rank_col = nreal + nobj + ncon + 2 ;
[popsize, ~] = size(pop);

all_indices = 1:popsize; % initially start with the whole population
% generate the dominance matrix with the current indices
dominance_matrix = generate_dominance_matrix(... % It's fast now
                pop(all_indices,:), ...
                all_indices);

front = 1 ; % initial front is 1
while (not(isempty(all_indices)))
% for i = 1:1
    % now reduce the dom_mat    
    dom_mat = [all_indices.', dominance_matrix(all_indices, all_indices+1)];    
    % get the indices of the current pf
    minus_one_count = [all_indices.', sum(dom_mat == -1,2)] ;    
    pf_indices = minus_one_count(minus_one_count(:,2) == 0,1);
    % assign the current front number
    pop(pf_indices, rank_col) = front;
    % now do the crowding distance assignment for this front
    pop = assign_crowding_distance(pop, pf_indices);   
    % remove the ranked indices from the list
    all_indices = all_indices(~ismember(all_indices, pf_indices));
    % go to next front
    front = front + 1;
end
end