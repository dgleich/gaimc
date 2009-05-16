%% Demo of gaimc - 'Graph Algorithms In Matlab Code'
% Matlab includes great algorithms to work with sparse matrices but does
% provide a reasonable set of algorithms to work with sparse matrices as
% graph data structures.  My other project -- MatlabBGL -- provides a
% high-performance solution to this problem by directly interfacing the
% Matlab sparse matrix data structure with the Boost Graph Library.  
% That library, however, suffers from enormous complication because 
% it must be compiled for each platform.  The Boost Graph Library 
% heavily uses advanced C++ features that impair easy portability
% between platforms.  In contrast, the gaimc library is implemented in
% pure Matlab code, making it completely portable.
%
% The cost of the portability for this library is a 2-4x slowdown in 
% the runtime of the algorithms as well as significantly fewer 
% algorithms to choose from.

%% Sparse matrices as graphs
% To store the connectivity structure of the graph, gaimc uses the
% adjacency matrix of a graph.  

%% Loading helper
% To make loading our sample graphs easy, gaimc defines it's own function
% to load graphs.

load_gaimc_graph('dfs_example'); % loads one of our example graphs
whos

%%
% This helps make our examples work regardless of where the current
% directory lies.  

%% Search algorithms
% The two standard graph search algorithms are depth first search and 
% breadth first search.  This library implements both.

%%
% Load the example matrix from the Boost Graph Library 
load('graphs/dfs_example');
figure(1); graph_draw(A,xy,'labels',labels);

%%
% Run a depth first search.  The output records the distance to the other
% vertices, except where the vertices are not reachable starting from the
% first node A.
d=dfs(A,1)

%%
% From this example, we see that vertices a-f are reachable from vertex a,
% but that verice g-i are not reachable.  Given the of the edges, this
% makes sense.

%%
% Let's look at breadth first search too, using a different example.
load('graphs/bfs_example');
figure(1); clf; graph_draw(A,xy,'labels',labels);

%%
% The breadth first search algorithm records the distance from the starting
% vertex to each vertex it visits in breadth first order.  This means it
% visits all the vertices in order of their distance from the starting
% vertex.  The d output records the distance, and the dt output records the
% step of the algorithm when the breadth first search saw the node.
[d dt] = bfs(A,2);
% draw the graph where the label is the "discovery time" of the vertex.
figure(1); clf; graph_draw(A,xy,'labels',num2str(dt));

%%
% Notice how the algorithm visits all vertices one edge away from the start
% vertex (0) before visiting those two edges away.

%% Shortest paths
% In the previous two examples, the distance between vertices was
% equivalent to the number of edges.  Some graphs, however, have specific
% weights, such as the graph of flights between airports.

%% Minimum spanning trees
% A minimum spanning tree is a set of edges from a graph that ...
%
% This demo requires the mapping toolbox for maximum effect, but we'll do
% okay without it.

%%
% Our data comes from a graph Brendan Frey prepared for his affinity
% propagation clustering tool.  For 456 cities in the US, we have the mean
% travel time between airports in those cities, along with their latitude
% and longitude.
load_gaimc_graph('airports')

%%
% For some reason, the data is stored with the negative travel time between
% cities.  (I believe this is so that closer cities have larger edges
% between them.)  But for a minimum spanning tree, we want the actual
% travel time between cities.
A = -A;

%%
% Now, we just call MST and look at the result.
T = mst_prim(A);

%%
% Oops, travel time isn't symmetric!  Let's just pick the longest possible
% time.
A = max(A,A');
T = mst_prim(A);
sum(sum(T))/2 % total travel time in tree

%% 
% Well, the total weight isn't that helpful, let's _look_ at the data
% instead.
clf;
gplot(T,xy);

%%
% Hey!  That looks like the US!  You can see regional airports and get some
% sense of the overall connectivity.  

%% Connected components

%% Statistics
% Graph statistics are just measures that indicate a property of the graph
% at every vertex, or at every edges.  Arguably the simplest graph
% statistic would be the average vertex degree.  Because such statistics
% are easy to compute with the adjaceny matrix in Matlab, they do not have
% special functions in gaimc.  

%%
% Load a road network to use for statistical computations
load('graphs/minnesota');
gplot(A,xy);

%%
% Average vertex degree
d = sum(A,2);
mean(d)
%% 
% So the average number of roads at any intersection is 2.5.  My guess is
% that many roads have artificial intersections in the graph structure that
% do not correspond to real intersections.  Try validating that hypothesis
% using the library!

%%
% Average clustering coefficients
ccfs = clustercoeffs(A);
mean(ccfs)
% The average clustering coefficient is a measure of the edge density
% throughout the graph.  A small value indicates that the network has few
% edges and they are well distributed throughout the graph.

%%
% Average core numbers
cn = corenums(A);
mean(cn)



%% Efficient repetition
% Every time a gaimc function runs, it converts the adjacency matrix into a
% set of compressed sparse row arrays.  These arrays yield efficient access
% to the edges of the graph starting at a particular vertex.  For many
% function calls on the same graph, this conversion process slows the
% algorithms.  Hence, gaimc also accepts pre-converted input, in which case
% it skips it's conversion.  
%
% Let's demonstrate how this works by calling Dijkstra's algorithm to
% compute the shortest paths between all vertices in the graph.  The 
% Floyd Warshall algorithm computes these same quantities more efficiently,
% but that would just be one more algorithm to implement and maintain.

%%
% Load and convert the graph.  
load ('graphs/all_shortest_paths_example');
A = spfun(@(x) x-min(min(A))+1,A); % remove the negative edges
As = convert_sparse(A);
%%
% Now, we'll run Dijkstra's algorithm for every vertex and save the result
% On my 2GHz laptop, this takes 0.000485 seconds.
n = size(A,1);
D = zeros(n,n);
tic
for i=1:n
    D(i,:) = dijkstra(As,i);
end
toc
%%
% Let's try it without the conversion to see if we can notice the
% difference in speed.
% On my 2GHz laptop, this takes 0.001392 seconds.
D2 = zeros(n,n);
tic
for i=1:n
    D2(i,:) = dijkstra(A,i);
end
toc
%%
% And just to check, let's make sure the output is the same.
isequal(D,D2)