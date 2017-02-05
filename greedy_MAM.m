function [U_set P_set D0_acum prop_ev_acum mean_Degree_acum dev_Degree_acum] = greedy_MAM(Q, var_ep,var_et,nu_et,label,W,c,x,restriction)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GREEDY ALGORITHM FOR THE PROPOSED (MAM) UPA SOLUTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

D0_acum=[];
prop_ev_acum=[];
mean_Degree_acum=[];
dev_Degree_acum=[];

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
    

dif_error=Error_tot_before-Error_tot_after; % THETA IN THE PAPER.

[selected best]=max(dif_error);   % MAXIMIZE THE VALUE OF THETA.
U_set=union(U_set, P_set(best));
P_set=setdiff(P_set,P_set(best));

label(U_set)=-1;
label(P_set)=1;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   ERROR EVALUATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[media desv D0 mean_Degree dev_Degree]=calculate_energy_and_degree (W, label, x,P_set);
D0_acum=[D0_acum D0];
prop_ev=length(U_set)/NoOfSensors;
prop_ev_acum=[prop_ev_acum prop_ev];

mean_Degree_acum=[mean_Degree_acum mean_Degree];

dev_Degree_acum=[dev_Degree_acum dev_Degree];




end