% gap_detection.m
%
figure; plot((v));
for i=1:198
v(i) = (u(i) - u(i+1))/u(i+1);
end