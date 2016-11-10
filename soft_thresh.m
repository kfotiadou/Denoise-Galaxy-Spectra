function x = soft_thresh(b,lambda)

% Set the threshold
th =lambda/2; 

% First find elements that are larger than the threshold
k = find(b > th);
x(k) = b(k) - th; 

% Next find elements that are less than abs
k = find(abs(b) <= th);
x(k) = 0; 

% Finally find elements that are less than -th
k = find(b < -th);
x(k) = b(k) + th;
x = x(:);