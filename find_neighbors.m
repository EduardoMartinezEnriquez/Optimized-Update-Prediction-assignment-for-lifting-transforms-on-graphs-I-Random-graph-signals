function [Vecinos_Odds Vecinos_Evens Vecinos_Evens_de_Evens]=find_neighbors(A,label,NoOfSensors)


Vecinos_Evens=cell(NoOfSensors,1);
Vecinos_Odds=cell(NoOfSensors,1);
Vecinos_Evens_de_Evens=cell(NoOfSensors,1); 

for i=1:NoOfSensors
    
    % Sensor i
    % find connections with i
    a=find(A(i,:)~=0);

    if (label(i)==-1) %if node is U
        
    
    for j=1:length(a)
        et=a(j);
        
        if (label(et)==1) %if connection is P
        Vecinos_Odds{i}=[Vecinos_Odds{i} et];
        end
        
        if(label(et)==-1) %if connection is u with othe U    
        Vecinos_Evens_de_Evens{i}=[Vecinos_Evens_de_Evens{i} et];
        end

    end

    else %if node is P
    for j=1:length(a)
        et=a(j);

        if (label(et)==-1) %if connection is U
        Vecinos_Evens{i}=[Vecinos_Evens{i} et];
        end
    end 
    
    end

end

    
    