function x_r = InverseTransform(coeffs_umb,Vecinos_Evens, A_fin, label);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function performs the inverse lifting transform
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x_r =coeffs_umb;

NoOfSensors=length(A_fin);

for n=1:NoOfSensors
    if label(n) == 1  % n is a P node            
            Nn = Vecinos_Evens{n};
            if ~isempty(Nn)


                   [p_n Degree]=Prediction_filters_and_Degree(A_fin, Nn, n, NoOfSensors);
                   
                    x_N = x_r(Nn);

                    x_hat(n) = p_n(Nn)'*x_N;
           
                    x_r(n) = round(x_r(n) + x_hat(n));

            end

        
     end
end