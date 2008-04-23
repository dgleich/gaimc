%=========================================
% Graph Algorithms in Matlab Code (gaimc)
%   Written by David Gleich
%   Version 1.0 (beta)
%   2008-04-21
%=========================================
%
% Search algorithms
% dfs                        - depth first search
% bfs                        - breadth first search
%
% Shortest path algorithms
% dijkstra                   - Dijkstra's shortest path algorithm
%
% Minimum spanning tree algorithms
% primmst                    - Compute an MST using Prim's algorithm
%
% Connected components
% scomponents                - Compute strongly connected components
% 
% Statistics
% clustercoeffs              - Compute clustering coefficients
% dirclustercoeffs           - Compute directed clustering coefficients
% corenums                   - Compute core numbers
%
% Helper functions
% sparse_to_csr              - Compressed sparse row arrays from a matrix

% David Gleich
% Copyright, Stanford University, 2008

% History
% 2008-04-10: Initial version

% wcorenums                  - Compute weighted core numbers
% countsquares               - Count the number of squares from each vertex
% sparse_to_csrac            - Compressed sparse row and column arrays
%
% Minimum spanning trees
% prim                       - Prim's minimum spanning tree algorithm