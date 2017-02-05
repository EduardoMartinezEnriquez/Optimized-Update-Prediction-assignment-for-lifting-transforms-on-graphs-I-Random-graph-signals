%% This function implements  a Greedy eo-splitter algorithm given by C.P.
%% Hsu in 'Minimum Via Topological Routing' IEEE trans on Comp-Aided design
%% oct 1983. The goal is to find a bipartite subgraph G1 = (V,W) of a given Graph G =
%% (V, E)
% Created by Sunil Narang: July 12, 09
function [label D0_acum prop_ev_acum media_acum desv_acum media_MAXCUT desv_MAXCUT D0_MAXCUT RMS_MAXCUT V1 mean_Degree_acum dev_Degree_acum] = greedy_MAXCUT(adjacencyMatrixstore, datastore)

N = length(adjacencyMatrixstore);
deg = sum(adjacencyMatrixstore,2);

G=adjacencyMatrixstore;
% Assign node gains. Gain of a node v is sum of edge weights
% incident upon it.
Gain = sum(G,2);

% Greedy maximization step

V1 = [];
V2 = 1:N;
D0_acum=[];
prop_ev_acum=[];
media_acum=[];
desv_acum=[];
mean_Degree_acum=[];
dev_Degree_acum=[];

label = zeros(N,1);
[gain index] = max(Gain);

while gain > 0
    V1 = union(V1,index);
    V2 = setdiff(V2, index);
    G(index,:)= -G(index,:);
    G(:,index) = -G(:,index);
    Gain = sum(G,2);
    [gain index] = max(Gain);
    
label(V1) = -1;
label(V2) = 1;   
[media desv D0 mean_Degree dev_Degree]=calculate_energy_and_degree (adjacencyMatrixstore, label, datastore,V2)
D0_acum=[D0_acum D0];
prop_ev=length(V1)/N;
prop_ev_acum=[prop_ev_acum prop_ev];
mean_Degree_acum=[mean_Degree_acum mean_Degree];
dev_Degree_acum=[dev_Degree_acum dev_Degree];

end
label = zeros(N,1);

label(V1) = -1;
label(V2) = 1;

label=int8(label);

[media_MAXCUT desv_MAXCUT D0_MAXCUT]=calculate_energy_and_degree(adjacencyMatrixstore, label, datastore,V2)
RMS_MAXCUT=sqrt(D0);



