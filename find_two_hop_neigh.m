function [Neigh_two_hop]=find_two_hop_neigh(A,NoOfSensors)


Neigh_two_hop=cell(NoOfSensors,1);


for i=1:NoOfSensors
    
    a=find(A(i,:)~=0);

    for j=1:length(a)
        et=a(j);
        b=find(A(et,:)~=0);
        Neigh_two_hop{i}=[Neigh_two_hop{i} b et];

    end
Neigh_two_hop{i}=unique(Neigh_two_hop{i});

end

    
    