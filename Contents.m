%=========================================
% Graph Algorithms in Matlab Code (gaimc)
%   Written by David Gleich
%   Version 1.1
%   2008-2009
%=========================================
%
% Search algorithms
% dfs                        - depth first search
% bfs                        - breadth first search
%
% Shortest path algorithms
% dijkstra                   - Dijkstra's shortest path algorithm
% floydwarshall              - Floyd-Warshall all shortest path algorithm
%
% Minimum spanning tree algorithms
% mst_prim                   - Compute an MST using Prim's algorithm
%
% Matching
% bipartite_matching         - Compute a maximum weight bipartite matching
%
% Connected components
% scomponents                - Compute strongly connected components
% largest_component          - Selects only the largest component
% 
% Statistics
% clustercoeffs              - Compute clustering coefficients
% dirclustercoeffs           - Compute directed clustering coefficients
% corenums                   - Compute core numbers
%
% Drawing
% graph_draw                 - Draw an adjacency matrix (from Leon Peshkin)
%
% Helper functions
% sparse_to_csr              - Compressed sparse row arrays from a matrix
% csr_to_sparse              - Convert back to Matlab sparse matrices
% load_gaimc_graph           - Loads a sample graph from the library

% David F. Gleich
% Copyright, Stanford University, 2008-2009

% History
% 2008-04-10: Initial version


% TODO for release
% Update demo with floydwarshall
% Update airports with floydwarshall


% Future todos
% Implement geometric random graph generation
% Implement erdos reyni graph generatin
% Implement spectral graph partitioning
% Implement a max-flow solver
% Implement weighted core nums
% More testing
