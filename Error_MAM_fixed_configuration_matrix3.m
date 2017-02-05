function [Error] =Error_MAM_fixed_configuration_matrix3(P_filters,M,var_et,c)


aux_eye=speye(length(M)); 

Error1=c^2.*aux_eye+M.*aux_eye+var_et.*aux_eye-2*(P_filters*M).*aux_eye-2*P_filters*(c^2*ones(length(M)));
Error2=(P_filters*(M+var_et*aux_eye+c^2)*P_filters');

Error=Error1+Error2;
Error=Error.*aux_eye;
Error=sum(Error,2);
end

