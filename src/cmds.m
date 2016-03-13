function [X] = cmds(D,r,iAlpha)
%CMDS Classical multi-dimensional scaling
%   X = MDS(D, r, iAlpha) finds the N r-dimensional points 
%   in the N-by-r matrix X which Euclidean distances in the
%   r-dimensional subspace approximate optimally the original 
%   distances  given in N-by-N matrix D.
%
%   [X] = MDS(D, r, iAlpha) returns the N points in the N-by-r matrix X, 
%   based on the N-by-N distance matrix. The r dimensions are specified 
%   in the 1-by-r vector iAlpha.
%
%   [X] = MDS(D, r) returns the N points in the N-by-r matrix X, 
%   based on the N-by-N distance matrix. The dimensions of the subspace 
%   correspond to 1,...,r.
%
% References:
%
%   [1] Multivariate Analysemethoden by Andreas Handl
%
%   Copyright 2016 Eurika Kaiser

%% Check input
if nargin < 3
    iAlpha = [1:r];
end

if nargin < 2
    disp('ERROR: Not enough inputs.')
    return
end

if size(D,1) ~= size(D,2)
    disp('ERROR: Distance matrix is not a square matrix.')
end


if length(iAlpha) ~= r
    disp('WARNING: The number of specified eigenvalues in "iAlpha" does not correspond to "r".')
    disp('Using the first r eigenvalues.')
    iAlpha = [1:r];
end


%% Parameter
eps = 10^(-12); % Error
N = size(D,1);

%% Step 1 - Construct A
% A = (a_ij) = -0.5* D_ij^2
D2 = D.^2;
A  = -0.5 .* D2; 

%% Step 2 - Construct B = (bij) mit bij = aij - ai. - a.j + a..
a_idot = zeros(1,N);
a_dotj = zeros(1,N);
B      = zeros(N,N);

for i = 1:N
    a_idot(i) = 1/N*sum(A(i,:));
    a_dotj(i) = 1/N*sum(A(:,i));
end

a_dotdot = 1/(N^2)*sum(sum(A));

for i = 1:N
    for j = 1:N
        B(i,j) = A(i,j) - a_idot(i) - a_dotj(j) + a_dotdot;
    end
end

%% Step 3 - Eigenvalue problem of B
% V: col = eigvec
% D: diag(lambda_i)
[V,Lambda]  = eig(B);
lambda      = diag(Lambda);
[lambda,IX] = sort(lambda,'descend');
V           = V(:,IX);

%% Step 4 - Representation in R^r: first r principal components
lambda_r     = lambda(iAlpha);
V_r          = V(:,iAlpha);

%% Step 5 - Projection of centroids onto principal components
X = zeros(N,r);
for i = 1:r
    X(:,i) = sqrt(lambda_r(i)).*V_r(:,i);
end

%% Quality
% First negative eVal
idx0 = find(lambda<0,1,'first');
disp(['First idx of negative eVal: ', num2str(idx0)])
lambda(1:idx0)./max(abs(lambda))
idx = find(lambda<eps,1,'first');
disp(['First idx of eVal = 0 : ', num2str(idx)])

alpha1 = sum(abs(lambda_r))/sum(abs(lambda(end-1))); 
disp(['alpha1 = ', num2str(alpha1)])
alpha2 = sum(lambda_r)/sum(abs(lambda(1:idx0-1))); 
disp(['alpha2 = ', num2str(alpha2)])
alpha3 = sum(lambda_r.^2)/sum(lambda.^2);
disp(['alpha3 = ', num2str(alpha3)])

