
% scomponents
load('graphs/cores_example'); % the graph A has three components
ci = scomponents(A)
max(ci)                       % should be 3
R = sparse(1:size(A,1),ci,1,size(A,1),ncomp); % create a restriction matrix
CG = R'*A*R;                  % create the graph with each component 
                             % collapsed into a single node.

                             
% equivalent to load('graphs/airports.mat') run from the gaimc directory
load_gaimc_graph('airports') 
% equivalent to P=load('graphs/kt-7-2.mat') run from the gaimc directory
P=load_gaimc_graph('kt-7-2.mat') 
% so you don't have to put the path in for examples!