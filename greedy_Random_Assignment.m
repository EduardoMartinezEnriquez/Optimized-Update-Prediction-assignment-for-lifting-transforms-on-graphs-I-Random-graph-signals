
function [label D0_acum prop_ev_acum media_acum desv_acum] = greedy_Random_Assignment(adjacencyMatrixstore,  datastore,restriction)

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





