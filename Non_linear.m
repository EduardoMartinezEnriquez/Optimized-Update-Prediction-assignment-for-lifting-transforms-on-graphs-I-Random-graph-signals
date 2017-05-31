function [reconst_5_perc,reconst_10_perc,reconst_20_perc,reconst_30_perc,reconst_40_perc,reconst_50_perc] =Non_linear(U_set,NoOfSensors,x_r,size_block,ver_block,hor_block,reconst_5_perc,reconst_10_perc,reconst_20_perc,reconst_30_perc,reconst_40_perc,reconst_50_perc)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function stores the image from the inverse transform reconstructed
% from the UPA when it has a 5%, 10%, 20%, 30%, 40 % and 50% of U nodes.
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


aux=[1:NoOfSensors]/NoOfSensors;
% 0.05
aux2=abs(aux-0.05);
[a b]=min(aux2);
thresh005=aux(b);
% 0.1
aux2=abs(aux-0.1);
[a b]=min(aux2);
thresh01=aux(b);
% 0.2
aux2=abs(aux-0.2);
[a b]=min(aux2);
thresh02=aux(b);
% 0.3
aux2=abs(aux-0.3);
[a b]=min(aux2);
thresh03=aux(b);
% 0.4
aux2=abs(aux-0.4);
[a b]=min(aux2);
thresh04=aux(b);
% 0.5
aux2=abs(aux-0.5);
[a b]=min(aux2);
thresh05=aux(b);


if (length(U_set)/NoOfSensors==thresh005)
    A=reshape(x_r, size_block,size_block);
    B=A';
    reconst_5_perc(size_block*(ver_block-1)+1:size_block*(ver_block), size_block*(hor_block-1)+1:size_block*(hor_block))=B;
end

if (length(U_set)/NoOfSensors==thresh01)
    A=reshape(x_r, size_block,size_block);
    B=A';
    reconst_10_perc(size_block*(ver_block-1)+1:size_block*(ver_block), size_block*(hor_block-1)+1:size_block*(hor_block))=B;
end

 if (length(U_set)/NoOfSensors==thresh02)
    A=reshape(x_r, size_block,size_block);
    B=A';
    reconst_20_perc(size_block*(ver_block-1)+1:size_block*(ver_block), size_block*(hor_block-1)+1:size_block*(hor_block))=B;
 end

if (length(U_set)/NoOfSensors==thresh03)
    A=reshape(x_r, size_block,size_block);
    B=A';
    reconst_30_perc(size_block*(ver_block-1)+1:size_block*(ver_block), size_block*(hor_block-1)+1:size_block*(hor_block))=B;
end


if (length(U_set)/NoOfSensors==thresh04)   
    A=reshape(x_r, size_block,size_block);
    B=A';
    reconst_40_perc(size_block*(ver_block-1)+1:size_block*(ver_block), size_block*(hor_block-1)+1:size_block*(hor_block))=B;
end

if (length(U_set)/NoOfSensors==thresh05)
    A=reshape(x_r, size_block,size_block);
    B=A';
    reconst_50_perc(size_block*(ver_block-1)+1:size_block*(ver_block), size_block*(hor_block-1)+1:size_block*(hor_block))=B;
end

end

