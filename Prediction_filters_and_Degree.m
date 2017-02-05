function [p_n Degree]=Prediction_filters_and_Degree(A, Nn, n, NoOfSensors)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate the predictions filters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Nn ---> Vector with neighbors
% n---> Current node

p_n = zeros(NoOfSensors,1);

% Find the weights of the neighbors of node n (Nn) in the Adjacency matrix

p_n(Nn)=A(n,Nn);

Degree=sum(p_n);
% Normalization
p_n(Nn)=p_n(Nn)*(1/sum(p_n));



end





