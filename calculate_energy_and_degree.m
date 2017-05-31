function [media desv D0 mean_Degree dev_Degree coeffs Vecinos_Evens]=calculate_energy_and_degree (A_fin, label, datastore,P)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function calculates the error in the average prediction error and degree
% of a given U/P configuration on the graph
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


NoOfSensors=length(A_fin);
[Vecinos_Odds Vecinos_Evens Vecinos_Evens_de_Evens]=find_neighbors(A_fin ,label,NoOfSensors);

[media desv]=num_neighbors(P, Vecinos_Evens);

coeffs=datastore;
xq=datastore;
Degree_vector=[];

for n = 1:NoOfSensors

    
    if label(n) == 1  % n isa P node
        % First, compute detail coeff of n
      
        Nn = Vecinos_Evens{n};
        if ~isempty(Nn) %si there is a U nighbor

               [p_n Degree]=Prediction_filters_and_Degree(A_fin, Nn, n, NoOfSensors); 

                    x_N = xq(Nn);
                    x_hat(n) = p_n(Nn)'*x_N;
                    
                 
                    coeffs(n) = round(coeffs(n) - x_hat(n));
                                   


        Degree_vector=[Degree_vector Degree];
         
        
        else % if the P node does not have U neighbors, the degree with its U neighbors is 0
        Degree_vector=[Degree_vector 0];    
        end
        
           
    end
end


[D0]=calculate_average_energy(label,coeffs);


mean_Degree=mean(Degree_vector);
dev_Degree=std(Degree_vector);
