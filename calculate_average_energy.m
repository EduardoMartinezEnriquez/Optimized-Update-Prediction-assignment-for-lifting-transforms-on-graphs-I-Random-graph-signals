function [energia_media]=calculate_average_energy(label,coeffs)


odds=find(label==1);
energia=sum((coeffs(odds)).^2);
energia_media=sum((coeffs(odds)).^2)/length(odds);
length(odds);


