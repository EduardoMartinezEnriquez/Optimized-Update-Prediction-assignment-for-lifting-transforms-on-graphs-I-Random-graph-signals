%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script takes an image, constructs the corresponding graph,
% and obtains the mean prediction error (detail coefficient energy) when
% three different Update/Prediction solutions are used, namely: MAM
% solution (proposed), WMC solution and random assignment. The script also
% reconstructs the image from the UPA selected applying the inverse lifting
% transform
% 
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
close all
clear all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   INPUT IMAGE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

image=imread('lena_md.png','png');
% image=imread('cameraman_sm.png','png');
% image=imread('barbara.png','png');

  if length(size(image))==3
        image= rgb2gray(image);
  end

% VARIABLES INITIALIZATION  
reconst_5_perc=zeros(size(image));
reconst_10_perc=zeros(size(image));
reconst_20_perc=zeros(size(image));
reconst_30_perc=zeros(size(image));
reconst_40_perc=zeros(size(image));
reconst_50_perc=zeros(size(image));
reconst_5_percWMC=zeros(size(image));
reconst_10_percWMC=zeros(size(image));
reconst_20_percWMC=zeros(size(image));
reconst_30_percWMC=zeros(size(image));
reconst_40_percWMC=zeros(size(image));
reconst_50_percWMC=zeros(size(image));
reconst_5_percRAN=zeros(size(image));
reconst_10_percRAN=zeros(size(image));
reconst_20_percRAN=zeros(size(image));
reconst_30_percRAN=zeros(size(image));
reconst_40_percRAN=zeros(size(image));
reconst_50_percRAN=zeros(size(image));

