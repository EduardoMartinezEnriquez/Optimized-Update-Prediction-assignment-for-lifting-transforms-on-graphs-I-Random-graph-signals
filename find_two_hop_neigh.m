function [Neigh_two_hop]=find_two_hop_neigh(A,NoOfSensors)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function calculates the two-hop neighborhood of every node in the 
% Adjacency matrix A
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

Neigh_two_hop=cell(NoOfSensors,1);


for i=1:NoOfSensors
    
    a=find(A(i,:)~=0);

    for j=1:length(a)
        et=a(j);
        b=find(A(et,:)~=0);
        Neigh_two_hop{i}=[Neigh_two_hop{i} b et];

    end
Neigh_two_hop{i}=unique(Neigh_two_hop{i});

end

    
    