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
dt = 1e-14;             % Integration timestep (seconds)
t_max = 10e-12;         % Total simulation time (seconds)
update_steps = 50;      % Print status to console every n integration steps 
savedir = '../figures'; % Directory where figures are saved
prefix = '7x7-10ps';    % Prefix of saved figure files
gifdelay = 0.1;          % Time between frames of saved GIF movies

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
    
[t,x,y,vx,vy,fx,fy,pe,natoms] = ljmatlab(lj_epsilon, lj_sigma, m, dlat, ...
                                    latx, laty, dt, t_max, update_steps);

% 
% Plot and/or save and/or display energies. The function paramaters are:
%       plot_energies(..., displayflag, saveflag, savedir, fileprefix)
%
plot_energies(t, m, vx, vy, pe, natoms, ...
              true, false, savedir, prefix);
          
%
% Plot and/or save and/or display positions of atoms over time.
% The function parameters are:
%       plot_movies(..., displayflag, saveflag, savedir, fileprefix)
% Note that is saveflag = true, the display plots are much slower because
% each from is being saved.
movie_plots(dt,dlat,laty,latx,x,y,natoms,gifdelay, true,false, savedir, prefix);
