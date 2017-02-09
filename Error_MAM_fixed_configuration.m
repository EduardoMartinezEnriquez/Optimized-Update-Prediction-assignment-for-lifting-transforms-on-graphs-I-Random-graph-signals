function [ Error ] =Error_MAM_fixed_configuration(P_set,Vecinos_Evens,M,W,var_et,c)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function calculates the error in an exhaustive manner
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


parfor i=1:length(P_set)
P_node=P_set(i);
% U neighbors of node i    
Ui=Vecinos_Evens{P_node};
    
p_i=W(P_node,Ui);
p_i=p_i*(1/sum(p_i));
p_i=p_i';
%  p should be Uix1 

M_Ui=M(Ui,:); % M_Ui should be UixN
M_Ui_i=M_Ui(:,P_node); % M_Ui_i should be Uix1
M_Ui_i_c=M_Ui_i+c^2*ones(size(M_Ui_i));

M_Ui_Ui=M(Ui,Ui);
M_Ui_Ui_par=M_Ui_Ui+var_et*eye(size(M_Ui_Ui))+c^2*ones(size(M_Ui_Ui));

Error(i)=c^2+M(P_node,P_node)+var_et-2*p_i'*M_Ui_i_c+p_i'*M_Ui_Ui_par*p_i;
end

end

