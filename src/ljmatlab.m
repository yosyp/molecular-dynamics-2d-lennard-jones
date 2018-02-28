clear;clc;

% assymetric oscillatinos
% equilibrium disance shifts right!

EVTOJOU = 1.60219e-19;      %!J/eV
AMUTOKG = 1.6605402e-27;    %!kg/amu
BK = 8.617385e-05;          %!Boltzmann constant, eV/K
XJOUTOEV = 1.0/EVTOJOU;     %!eV/J

m = 40; % amu
lj_epsilon = 0.0103; % eV
lj_sigma = 3.405; % Angstrom

m = m * AMUTOKG;                   % mass in kg
lj_epsilon = lj_epsilon * EVTOJOU; % in J
lj_sigma = lj_sigma * 1e-10;       % in meters
bk_j = BK * EVTOJOU;               % Boltzmann constant, J/K


r = linspace(lj_sigma,3*lj_sigma,1000);
lj = @(lj_sigma,lj_epsilon,r) 4*lj_epsilon*((lj_sigma./r).^12 - (lj_sigma./r).^6)./lj_epsilon;
dljdr = @(lj_sigma,lj_epsilon,r) 4*lj_epsilon*(-12*((lj_sigma^12)./(r.^13)) + 6*((lj_sigma^6)./(r.^7)))./lj_epsilon;

figure;plot(r,lj(lj_sigma,lj_epsilon,r));
figure;plot(r,dljdr(lj_sigma,lj_epsilon,r));
% figure;plot(r./lj_sigma,lj(lj_sigma,lj_epsilon,r));
% figure;plot(r./lj_sigma,dljdr(lj_sigma,lj_epsilon,r));


latx = 7;
laty = 7;
natoms = latx*laty;
dlat = 3.82198 * 1e-10; % in meters


dx = 0; dy = 0;
for i=1:natoms 
    atom{i}.x = dx;
    atom{i}.y = dy;

    atom{i}.vx = 0;
    atom{i}.vy = 0;

    atom{i}.fx = 0;
    atom{i}.fy = 0;
    
    
    fprintf("(%4.2f %4.2f), ", dx, dy);
    dx = dx + dlat;
    if mod(i, latx) == 0
        dy = dy + dlat;
        dx = 0;
        fprintf("\n");
    end  
end

atom = CalcForces(atom,dlat,latx,laty,lj_epsilon,lj_sigma);

dt = 5e-14;
% t_max = 1e-13;
t_max = 50e-12; % 50 picoseconds
step = 1;
for time = 0:dt:t_max
   for i=1:natoms
       atom{i}.x = atom{i}.x + dt*atom{i}.vx + (.5*(dt^2)/m)*atom{i}.fx;
       atom{i}.y = atom{i}.y + dt*atom{i}.vy + (.5*(dt^2)/m)*atom{i}.fy;
   end
   
   atom_updated = CalcForces(atom,dlat,latx,laty,lj_epsilon,lj_sigma);
   
   for i=1:natoms
      atom{i}.vx = atom{i}.vy + (.5*dt/m)*(atom{i}.fx + atom_updated{i}.fx);
      atom{i}.vy = atom{i}.vy + (.5*dt/m)*(atom{i}.fy + atom_updated{i}.fy);
      x(i,step) = atom{i}.x;
      y(i,step) = atom{i}.y;
      vx(i,step) = atom{i}.vx;
      vy(i,step) = atom{i}.vy;
      fx(i,step) = atom{i}.fx;
      fy(i,step) = atom{i}.fy;    
      pe(i,step) = sum(sum(atom{i}.u));
   end
   t(step) = step*dt;
   
   atom = atom_updated; 

   step = step+1;
   if mod(step,50) == 0 
       fprintf("PE delta: %E, step %d, t = %E\n", sum(pe(:,step-1))-sum(pe(:,step-49)),step, time);
   end
end



