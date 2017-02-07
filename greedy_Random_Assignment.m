
function [label D0_acum prop_ev_acum media_acum desv_acum] = greedy_Random_Assignment(adjacencyMatrixstore,  datastore,restriction)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GREEDY ALGORITHM FOR THE RANDOM UPA SOLUTION
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
[media desv D0]=calculate_energy_and_degree (adjacencyMatrixstore, label, datastore,V2)
D0_acum=[D0_acum D0];
prop_ev=length(V1)/N;
prop_ev_acum=[prop_ev_acum prop_ev];

end
label = zeros(N,1);

label(V1) = -1;
label(V2) = 1;

label=int8(label);





