function S = cosineknn(A,K)
% COSINEKNN Compute k-nearest neighbors with a cosine distance metric
% 
% S = cosineknn(A,k) computes a cosine similarity metric between the
% vertices of A or the upper half of a bipartite graph A
%

% David F. Gleich
% Copyright, Stanford University, 2009

% History
% 2009-08-12: Initial version

% TODO support struct input
% TODO support other similarity functions
% TODO allow option for diagonal similarity too
% TODO allow option for triplet output


if isstruct(A), 
    error('cosineknn:notSupported','struct input is not supported yet');
else
    [rp ci ai]=sparse_to_csr(A); check=1;
    [rpt cit ait]=sparse_to_csr(A'); 
    [n,m] = size(A);
end

% compute a row norm (which means we accumlate the column indices of At)
rn = accumarray(cit,ait.^2);
rn = sqrt(rn);
rn(rn>eps(1)) = 1./rn(rn>eps(1)); % do division once

% the output is a n-by-n matrix, allocate storage for it
si = zeros(n*K,1);
sj = zeros(n*K,1);
sv = zeros(n*K,1);
nused = 0;

dwork = zeros(n,1);
iwork = zeros(n,1);
iused = zeros(n,1);
for i=1:n
    % for each row of A, compute an inner product against all rows of A.
    % to do this efficiently, we know that the inner-product will
    % only be non-zero if two rows of A overlap in a column.  Thus, in
    % row i of A, we look at all non-zero columns, and then look at all
    % rows touched by those columns in the A' matrix.  We  compute
    % the similarity metric, then sort and only store the top k.
    
    curused = 0; % track how many non-zeros we compute during this operation
    
    for ri=rp(i):rp(i+1)-1
        % find all columns j in row i
        j = ci(ri);
        aij = ai(ri)*rn(i);
        for rit=rpt(j):rpt(j+1)-1
            % find all rows k in column j
            k = cit(rit);
            if k==i, continue; end % skip over the standard entries
            akj = ait(rit)*rn(k);
            if iwork(k)>0
                % we already have a non-zero between row i and row k
                dwork(iwork(k)) = dwork(iwork(k)) + aij*akj;
            else
                % we need to add a non-zero betwen row i and row k
                curused = curused + 1;
                iwork(k) = curused;
                dwork(curused) = aij*akj;
                iused(curused) = k;
            end
        end
    end
    % don't sort if fewer than K elements
    if curused < K,
        sperm = 1:curused;
    else
        [sdwork sperm] = sort(dwork(1:curused),1,'descend');
    end
    for k=1:min(K,length(sperm))
        nused = nused + 1;
        si(nused) = i;
        sj(nused) = iused(sperm(k));
        sv(nused) = dwork(sperm(k));
    end
    % reset the iwork array, no need to reset dwork, as it's just 
    % overwritten
    for k=1:curused
        iwork(iused(k)) = 0;
    end
end
si = si(1:nused);
sj = sj(1:nused);
sv = sv(1:nused);
S = sparse(si,sj,sv,n,n);