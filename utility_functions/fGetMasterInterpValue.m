% Function Returns the Interpolated Value of Surface Z

function z_out = fGetMasterInterpValue(x_in,y_in,Z)


% -------------------------------------------------------------------------
% FUNCTION INPUT
% -------------------------------------------------------------------------

% x_in
%   Type: Double
%   Size: Scalar
%   Description: Dimension 1 coordinate for interpolation.

% y_in
%   Type: Double
%   Size: Scalar
%   Description: Dimension 2 coordinate for interpolation.

% Z
%   Type: Double
%   Size: {2,2}
%   Description: Surface Z values at nodal values in master cell.

% SAMPLE CODE TO EXTRACT LOCAL MASTER CELL VALUES OF SURFACE Z:
% x_lo = floor(x);
% y_lo = floor(y);
% x_Interp = fGetMasterInterpValue(x,y,Z(x_lo:x_lo+1,y_lo:y_lo+1);


% -------------------------------------------------------------------------
% FUNCTION OUTPUT
% -------------------------------------------------------------------------

% z_out
%   Type: Double
%   Size: Scalar

% -------------------------------------------------------------------------
% FUNCTION CODE
% -------------------------------------------------------------------------

% Get the Master Cell Coordinates
a = x_in - floor(x_in);
b = y_in - floor(y_in);

% Get the Nodal Values and Weights
z = [Z(1,1), Z(2,1), Z(2,2), Z(1,2)];
w = [(1-a)*(1-b); a*(1-b); a*b; (1-a)*b];

% Get the Interpolation Values
z_out = z * w;