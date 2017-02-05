function [x] = Generate_signal(var_ep,nu_ep,var_et,nu_et,c, NoOfSensors,Q)

des_ep=sqrt(var_ep);
data_ep= round(normrnd(nu_ep,des_ep,NoOfSensors,1));

des_et=sqrt(var_et);
data_et= round(normrnd(nu_et,des_et,NoOfSensors,1));

x= c*ones(NoOfSensors,1)+ Q*data_ep+data_et;

end

