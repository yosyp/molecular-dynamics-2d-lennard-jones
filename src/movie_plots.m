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

function movie_plots(dt, dlat, laty, latx, x, y, natoms, ...
                       displayflag, saveflag, savedir, fileprefix)     
    [~,steps] = size(x);               
    
    tempfig = figure;
    for j=1:floor(steps/20):steps
        grid on;
        axis([-.5*laty*dlat 1.5*laty*dlat -.5*laty*dlat 1.5*laty*dlat]./1e-9);
        xlabel('x [nm]','FontWeight','bold','Color','black');
        ylabel('y [nm]','FontSize',18,'FontWeight','bold','Color','black');
        xt = get(gca, 'XTick'); set(gca, 'FontSize', 16);  set(gca, 'LineWidth', 2);
        cla(gcf);
        for i=1:natoms
            hold on;
            plot(x(i,j)./1e-9, y(i,j)./1e-9, 'bo', 'MarkerSize', 20, 'LineWidth', 4);
            hold off;
        end
        title(sprintf('time = %E, timestep %d', j*dt, j));
        drawnow;
    end
    
    if saveflag == true
        saveas(tempfig,sprintf('%s/%s-temp.png',savedir, fileprefix));
    end
    
    if displayflag == false
        close(tempfig);
    end
end
