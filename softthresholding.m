function S = softthresholding (A, k)

% Calculation for value of soft thresholding given k and a
% argmin_X k||X||_1 + 1/2*||X-A||_F^2, given k > 0


S = zeros(size(A));

S(find(A>k)) = A(find(A>k)) - k;
S(find(A<-k)) = A(find(A<-k)) + k;

end
