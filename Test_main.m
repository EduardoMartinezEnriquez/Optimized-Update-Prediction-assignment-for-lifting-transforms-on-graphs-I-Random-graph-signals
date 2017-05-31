%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script generates a random graph and random signal living on this graph
% and obtains the mean prediction error (detail coefficient energy) when
% three different Update/Prediction solutions are used, namely: MAM
% solution (proposed), WMC solution and random assignment. The script also
% calculates de mean degree and standard deviation of each solution.
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


close all
clear all


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   INPUT PARAMETERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% NUMBER OF NODES OF THE GRAPH
N=500;
%Choose the following value when working with Minnesota road graph
% N=2642;


% PARAMETERS FOR THE DATA GENERATION. THE DATA VALUES WILL BE RANDOMLY 
% TAKEN FROM A GAUSSIAN DISTRIBUTION WITH THE SPECIFIED PARAMETERS
nu_ep=0;
var_ep=400;
nu_et=0;
var_et=100;
c=100;

% NUMBER OF ITERATIONS (REALIZATIONS OF THE RANDOM GRAPH GENERATION)
num_it=100;

% MAXIMUM PERCENTAGE OF |U| NEIGHBORS ALLOWED.
restriction=0.7;


% VARIABLES INITIALIZATION

prop_ev_acum_MC_matrix=zeros(num_it,N);
prop_ev_acum_MAM_matrix=zeros(num_it,N);
prop_ev_acum_RAN_matrix=zeros(num_it,N);
prop_ev_acum_SCU_matrix=zeros(num_it,1);
D0_acum_MC_matrix=zeros(num_it,N);
D0_acum_MAM_matrix=zeros(num_it,N);
D0_acum_RAN_matrix=zeros(num_it,N);
D0_acum_SCU_matrix=zeros(num_it,1);
mean_Degree_acum_MC_matrix=zeros(num_it,N);
mean_Degree_acum_MAM_matrix=zeros(num_it,N);
dev_Degree_acum_MC_matrix=zeros(num_it,N);
dev_Degree_acum_MAM_matrix=zeros(num_it,N);
time_MAM=zeros(num_it,1);
time_WMC=zeros(num_it,1);


% LOOP NUMBER OF ITERATIONS (REALIZATIONS OF THE RANDOM GRAPH GENERATION)
for it=1:num_it

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   SELECT THE GRAPH TOPOLOGY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SELECT ONE OF THE FOLLOWING OPTIONS  TO GENERATE THE GRAPH (DECOMMENT THE
% CHOSEN OPTION), USING THE GSP TOOLBOX:
%     GSP The toolbox is used in this script. GSP is a Free software, released under 
%     the GNU General Public License (GPLv3). Please, download the GSPBox for Windows at 
%     https://lts2.epfl.ch/gsp/ and type >>gsp_install from matlab to be able to run this script



% Random Sensor Network; w=exp(-dist^2/med_dist^2)
G=gsp_sensor(N); 

% Community graph
% G=gsp_community(N);

% Minnesota graph
% connect=1;
% G=gsp_minnesota(connect); 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GENERATE Q MATRIX
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
W=G.W;
[Q] = Generate_Q_matrix(W);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GENERATE THE RANDOM GRAPH SIGNAL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[x] = Generate_signal(var_ep,nu_ep,var_et,nu_et,c, N,Q);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAPH REPRESENTATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DECOMMENT TO OBTAIN A GRAPH REPRESENTATION OF THE GRAPH SIGNAL.
param.bar=0;
% % % % % param.bar=1;
gsp_plot_signal(G,x,param);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GREEDY ALGORITHM FOR THE PROPOSED (MAM) UPA SOLUTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
label=ones(N,1); % WE START WITH EVERY NODE AS P NODE
tic
[U_set P_set D0_acum  prop_ev_acum mean_Degree_acum dev_Degree_acum]  = greedy_MAM(Q, var_ep,var_et,nu_et,label,W,c,x,restriction);
a=toc

time_per_node=a/length(U_set)
time_MAM(it)=time_per_node;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GREEDY EXHAUSTIVE ALGORITHM FOR THE PROPOSED (MAM) UPA SOLUTION 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Decomment to measure time when using a greedy exhaustive algorithm. The 
% energy results are the same than using greedy_MAM, but the algorithm is
% much slower

% % % % % label=ones(N,1); % WE START WITH EVERY NODE AS P NODE
% % % % % tic
% % % % % [U_set P_set D0_acum  prop_ev_acum mean_Degree_acum dev_Degree_acum]  = greedy_MAM_exhaustive(Q, var_ep,var_et,nu_et,label,W,c,x,restriction);
% % % % % a=toc
% % % % % 
% % % % % time_per_node=a/length(U_set)
% % % % % time_MAM(it)=time_per_node;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GREEDY ALGORITHM FOR THE WMC UPA SOLUTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tic
[label_MC D0_acum_MC prop_ev_acum_MC media_acum_MC desv_acum_MC media_MAXCUT desv_MAXCUT D0_MAXCUT RMS_MAXCUT U_set_MC mean_Degree_acumMC dev_Degree_acumMC] = greedy_MAXCUT(W, x);
a=toc
time_per_node_MC=a/length(U_set_MC)
time_WMC(it)=time_per_node_MC;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GREEDY ALGORITHM FOR THE RANDOM UPA SOLUTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[label_RAN D0_acum_RAN prop_ev_acum_RAN media_acum_RAN desv_acum_RAN] = greedy_Random_Assignment(W,  x,restriction);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RESULTS REPRESENTATION (E_rms AND DEGREE)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure, plot(prop_ev_acum,sqrt(D0_acum));
hold on
plot(prop_ev_acum_RAN,sqrt(D0_acum_RAN),'y')
plot(prop_ev_acum_MC,sqrt(D0_acum_MC),'r')
xlabel('|U|/N')
ylabel('E_{rms}')
legend('Proposed','Random','WMC')


