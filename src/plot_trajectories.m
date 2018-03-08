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

function plot_trajectories(displayflag, saveflag, savedir, fileprefix)     
    
    tempfig = figure;
    
    % TODO: 
    %  Plot trajectories of each atom over simulation timeframe. Add an
    %  option that colorizes the path by time, with a time colorbar. 
    
    if displayflag == false
        close(tempfig);
    end
end
