function test_mst_prim
msgid = 'gaimc:mst_prim';
load_gaimc_graph('clr-24-1');
A(2,3) = 9; A(3,2) = 9;
T = mst_prim(A); % root the tree at vertex 
Ttrueijv = [
     2     8     1     4     6     9     3     5     4     3     7     6     8     1     7     3
     1     1     2     3     3     3     4     4     5     6     6     7     7     8     8     9
     4     8     4     7     4     2     7     9     9     4     2     2     1     8     1     2 ];
Ttrue = sparse(Ttrueijv(1,:),  Ttrueijv(2,:), Ttrueijv(3,:), 9,9);
if nnz(T - Ttrue) ~= 0
    error(msgid, 'mst_prim failed');
end

load_gaimc_graph('clr-24-1');
T1 = mst_prim(A); % root the tree at vertex 
T2 = mst_prim(A,[],5);
T1T2diff = sparse(9,9); T1T2diff(2,3) = 8; T1T2diff(1,8) = -8;
if nnz(triu(T1-T2)-T1T2diff) ~= 0
    error(msgid, 'mst_prim failed rooted test');
end
