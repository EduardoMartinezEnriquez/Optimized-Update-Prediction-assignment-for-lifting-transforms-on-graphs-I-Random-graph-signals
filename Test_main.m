
close all
clear all



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   INPUT PARAMETERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% NUMBER OF NODES OF THE GRAPH
N=200;
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
num_it=2;

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


% LOOP NUMBER OF ITERATIONS (REALIZATIONS OF THE RANDOM GRAPH GENERATION)
for it=1:num_it

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   SELECT THE GRAPH TOPOLOGY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SELECT ONE OF THE FOLLOWING OPTIONS  TO GENERATE THE GRAPH (DECOMMENT THE
% CHOSEN OPTION), UDING THE GSP TOOLBOX

% Random Sensor Network; w=exp(-dist^2/med_dist^2)
G=gsp_sensor(N); 

% Community graph
% G=gsp_community(N);

% Minnesota graph
% % % connect=1;
% % % G=gsp_minnesota(connect); 


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
% DECOMMENT TO OBTAIN A GRAPH REPRESENATION OF THE GRAPH SIGNAL.
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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GREEDY ALGORITHM FOR THE WMC UPA SOLUTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tic
[label_MC D0_acum_MC prop_ev_acum_MC media_acum_MC desv_acum_MC media_MAXCUT desv_MAXCUT D0_MAXCUT RMS_MAXCUT U_set_MC mean_Degree_acumMC dev_Degree_acumMC] = greedy_MAXCUT(W, x);
a=toc
time_per_node_MC=a/length(U_set_MC)


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
close all

figure
plot(prop_ev_acum,mean_Degree_acum,'b')
hold on
plot(prop_ev_acum,dev_Degree_acum,'.b')
hold on
plot(prop_ev_acum_MC,mean_Degree_acumMC,'r')
hold on
plot(prop_ev_acum_MC,dev_Degree_acumMC,'.r')
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

figure
plot(prom_prop_ev_MC, prom_MC_Deg,'r')
hold on
plot( prom_prop_ev_MC, prom_MC_dev_Deg, 'r.')
plot( prom_prop_ev_MAM, prom_MAM_Deg, 'b')
plot( prom_prop_ev_MAM, prom_MAM_dev_Deg, '.b')




