function [rp ci ai]=sparse_to_csr(A)
% SPARSE_TO_CSR Convert a sparse matrix into compressed row storage arrays
% 
% [rp ci ai] = sparse_to_csr(A) returns the row pointer (rp), column index
% (ci) and value index (ai) arrays of a compressed sparse representation of
% the matrix A.
%
% Example:
%   A=sparse(6,6); A(1,1)=5; A(1,5)=2; A(2,3)=-1; A(4,1)=1; A(5,6)=1; 
%   [rp ci ai]=sparse_to_csr(A)
%
% See also SPARSE_TO_CSC

% David Gleich
% Copyright, Stanford University, 2008

% History
% 2008-04-07: Initial version

n = size(A,1); nz=nnz(A);
retc = nargout>1; reta = nargout>2;
if reta,     [nzi nzj nzv] = find(A); 
else         [nzi nzj] = find(A);
end
if retc, ci = zeros(nz,1); end
if reta, ai = zeros(nz,1); end
rp = zeros(n+1,1);
for i=1:nz
    rp(nzi(i)+1)=rp(nzi(i)+1)+1;
end
rp=cumsum(rp);
if ~retc && ~reta, rp=rp+1; return; end
for i=1:nz
    if reta, ai(rp(nzi(i))+1)=nzv(i); end
    ci(rp(nzi(i))+1)=nzj(i);
    rp(nzi(i))=rp(nzi(i))+1;
end
for i=n:-1:1
    rp(i+1)=rp(i);
end
rp(1)=0;
rp=rp+1;