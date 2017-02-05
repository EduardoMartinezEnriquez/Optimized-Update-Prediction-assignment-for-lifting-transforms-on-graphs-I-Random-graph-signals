function [media desv D0 mean_Degree dev_Degree]=calculate_energy_and_degree (A_fin, label, datastore,P)

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
