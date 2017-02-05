function [Q] = Generate_Q_matrix(W)

NoOfSensors=length(W);
Q=0*W;

 for i = 1:NoOfSensors   
Degree=sum(W(i,:));    
Neigh=length(find(W(i,:)~=0));
Norm_factor=Degree*(1+1/Neigh);

Q(i,:)=W(i,:)/Norm_factor;
Q(i,i)=(Degree/Neigh)/Norm_factor;

end

