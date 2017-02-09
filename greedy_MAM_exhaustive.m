function [U_set P_set D0_acum prop_ev_acum mean_Degree_acum dev_Degree_acum] = Greedy_MAM_exhaustive(Q, var_ep,var_et,nu_et,label,W,c,x,restriction)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GREEDY EXHAUSTIVE ALGORITHM FOR THE PROPOSED (MAM) UPA SOLUTION
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
mean_Degree_acum=[];
dev_Degree_acum=[];

NoOfSensors=length(W);
M=var_ep*Q*Q';

[Vecinos_Odds Vecinos_Evens Vecinos_Evens_de_Evens]=find_neighbors(W ,label,NoOfSensors);

U_set=find(label==-1);
P_set=find(label==1);
Error=zeros(length(P_set),1);
Error_tot=zeros(length(P_set),1);


while length(U_set)/NoOfSensors<restriction;
        

parfor k=1:length(P_set)
U_set_aux=union(U_set, P_set(k));
P_set_aux=setdiff(P_set,P_set(k));
label(U_set_aux)=-1;
label(P_set_aux)=1;
label=int8(label);
[Vecinos_Odds Vecinos_Evens Vecinos_Evens_de_Evens]=find_neighbors(W ,label,NoOfSensors);

[ Error ] =Error_MAM_fixed_configuration(P_set_aux,Vecinos_Evens,M,W,var_et,c);
Error_tot(k)=sum(Error);

end

[selected best]=min(Error_tot);
U_set=union(U_set, P_set(best));
P_set=setdiff(P_set,P_set(best));
label(U_set)=-1;
label(P_set)=1;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   ERROR EVALUATION (COMMENT TO MEASURE COMPUTATIONAL COMPLEXITY)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[media desv D0 mean_Degree dev_Degree]=calculate_energy_and_degree (W, label, x,P_set)
D0_acum=[D0_acum D0];
prop_ev=length(U_set)/NoOfSensors;
prop_ev_acum=[prop_ev_acum prop_ev];

mean_Degree_acum=[mean_Degree_acum mean_Degree];

dev_Degree_acum=[dev_Degree_acum dev_Degree];



end