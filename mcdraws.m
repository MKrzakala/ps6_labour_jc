function [y,ind] = mcdraws(S,P,T,y0,burn)
% ---------------------------------------------------
% - Inputs:
%     - S: state space grid
%     - P: transition function
%     - T: number of periods to simulate
%     - y0: initial draw (optional)
%     - burn: burn-in periods (optional, default=500)
% - Output:
%     - y: Markov chain draws
%     - ind: indexes
% ---------------------------------------------------

% If not specified, set number of burn-in periods to default value (500)
if nargin<5
    burn=500;
end

ind=zeros(T+burn,1); y=zeros(T+burn,1);   % Preallocate arrays

% If not specified, or if input is out of boundaries, use middle point to initialize grid
if nargin<4 || nargin>3 && (y0>max(S) || y0<min(S)) 
    ind(1)=floor(length(S)/2);               
else                                                  
	[~,ind(1)]=min(abs(S-y0));    % Otherwise, use closest point to the one provided                     
end                                                  

y(1) = S(ind(1)); % Initialize chain

for i=2:T+burn
    ind(i) = find(cumsum(P(ind(i-1),:))>rand(),1);
    y(i) = S(ind(i));
end

y = y(burn+1:end);
ind = ind(burn+1:end);