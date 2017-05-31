
function [label D0_acum prop_ev_acum media_acum desv_acum reconst_5_perc reconst_10_perc reconst_20_perc reconst_30_perc reconst_40_perc reconst_50_perc] = greedy_Random_Assignment_image(adjacencyMatrixstore,  datastore,reconst_5_perc,reconst_10_perc,reconst_20_perc,reconst_30_perc,reconst_40_perc,reconst_50_perc,size_block,ver_block,hor_block, restriction)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GREEDY ALGORITHM FOR THE RANDOM UPA SOLUTION, QUANTIFICATION (SET
% THE P COEFFICIENTS TO ZERO) AND INVERSE TRANSFORM: RECONSTRUCTION OF THE
% IMAGE FROM A PERCENTAGE OF U NODES
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

D0_acum=[];
prop_ev_acum=[];
N = length(adjacencyMatrixstore);
deg = sum(adjacencyMatrixstore,2);



G=adjacencyMatrixstore;

V1 = [];
V2 = 1:N;
D0_acum=[];
prop_ev_acum=[];
media_acum=[];
desv_acum=[];
label = zeros(N,1);

index=randperm(N, N);
limit=round(N*restriction);

for i=1:limit
   
    aux=index(i);
    V1 = union(V1,aux);
    V2 = setdiff(V2,aux);
   
label(V1) = -1;
label(V2) = 1;   
[media desv D0 mean_Degree dev_Degree coeffs Vecinos_Evens]=calculate_energy_and_degree (adjacencyMatrixstore, label, datastore,V2);

%%%%%%%%%%%%%%%%%%%%%%
% QUANTIFICATION
%%%%%%%%%%%%%%%%%%%%%%

[x_r] = Quantification_and_inverse_transform(coeffs,V2,Vecinos_Evens, adjacencyMatrixstore,label);

[reconst_5_perc,reconst_10_perc,reconst_20_perc,reconst_30_perc,reconst_40_perc,reconst_50_perc] =Non_linear(V1,N,x_r,size_block,ver_block,hor_block,reconst_5_perc,reconst_10_perc,reconst_20_perc,reconst_30_perc,reconst_40_perc,reconst_50_perc);




D0_acum=[D0_acum D0];
prop_ev=length(V1)/N;
prop_ev_acum=[prop_ev_acum prop_ev];

end
label = zeros(N,1);

label(V1) = -1;
label(V2) = 1;

label=int8(label);