figure
imshow(image,[]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MODEL PARAMETERS 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nu_ep=0;
nu_et=0;
var_et=10;
var_ep=var(double(image(:)));
c=mean(double(image(:)));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% WORK IN BLOCKS TO REDUCE THE COMPUTATIONAL COMPLEXITY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % size_block=25; % 9*9 blocks of 25x25 in Lena (225x225); 5 blocks 45
% Configuration used in the paper:
size_block=32; % 4*4 blocks of 32x32 in Lena and cameraman (128x128); 16*16 blocks of 32x32 in Barbara (512x512);


% MAXIMUM PERCENTAGE OF |U| NEIGHBORS ALLOWED.
restriction=0.7;

N=size_block^2;
num_blocks=length(image)/size_block;
num_it=num_blocks^2;
it=1;

prop_ev_acum_MC_matrix=zeros(num_it,N);
prop_ev_acum_MAM_matrix=zeros(num_it,N);
prop_ev_acum_RAN_matrix=zeros(num_it,N);
D0_acum_MC_matrix=zeros(num_it,N);
D0_acum_MAM_matrix=zeros(num_it,N);
D0_acum_RAN_matrix=zeros(num_it,N);


% % % % % LOOP OVER BLOCKS

for ver_block=1:num_blocks
    for hor_block=1:num_blocks


    partial_image=image(size_block*(ver_block-1)+1:size_block*(ver_block), size_block*(hor_block-1)+1:size_block*(hor_block));
     

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GENERATE THE WEIGHTED GRAPH 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
[W,x]=generate_signal_W_imagen3(size_block, partial_image);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GENERATE Q MATRIX
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[Q] = Generate_Q_matrix(W);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GREEDY ALGORITHM FOR THE PROPOSED (MAM) UPA SOLUTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
label=ones(N,1);

tic

[U_set P_set D0_acum  prop_ev_acum reconst_5_perc reconst_10_perc reconst_20_perc reconst_30_perc reconst_40_perc reconst_50_perc] = greedy_MAM_image(Q, var_ep,var_et,nu_et,label,W,c,x,size_block,ver_block,hor_block,reconst_5_perc,reconst_10_perc,reconst_20_perc,reconst_30_perc,reconst_40_perc,reconst_50_perc, restriction);

a=toc


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GREEDY ALGORITHM FOR THE WMC UPA SOLUTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[label_MC D0_acum_MC prop_ev_acum_MC media_acum_MC desv_acum_MC media_MAXCUT desv_MAXCUT D0_MAXCUT RMS_MAXCUT reconst_5_percWMC reconst_10_percWMC reconst_20_percWMC reconst_30_percWMC reconst_40_percWMC reconst_50_percWMC] = greedy_MAXCUT_image(W,1, x,reconst_5_percWMC,reconst_10_percWMC,reconst_20_percWMC,reconst_30_percWMC,reconst_40_percWMC,reconst_50_percWMC,size_block,ver_block,hor_block);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GREEDY ALGORITHM FOR THE RANDOM UPA SOLUTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[label_RAN D0_acum_RAN prop_ev_acum_RAN media_acum_RAN desv_acum_RAN reconst_5_percRAN reconst_10_percRAN reconst_20_percRAN reconst_30_percRAN reconst_40_percRAN reconst_50_percRAN] = greedy_Random_Assignment_image(W,  x,reconst_5_percRAN,reconst_10_percRAN,reconst_20_percRAN,reconst_30_percRAN,reconst_40_percRAN,reconst_50_percRAN,size_block,ver_block,hor_block, restriction);

a=min(prop_ev_acum);

aux=abs(prop_ev_acum_RAN-a);
[aux2 ind]=min(aux);

aux=abs(prop_ev_acum_MC-a);
[aux2 ind2]=min(aux);

figure, plot(prop_ev_acum,sqrt(D0_acum));
hold on
plot(prop_ev_acum_RAN(ind:end),sqrt(D0_acum_RAN(ind:end)),'y')
plot(prop_ev_acum_MC(ind2:end),sqrt(D0_acum_MC(ind2:end)),'r')
close all

prop_ev_acum_MAM_matrix(it,1:length(prop_ev_acum))=prop_ev_acum;
prop_ev_acum_MC_matrix(it,1:length(prop_ev_acum_MC))=prop_ev_acum_MC;
prop_ev_acum_RAN_matrix(it,1:length(prop_ev_acum_RAN))=prop_ev_acum_RAN;

D0_acum_MAM_matrix(it,1:length(prop_ev_acum))=D0_acum;
D0_acum_MC_matrix(it,1:length(prop_ev_acum_MC))=D0_acum_MC;
D0_acum_RAN_matrix(it,1:length(prop_ev_acum_RAN))=D0_acum_RAN;


it=it+1;
close all
    end
end


% %    REPRESENTATION OF THE RECONSTRUCTED IMAGES FROM A PERCENTAGE OF U
% %    COEFFICIENTS.
figure
imshow(reconst_5_percWMC,[])
title('Reconstruction of the test image with |U|=0.05N using WMC')
figure
imshow(reconst_5_perc,[])
title('Reconstruction of the test image with |U|=0.05N using WMC')
figure
imshow(reconst_10_percWMC,[])
title('Reconstruction of the test image with |U|=0.10N using WMC')
figure
imshow(reconst_10_perc,[])
title('Reconstruction of the test image with |U|=0.10N using WMC')
figure
imshow(reconst_20_percWMC,[])
title('Reconstruction of the test image with |U|=0.20N using WMC')
figure
imshow(reconst_20_perc,[])
title('Reconstruction of the test image with |U|=0.20N using WMC')
figure
imshow(reconst_30_percWMC,[])
title('Reconstruction of the test image with |U|=0.3N using WMC')
figure
imshow(reconst_30_perc,[])
title('Reconstruction of the test image with |U|=0.3N using WMC')
figure
imshow(reconst_40_percWMC,[])
title('Reconstruction of the test image with |U|=0.4N using WMC')
figure
imshow(reconst_40_perc,[])
title('Reconstruction of the test image with |U|=0.4N using WMC')



aux=prop_ev_acum_MC_matrix==0;
aux2=sum(aux,1);
aux3=find(aux2==0);
prop_ev_acum_MC_matrix=prop_ev_acum_MC_matrix(:,aux3);
D0_acum_MC_matrix=D0_acum_MC_matrix(:,aux3);
aux=prop_ev_acum_MAM_matrix==0;
aux2=sum(aux,1);
aux3=find(aux2==0);
prop_ev_acum_MAM_matrix=prop_ev_acum_MAM_matrix(:,aux3);
D0_acum_MAM_matrix=D0_acum_MAM_matrix(:,aux3);
aux=prop_ev_acum_RAN_matrix==0;
aux2=sum(aux,1);
aux3=find(aux2==0);
prop_ev_acum_RAN_matrix=prop_ev_acum_RAN_matrix(:,aux3);
D0_acum_RAN_matrix=D0_acum_RAN_matrix(:,aux3);

%INTERP TO PROMEDIATE

prom_RAN=mean(D0_acum_RAN_matrix,1);
prom_prop_ev_RAN=mean(prop_ev_acum_RAN_matrix,1);
prom_MC=mean(D0_acum_MC_matrix,1);
prom_prop_ev_MC=mean(prop_ev_acum_MC_matrix);
prom_MAM=mean(D0_acum_MAM_matrix,1);
prom_prop_ev_MAM=mean(prop_ev_acum_MAM_matrix);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REPRESENT AVERAGE VALUES (ACROSS BLOCKSS)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure
plot(prom_prop_ev_RAN, sqrt(prom_RAN),'y')
hold on
plot( prom_prop_ev_MC, sqrt(prom_MC), 'r')
plot( prom_prop_ev_MAM, sqrt(prom_MAM), 'b')
xlabel('|U|/N')
ylabel('E_{rms}')
legend('Random','WMC','Proposed')




