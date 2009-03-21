
% scomponents
load('graphs/cores_example'); % the graph A has three components
ci = scomponents(A)
max(ci)                       % should be 3
R = sparse(1:size(A,1),ci,1,size(A,1),ncomp); % create a restriction matrix
CG = R'*A*R;                  % create the graph with each component 
                             % collapsed into a single node.
