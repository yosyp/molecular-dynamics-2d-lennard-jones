function atom = CalcForces(atom,dlat,latx,laty,lj_epsilon,lj_sigma)
    natoms = length(atom);
    for i=1:natoms
        for j=1:natoms
            if j ~= i
                dr = sqrt( (atom{i}.x - atom{j}.x)^2 + (atom{i}.y - atom{j}.y)^2 );
%                 if dr < 3*dlat
                    atom{i}.fx = atom{i}.fx - (24*lj_epsilon*(lj_sigma^6)*(atom{i}.x-atom{j}.x))/(dr^8) * (1 - 2*(lj_sigma/dr)^6);
                    atom{i}.fy = atom{i}.fy - (24*lj_epsilon*(lj_sigma^6)*(atom{i}.y-atom{j}.y))/(dr^8) * (1 - 2*(lj_sigma/dr)^6);
                    atom{i}.u(j) = 4*lj_epsilon*( (lj_sigma / dr)^12 - (lj_sigma / dr)^6);
                    atom{i}.dr(j) = dr;
%                 end
            end
            if j == natoms && i == natoms
                atom{i}.u(j) = 0;
            end
        end
        atom{i}.u = reshape(atom{i}.u,latx,laty);
    end
end
