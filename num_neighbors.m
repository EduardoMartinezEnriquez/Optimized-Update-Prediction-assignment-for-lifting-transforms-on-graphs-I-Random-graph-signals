function [media desv]=num_neighbors(O, Vecinos_Evens)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function returns the number of neighbors (mean and standard deviation) 
% of every node in P.
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

NV=[];

for i=1:length(O)
  
    
    a=Vecinos_Evens{O(i)};
    NV=[NV length(a)];
end
find(NV==0);
media=mean(NV);
desv=std(NV);