clear;clc;
%
% Molecular dynamics in two dimensions using Lennard-Jones potential.
%
% 2018
% Yosyp Schwab
%

%
% Input parameters
%
m = 40;                 % Mass (amu)
lj_epsilon = 0.0103;    % LJ constant (eV)
lj_sigma = 3.405;       % LJ constant (Angstrom)
latx = 7;               % Number of atoms in lattice x direction
laty = 7;               % Number of atoms in lattice y direction
dt = 5e-14;             % Integration timestep (seconds)
t_max = 10e-12;         % Total simulation time (seconds)
update_steps = 50;      % Print status to console every n integration steps 

%
% Equilibrium lattice parameter corresponds to the minimum energy of the LJ 
% potential curve. Here it is directly defined:
dlat = 3.82198 * 1e-10;            % Equilibrium lattice parameter (meters)
% but the minimum can also be obtained by finding the zero value using
% these two plots:
    % r = linspace(lj_sigma,3*lj_sigma,1000);
    % lj = @(lj_sigma,lj_epsilon,r) 4*lj_epsilon*((lj_sigma./r).^12 - (lj_sigma./r).^6)./lj_epsilon;
    % dljdr = @(lj_sigma,lj_epsilon,r) 4*lj_epsilon*(-12*((lj_sigma^12)./(r.^13)) + 6*((lj_sigma^6)./(r.^7)))./lj_epsilon;
    % figure; plot(r,lj(lj_sigma,lj_epsilon,r));
    % figure; plot(r,dljdr(lj_sigma,lj_epsilon,r));
    % figure; plot(r./lj_sigma,lj(lj_sigma,lj_epsilon,r));
    % figure; plot(r./lj_sigma,dljdr(lj_sigma,lj_epsilon,r));

%
% Unit conversion parameters
%
EVTOJOU = 1.60219e-19;      % J/eV
AMUTOKG = 1.6605402e-27;    % kg/amu
BK = 8.617385e-05;          % Boltzmann constant, eV/K
XJOUTOEV = 1.0/EVTOJOU;     % eV/J

% Convert input parameters to simulation units
m = m * AMUTOKG;                   % mass in kg
lj_epsilon = lj_epsilon * EVTOJOU; % in J
lj_sigma = lj_sigma * 1e-10;       % in meters
bk_j = BK * EVTOJOU;               % Boltzmann constant, J/K
natoms = latx*laty;

%
% Place atoms dlat apart in dimensions as specified by latx,laty above. Set
% the initial velocities and forces of atoms to zero. 
%
dx = 0; dy = 0;
for i=1:natoms 
    atom{i}.x = dx;
    atom{i}.y = dy;

    atom{i}.vx = 0;
    atom{i}.vy = 0;

    atom{i}.fx = 0;
    atom{i}.fy = 0;
    
    dx = dx + dlat;
    if mod(i, latx) == 0
        dy = dy + dlat;
        dx = 0;
    end  
end

% Calculate initial forces of all atoms with given potential parameters.
atom = CalcForces(atom,dlat,latx,laty,lj_epsilon,lj_sigma);

%
% Velocity Verlet algorithm updates the atomic positions and velocities by
% first calculating the forces using updated positions, then storing the
% updated values to use in the next iteration.
%
step = 1;
for time = 0:dt:t_max
   % Update atomic positions using previously calculated forces.
   for i=1:natoms
       atom{i}.x = atom{i}.x + dt*atom{i}.vx + (.5*(dt^2)/m)*atom{i}.fx;
       atom{i}.y = atom{i}.y + dt*atom{i}.vy + (.5*(dt^2)/m)*atom{i}.fy;
   end
   
   % Calculate new forces using newly calculated atomic positions.
   atom_updated = CalcForces(atom,dlat,latx,laty,lj_epsilon,lj_sigma);
   
   for i=1:natoms
      % Calculate new velocities using newly calculated forces.
      atom{i}.vx = atom{i}.vy + (.5*dt/m)*(atom{i}.fx + atom_updated{i}.fx);
      atom{i}.vy = atom{i}.vy + (.5*dt/m)*(atom{i}.fy + atom_updated{i}.fy);
      
      % Append new kinematic and energy values of each atom to a long
      % vector storing values of each step. Note: this may become a
      % bottleneck for large systems, then it is better to output to files.
      x(i,step) = atom{i}.x;
      y(i,step) = atom{i}.y;
      vx(i,step) = atom{i}.vx;
      vy(i,step) = atom{i}.vy;
      fx(i,step) = atom{i}.fx;
      fy(i,step) = atom{i}.fy;    
      pe(i,step) = sum(sum(atom{i}.u));
   end
   
   % Store newly calculated forces from this iteration to be used as the
   % "old" forces for the next iteration.
   atom = atom_updated; 

   % Print energy output to console, this is useful to check if the system
   % is unstable and can be terminated without waiting for the simulation
   % to fully complete. 
   % "PE delta" is the difference between the potential energies of the
   % previous steps and a much older steps (49 iterations back). This is a
   % smoothing parameter to prevent any false-stops with radical energy
   % jumps (which can happen initially).
   step = step+1;
   if mod(step,update_steps) == 0 
       fprintf("PE delta: %E, step %d, t = %E\n", sum(pe(:,step-1))-sum(pe(:,step-49)),step, time);
   end
end



