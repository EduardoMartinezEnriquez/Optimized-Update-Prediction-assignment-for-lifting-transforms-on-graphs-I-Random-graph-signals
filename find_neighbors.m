function [Vecinos_Odds Vecinos_Evens Vecinos_Evens_de_Evens]=find_neighbors(A,label,NoOfSensors)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function calculates the neighborhood and the label of each neighbor of every
% node in the adjacency matrix A
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

Vecinos_Evens=cell(NoOfSensors,1);
Vecinos_Odds=cell(NoOfSensors,1);
Vecinos_Evens_de_Evens=cell(NoOfSensors,1); 

for i=1:NoOfSensors
    
    % Sensor i
    % find connections with i
    a=find(A(i,:)~=0);

    if (label(i)==-1) %if node is U
        
    
    for j=1:length(a)
        et=a(j);
        
        if (label(et)==1) %if connection is P
        Vecinos_Odds{i}=[Vecinos_Odds{i} et];
        end
        
        if(label(et)==-1) %if connection is u with othe U    
        Vecinos_Evens_de_Evens{i}=[Vecinos_Evens_de_Evens{i} et];
        end

    end

    else %if node is P
    for j=1:length(a)
        et=a(j);

        if (label(et)==-1) %if connection is U
        Vecinos_Evens{i}=[Vecinos_Evens{i} et];
        end
    end 
    
    end

end

    
    