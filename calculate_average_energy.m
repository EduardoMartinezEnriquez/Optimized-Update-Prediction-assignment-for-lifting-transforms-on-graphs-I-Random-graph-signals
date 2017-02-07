function [energia_media]=calculate_average_energy(label,coeffs)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function calculates the average energy
%     
%     GSP toolbox is used in this script. GSP is a Free software, released under 
%     the GNU General Public License (GPLv3). Please, download the GSPBox for Windows at 
%     https://lts2.epfl.ch/gsp/ and type >>gsp_install from matlab to be able to run this script
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

odds=find(label==1);
energia=sum((coeffs(odds)).^2);
energia_media=sum((coeffs(odds)).^2)/length(odds);
length(odds);