figure
plot(prop_ev_acum,mean_Degree_acum,'b')
hold on
plot(prop_ev_acum,dev_Degree_acum,'.b')
hold on
plot(prop_ev_acum_MC,mean_Degree_acumMC,'r')
hold on
plot(prop_ev_acum_MC,dev_Degree_acumMC,'.r')
xlabel('|U|/N')
ylabel('Degree')
legend('\mu_{degree} Proposed','\sigma_{degree} Proposed','\mu_{degree} WMC','\sigma_{degree} WMC')
close all



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STORE THE RESULTS OF EVERY ITERATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
prop_ev_acum_MAM_matrix(it,1:length(prop_ev_acum))=prop_ev_acum;
prop_ev_acum_MC_matrix(it,1:length(prop_ev_acum_MC))=prop_ev_acum_MC;
prop_ev_acum_RAN_matrix(it,1:length(prop_ev_acum_RAN))=prop_ev_acum_RAN;
D0_acum_MAM_matrix(it,1:length(prop_ev_acum))=D0_acum;
D0_acum_MC_matrix(it,1:length(prop_ev_acum_MC))=D0_acum_MC;
D0_acum_RAN_matrix(it,1:length(prop_ev_acum_RAN))=D0_acum_RAN;
mean_Degree_acum_MAM_matrix(it,1:length(prop_ev_acum))=mean_Degree_acum;
mean_Degree_acum_MC_matrix(it,1:length(prop_ev_acum_MC))=mean_Degree_acumMC;
dev_Degree_acum_MAM_matrix(it,1:length(prop_ev_acum))=dev_Degree_acum;
dev_Degree_acum_MC_matrix(it,1:length(prop_ev_acum_MC))=dev_Degree_acumMC;

end


% FIND THE COMMON POINTS TO CALCULATE THE AVERAGE (E.G., MC ALGORITHM CAN
% STOP AT DIFFERENT U/N POINTS DEPENDING ON THE TOPOLOGY OF THE GRAPH)
aux=prop_ev_acum_MC_matrix==0;
aux2=sum(aux,1);
aux3=find(aux2==0);
prop_ev_acum_MC_matrix=prop_ev_acum_MC_matrix(:,aux3);
D0_acum_MC_matrix=D0_acum_MC_matrix(:,aux3);
mean_Degree_acum_MC_matrix=mean_Degree_acum_MC_matrix(:,aux3);
dev_Degree_acum_MC_matrix=dev_Degree_acum_MC_matrix(:,aux3);

aux=prop_ev_acum_MAM_matrix==0;
aux2=sum(aux,1);
aux3=find(aux2==0);
prop_ev_acum_MAM_matrix=prop_ev_acum_MAM_matrix(:,aux3);
D0_acum_MAM_matrix=D0_acum_MAM_matrix(:,aux3);
mean_Degree_acum_MAM_matrix=mean_Degree_acum_MAM_matrix(:,aux3);
dev_Degree_acum_MAM_matrix=dev_Degree_acum_MAM_matrix(:,aux3);

% 
aux=prop_ev_acum_RAN_matrix==0;
aux2=sum(aux,1);
aux3=find(aux2==0);
prop_ev_acum_RAN_matrix=prop_ev_acum_RAN_matrix(:,aux3);
D0_acum_RAN_matrix=D0_acum_RAN_matrix(:,aux3);


% CALCULATE THE AVERAGE OF THE num_it ITERATIONS

prom_RAN=mean(D0_acum_RAN_matrix,1);
prom_prop_ev_RAN=mean(prop_ev_acum_RAN_matrix,1);
prom_MC=mean(D0_acum_MC_matrix,1);
prom_prop_ev_MC=mean(prop_ev_acum_MC_matrix,1);
prom_MAM=mean(D0_acum_MAM_matrix,1);
prom_prop_ev_MAM=mean(prop_ev_acum_MAM_matrix,1);


prom_MC_Deg=mean(mean_Degree_acum_MC_matrix,1);
prom_MAM_Deg=mean(mean_Degree_acum_MAM_matrix,1);
prom_MC_dev_Deg=mean(dev_Degree_acum_MC_matrix,1);
prom_MAM_dev_Deg=mean(dev_Degree_acum_MAM_matrix,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REPRESENT AVERAGE VALUES (ACROSS ITERATIONS)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
plot(prom_prop_ev_RAN, sqrt(prom_RAN),'y')
hold on
plot( prom_prop_ev_MC, sqrt(prom_MC), 'r')
plot( prom_prop_ev_MAM, sqrt(prom_MAM), 'b')
xlabel('|U|/N')
ylabel('E_{rms}')
legend('Random','WMC','Proposed')

figure
plot(prom_prop_ev_MC, prom_MC_Deg,'r')
hold on
plot( prom_prop_ev_MC, prom_MC_dev_Deg, 'r.')
plot( prom_prop_ev_MAM, prom_MAM_Deg, 'b')
plot( prom_prop_ev_MAM, prom_MAM_dev_Deg, '.b')
xlabel('|U|/N')
ylabel('Degree')
legend('\mu_{degree} WMC','\sigma_{degree} WMC','\mu_{degree} Proposed','\sigma_{degree} Proposed')




