function [Gx] = eeg_interp_sph_spline_g(X)
% Solve Eq. 3 Perrin et al. (1989)
%
% g(x) = 1/(4*pi) * (for n=1:inf, sum = sum + ( ( (2*n+1)/(n^m * (n+1)^m) ) * Pn(x) ) );
%
% where x is the cosine between two points on a sphere,
% m is a constant > 1 and Pn(x) is the nth degree Legendre
% polynomial.  Perrin et al. (1989) evaluated m=1:6 and 
% recommend m=4, for which the first 7 terms of Pn(x) 
% are sufficient to obtain a precision of 10^-6 for g(x)

fprintf('...calculating g(x)\n');

m = 4;
N = 7;

n = [1:N]';
Series = (2*n + 1) ./ (n.^m .* (n+1).^m);
%fprintf('%12.10f  ',Series) % note how Series diminishes quickly
%0.1875000000  0.0038580247  0.0003375772  0.0000562500  
%0.0000135802  0.0000041778  0.0000015252


% Perrin et al. (1989) recommend tabulation of g(x) for
% x = linspace(-1,1,2000) to be used as a lookup given actual
% values for cos(Ei,Ej).
if isempty(X),
  error('...cosine matrix is empty.\n');
  %msg = sprintf('...cosine matrix empty, generating X.\n');
  %warning(msg);
  %X = linspace(-1,1,2000)';
end

Gx = zeros(size(X));

for i = 1:size(X,1),
  for j = 1:size(X,2),
    
    % P7x is a 8x1 column array, starting at P0x
    P7x = LegendreP(N,X(i,j));  % see function below
    
    Gx(i,j) = (1/(4*pi)) * dot( Series, P7x(2:end) );
    
  end
end

return
