function [label D0 prop_ev]= greedy_SCU2(adjacencyMatrixstore, datastore);
% The algorithm finds an approximately minimum Dominating set in a directed
% graph using greedy heuristics
datastore=datastore';

G=adjacencyMatrixstore;

N = length(G);
label = zeros(N,1);
U = [];
P = [];
D0_acum=[];
prop_ev_acum=[];
media_acum=[];
desv_acum=[];

outDegree = sum(G,2);

[Max loc] = max(outDegree);

% Nodos que aún no han sido cubiertos
remain = 1:N;

while (~isempty(remain)& sum(outDegree)~=0)

    % Now pick the node with max cover and assign it to Update
    U = union(U,loc);
% % % % %     P=union(P,loc);
%     v_weight1(loc) = 0;
%     v_weight2(loc) = 0;
    % Busca los vecinos que tiene el nodo seleccionado como U
%     nbr = find(e_weight(loc,:) ~= 0);
    nbr = find(G(loc,:) ~= 0);
%     v_weight1(nbr) = 0;
%     v_weight2(nbr) = 0;
    
        
    % Pone como Predict los vecinos del set cover seleccionado
    P = union(P,nbr);
    tam=size(P);
    if(tam(1)>tam(2))
    P=P';
    end
% % % % %     U = union(U,nbr);
    % pone a 0 las posicinos de la matriz de Adj de U y P elegidos 
%     e_weight = (v_weight1'*v_weight2).*G;
    G([loc nbr],:)=0;
    G(:,[loc nbr])=0;
    
    outDegree = sum(G,2);
       
    [Max loc] = max(outDegree);
    
    
    remain = setdiff(remain,[P U]);

end

% select the remaining ones into evens
isolated = remain;
U = union(U, isolated);
% % % % % P = union(P, isolated);


label(U)=-1;
label(P)=1;
[media desv D0]=calcula_D0 (adjacencyMatrixstore, label, datastore, P);
D0_acum=[D0_acum D0];
prop_ev=length(U)/N;
prop_ev_acum=[prop_ev_acum prop_ev];

media_acum=[media_acum media];
desv_acum=[desv_acum desv];


clear G

label(U)=-1;
label(P)=1;
label=int8(label);





















