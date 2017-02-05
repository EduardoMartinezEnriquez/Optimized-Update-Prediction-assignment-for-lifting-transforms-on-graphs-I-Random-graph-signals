function [P_filters] = obtain_P_filters(A_odds)
% primero normaliza por filas a la suma de todos los pesos
C=sum(A_odds,2);
D=C==0;
G=C+D;
F=diag(G)\A_odds;
P_filters=F;
% % % % % %filtros P por columnas
% % % % % F=F';
% % % % % 
% % % % % d=sparse(length(A_odds),1);
% % % % % d(O)=1;
% % % % % B=diag(d) ;%matriz sparse con la diagonal principal d
% % % % % P_filters=-F+B;
end

