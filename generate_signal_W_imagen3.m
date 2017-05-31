function [W,data]=generate_signal_W_imagen3(N_aux, imagen_aux) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function generates the weighted adjacency matrix
%
% References: "Optimized Update/Prediction Assignment for
% Lifting Transforms on Graphs", Eduardo Martinez-Enriquez, Jesus Cid-Sueiro, 
% Fernando Diaz-de-Maria, and Antonio Ortega
%
% Author:
%  - Eduardo Martinez-Enriquez <emenriquez@tsc.uc3m.es>
% 
%     Copyright (C)  2017 Eduardo Martínez-Enríquez.
% 
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Example; 8 connected (also 4 connected)
% square images of size N_aux X N_aux
N=N_aux;
M=N_aux;

figure, imshow(imagen_aux,[0 256])

[ii jj] = sparse_adj_matrix([N M], 1, inf);
[r c]=ndgrid(1:N,1:M);
A = sparse(ii, jj, ones(1,numel(ii)), N*M, N*M);

W=A;

B_aux=imagen_aux';
data=B_aux(:);
data=double(data);

%NORMALIZATION FACTOR CALCULATION
vect_estimation=[];

for i=1:length(data) 
    aux=find(A(i,:)~=0);
    vect_estimation=[vect_estimation;data(aux)-data(i)];
end
sigma=std(vect_estimation);


for i=1:length(data) 
    aux=find(A(i,:)~=0);
    W(i,aux)=exp(-(abs(data(aux)-data(i))).^2./(2*sigma^2));
    
    % remove auto-loops
    W(i,i)=0;
end
