%
% This function assumes that main.m was run with at least one completed 
% simulation, and the data from the simulation is still being stored in 
% memory. 
% 
% displayflag  If true leave figures open after saving.
% safeflag     If true save figures.
% savedir      Directory name where figures are saved.
% fileprefix   Filename prefix for saved files.
% 
% 2018
% Yosyp Schwab
%

function plot_trajectories(natoms, x, y, dlat, latx, laty, ...
                            displayflag, saveflag, savedir, fileprefix)     
    [~,steps] = size(x);                   
    z = zeros(1,steps);
    time = 1:steps;
    tempfig = figure; hold on;

    % TODO: 
    %  Plot trajectories of each atom over simulation timeframe. Add an
    %  option that colorizes the path by time, with a time colorbar. 
    for i=1:natoms
        axis([-.5*laty*dlat 1.5*laty*dlat -.5*laty*dlat 1.5*laty*dlat]./1e-9);
        xlabel('x [nm]','FontWeight','bold','Color','black');
        ylabel('y [nm]','FontSize',18,'FontWeight','bold','Color','black');
        xt = get(gca, 'XTick'); set(gca, 'FontSize', 16);  set(gca, 'LineWidth', 2);
        surface([x(i,:);x(i,:)]./1e-9,[y(i,:);y(i,:)]./1e-9,[z;z],[time;time],...
                'facecol','no',...
                'edgecol','interp',...
                'linew',4);        
    end
   
    if displayflag == false
        close(tempfig);
    end
end
