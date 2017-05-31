function [U_set P_set D0_acum prop_ev_acum reconst_5_perc reconst_10_perc reconst_20_perc reconst_30_perc reconst_40_perc reconst_50_perc] = MAM_error3(Q, var_ep,var_et,nu_et,label,W,c,x,size_block,ver_block,hor_block,reconst_5_perc,reconst_10_perc,reconst_20_perc,reconst_30_perc,reconst_40_perc,reconst_50_perc, restriction)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GREEDY ALGORITHM FOR THE PROPOSED (MAM) UPA SOLUTION, QUANTIFICATION (SET
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

warning('off')

D0_acum=[];
prop_ev_acum=[];

NoOfSensors=length(W);

M=var_ep*Q*Q';

U_set=find(label==-1);
P_set=find(label==1);
Error=zeros(length(P_set),1);
Error_tot_before=zeros(length(P_set),1);
Error_tot_after=zeros(length(P_set),1);

% Find two-hop neighbors
[Neigh_two_hop]=find_two_hop_neigh(W,NoOfSensors);


while length(U_set)/NoOfSensors<restriction;
   

Error_tot_before=zeros(length(P_set),1);
Error_tot_after=zeros(length(P_set),1);  
    
parfor k=1:length(P_set)
node=P_set(k);
Neigh_two_hop_closed=union(Neigh_two_hop{node},node);
[P_set_before index_P index_P_2]=intersect(P_set,Neigh_two_hop_closed);
[U_set_before index_U index_U_2]=intersect(U_set,Neigh_two_hop_closed);

W_red=W(Neigh_two_hop_closed,Neigh_two_hop_closed);
A_odds=W_red;
A_odds(:,index_P_2)=0;
A_odds(index_U_2,:)=0;
[P_filters] = obtain_P_filters(A_odds);
M_aux=M(Neigh_two_hop_closed,Neigh_two_hop_closed);

[Error_before_matrix] =Error_MAM_fixed_configuration_matrix3(P_filters,M_aux,var_et,c);
Error_before_matrix=Error_before_matrix(index_P_2);
Error_tot_before(k)=sum(Error_before_matrix);


node_test=find(Neigh_two_hop_closed==node);

A_odds(:,node_test)=W_red(:,node_test);
A_odds(node_test,:)=0;
[P_filters] = obtain_P_filters(A_odds);
[Error_after_matrix] =Error_MAM_fixed_configuration_matrix3(P_filters,M_aux,var_et,c);
Error_after_matrix=Error_after_matrix(setdiff(index_P_2,node_test));
Error_tot_after(k)=sum(Error_after_matrix);

end
    

dif_error=Error_tot_before-Error_tot_after;  % THETA IN THE PAPER.


[selected best]=max(dif_error); % MAXIMIZE THE VALUE OF THETA.
U_set=union(U_set, P_set(best));
P_set=setdiff(P_set,P_set(best));

label(U_set)=-1;
label(P_set)=1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   ERROR EVALUATION AND FORWARD TRANSFORM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[media desv D0 mean_Degree dev_Degree coeffs Vecinos_Evens]=calculate_energy_and_degree (W, label, x,P_set);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% QUANTIFICATION AND INVERSE TRANSFORM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[x_r] = Quantification_and_inverse_transform(coeffs,P_set,Vecinos_Evens,W,label);


[reconst_5_perc,reconst_10_perc,reconst_20_perc,reconst_30_perc,reconst_40_perc,reconst_50_perc] =Non_linear(U_set,NoOfSensors,x_r,size_block,ver_block,hor_block,reconst_5_perc,reconst_10_perc,reconst_20_perc,reconst_30_perc,reconst_40_perc,reconst_50_perc);

D0_acum=[D0_acum D0];
prop_ev=length(U_set)/NoOfSensors;
prop_ev_acum=[prop_ev_acum prop_ev];




end