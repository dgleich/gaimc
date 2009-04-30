function [d pred]=dijkstra(A,u)

% David Gleich
% Copyright, Stanford University, 2008

% History
% 2008-04-09: Initial coding

if isstruct(A), 
    rp=A.rp; ci=A.ci; ai=A.ai; 
    check=0;
else
    [rp ci ai]=sparse_to_csr(A); check=1;
end
if check && any(ai)<0, error('gaimc:dijkstra', ...
        'dijkstra''s algorithm cannot handle negative edge weights.'); end

n=length(rp)-1; 
d=Inf*ones(n,1); T=zeros(n,1); L=zeros(n,1);
pred=zeros(1,length(rp)-1);

n=1; T(n)=u; L(u)=n; % oops, n is now the size of the heap

% enter the main dijkstra loop
d(u) = 0;
while n>0
    v=T(1); ntop=T(n); T(1)=ntop; L(ntop)=1; n=n-1; % pop the head off the heap
    k=1; kt=ntop;                   % move element T(1) down the heap
    while 1,
        i=2*k; 
        if i>n, break; end          % end of heap
        if i==n, it=T(i);           % only one child, so skip
        else                        % pick the smallest child
            lc=T(i); rc=T(i+1); it=lc;
            if d(rc)<d(lc), i=i+1; it=rc; end % right child is smaller
        end
        if d(kt)<d(it), break;     % at correct place, so end
        else T(k)=it; L(it)=k; T(i)=kt; L(kt)=i; k=i; % swap
        end
    end                             % end heap down
    
    % for each vertex adjacent to v, relax it
    for ei=rp(v):rp(v+1)-1            % ei is the edge index
        w=ci(ei); ew=ai(ei);          % w is the target, ew is the edge weight
        % relax edge (v,w,ew)
        if d(w)>d(v)+ew
            d(w)=d(v)+ew; pred(w)=v;
            % check if w is in the heap
            k=L(w); onlyup=0; 
            if k==0
                % element not in heap, only move the element up the heap
                n=n+1; T(n)=w; L(w)=n; k=n; kt=w; onlyup=1;
            else kt=T(k);
            end
            % update the heap, move the element down in the heap
            while 1 && ~onlyup,
                i=2*k; 
                if i>n, break; end          % end of heap
                if i==n, it=T(i);           % only one child, so skip
                else                        % pick the smallest child
                    lc=T(i); rc=T(i+1); it=lc;
                    if d(rc)<d(lc), i=i+1; it=rc; end % right child is smaller
                end
                if d(kt)<d(it), break;      % at correct place, so end
                else T(k)=it; L(it)=k; T(i)=kt; L(kt)=i; k=i; % swap
                end
            end
            % move the element up the heap
            j=k; tj=T(j);
            while j>1,                       % j==1 => element at top of heap
                j2=floor(j/2); tj2=T(j2);    % parent element
                if d(tj2)<d(tj), break;      % parent is smaller, so done
                else                         % parent is larger, so swap
                    T(j2)=tj; L(tj)=j2; T(j)=tj2; L(tj2)=j; j=j2;
                end
            end  
        end
    end
end
