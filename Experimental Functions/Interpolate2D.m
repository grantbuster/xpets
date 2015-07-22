function [ out ] = Interpolate2D( i , j , image )
% Interpolates a single point in between four points

% a=image(floor(j),floor(i));
% b=image(floor(j),ceil(i));
% c=image(ceil(j),floor(i));
% d=image(ceil(j),ceil(i));

x1 = image(floor(j),floor(i)) + (image(floor(j),ceil(i))-image(floor(j),floor(i))) * (i-floor(i));
x2 = image(floor(j),floor(i)) + (image(ceil(j),floor(i))-image(floor(j),floor(i))) * (j-floor(j));

x3 = image(ceil(j),ceil(i)) + (image(ceil(j),floor(i))-image(ceil(j),ceil(i))) * (i-floor(i));
x4 = image(ceil(j),ceil(i)) + (image(floor(j),ceil(i))-image(ceil(j),ceil(i))) * (j-floor(j));

out=(x1+x2+x3+x4)/4;

end