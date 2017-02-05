
R = sprand(N,N,dens);
% MADE A SYMETRIC MATRIX
B=(R + R')/2
% REMOVE (PLACE ZEROS) MAIN DIAGONAL
B(1:(N+1):end)=0;
C=full(B)

% AVOID TO HAVE ISOLATED NODES
aux=sum(C,2);
zeros=find(aux==0);
C(zeros,:)=[];
C(:,zeros)=[];
[a b]=size(C)



data_store= round(normrnd(nu,des,a,1))




% para generar F tipos de pesos distintos, 
% generar F matrices y "sumarlas"

% ojo! si los tamaños orignial y final no coinciden, ojo a eliminar nodos y
% la generación de datos.