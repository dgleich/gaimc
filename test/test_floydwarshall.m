function test_floydwarshall

%% Compare against dijkstra
load_gaimc_graph('all_shortest_paths_example');
A = spfun(@(x) x-min(min(A))+1,A); % remove the negative edges
n = size(A,1);
% Now, we'll run Dijkstra's algorithm for every vertex and save the result

D2 = zeros(n,n);
for i=1:n
    D2(i,:) = dijkstra(A,i);
end
D = floydwarshall(A);
if any(D-D2) 
    error('test:floydwarshall','floyd warshall returned incorrect distances');
end

%% Compare predecessors
load_gaimc_graph('all_shortest_paths_example');
A = spfun(@(x) x-min(min(A))+1,A); % remove the negative edges
n = size(A,1);
P2 = zeros(n,n);
for i=1:n
    [d,p]=dijkstra(A,i);
    P2(i,:) = p;
end
[D,P] = floydwarshall(A);
if any(P-P2) 
    error('test:floydwarshall','floyd warshall returned incorrect predecessors');
end
