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
    z = zeros(steps);
    colors = 0:.1:steps;
    tempfig = figure;

    % TODO: 
    %  Plot trajectories of each atom over simulation timeframe. Add an
    %  option that colorizes the path by time, with a time colorbar. 
%    hold on;
%    for j=1:floor(steps/20):steps
    for i=1:natoms
        grid on;
        axis([-.5*laty*dlat 1.5*laty*dlat -.5*laty*dlat 1.5*laty*dlat]./1e-9);
        xlabel('x [nm]','FontWeight','bold','Color','black');
        ylabel('y [nm]','FontSize',18,'FontWeight','bold','Color','black');
        xt = get(gca, 'XTick'); set(gca, 'FontSize', 16);  set(gca, 'LineWidth', 2);
        surf([x(i,:);x(i,:)],[y(i,:);y(i,:)],[z;z],[colors;colors],...
                'facecol','no',...
                'edgecol','interp',...
                'linew',2);
%         for i=1:natoms
%             plot(x(i,j)./1e-9, y(i,j)./1e-9, 'bo', 'MarkerSize', 2, 'LineWidth', 4);
%         end
    end
%    end
   
    if displayflag == false
        close(tempfig);
    end
end
