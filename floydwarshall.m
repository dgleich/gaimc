function [D,P] = floydwarshall(A)
% FLOYDWARSHALL Compute all shortest paths using the Floyd-Warshall algorithm
%
% D=floydwarshall(A) returns the shortest distance matrix between all pairs
% of nodes in the graph A.  If A has a negative weight cycle, then this
% algorithm will throw an error.
%
% [D,P]=floydwarshall(A) also returns the matrix of predecessors.
%
% See also DIJKSTRA
%
% Example:
%   load_gaimc_graph('all_shortest_paths_example') 
%   D = floydwarshall(A)

% David F. Gleich
% Copyright, Stanford University, 2009

% History
% 2008-05-23: Initial coding

if isstruct(A), 
    rp=A.rp; ci=A.ci; ai=A.ai; 
    [ri ci ai]=csr_to_sparse(rp,ci,ai);
    n = length(rp)-1;
else
    [ri ci ai]=find(A);
    n = size(A,1);
end

nz = length(ai);
computeP = nargout>1;
D = Inf*ones(n,n);
  
if computeP
    P = zeros(n,n); 
    % initialize the distance and predecessor matrix
    for ei=1:nz
        i=ri(ei);
        j=ci(ei);
        v=ai(ei);
        if v<D(i,j)
            D(i,j)=v;
            P(i,j)=i;
        end
    end
    for i=1:n, D(i,i) = 0; end % set diagonal to 0
    for k=1:n
        for i=1:n
            for j=1:n
                if D(i,k)+D(k,j)<D(i,j)
                    D(i,j)=D(i,k)+D(k,j);
                    P(i,j)=P(k,j);
                end
            end
        end
    end
else
    % initialize the distance matrix    
    for ei=1:nz
        i=ri(ei);
        j=ci(ei);
        v=ai(ei);
        D(i,j)=min(D(i,j),v);
    end
    for i=1:n, D(i,i) = 0; end % set diagonal to 0
    for k=1:n
        for i=1:n
            for j=1:n
                D(i,j)=min(D(i,j),D(i,k)+D(k,j));
            end
        end
    end
end

if any(diag(D))<0
    warning('floydwarshall:negativeCycle','negative weight cycle detected');
end
