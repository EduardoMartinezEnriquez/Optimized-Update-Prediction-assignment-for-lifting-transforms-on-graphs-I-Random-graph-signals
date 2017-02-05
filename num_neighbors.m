function [media desv]=num_neighbors(O, Vecinos_Evens)

NV=[];

for i=1:length(O)
  
    
    a=Vecinos_Evens{O(i)};
    NV=[NV length(a)];
end
find(NV==0);
media=mean(NV);
desv=std(NV);