%
% This function assumes that main.m was run with at least one completed 
% simulation, and the data from the simulation is still being stored in 
% memory. 
% 
% gifdelay     Number of seconds between GIF frames saved.
% displayflag  If true leave figures open after saving.
% safeflag     If true save figures.
% savedir      Directory name where figures are saved.
% fileprefix   Filename prefix for saved files.
% 
% 2018
% Yosyp Schwab
%

function movie_plots(dt, dlat, laty, latx, x, y, natoms, gifdelay, ...
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
            % TODO: Add force vectors over atom positions.
%             q = quiver(x(i,j)./1e-9, y(i,j)./1e-9, 10e9*fx(i,j), 10e9*fy(i,j));
%             q.Marker = 'o';q.MarkerSize = 20;q.Color = 'red';
%             q.ShowArrowHead = 'on';q.MarkerEdgeColor = 'blue';
%             q.LineWidth = 4;
            plot(x(i,j)./1e-9, y(i,j)./1e-9, 'bo', 'MarkerSize', 20, 'LineWidth', 4);
            hold off;
        end
        title(sprintf('time = %E, timestep %d', j*dt, j));
        drawnow;
        
        if saveflag == true
            frame = getframe(gcf);
            img =  frame2im(frame);
            [img,cmap] = rgb2ind(img,256);
            if j == 1
                imwrite(img, cmap, ...
                        sprintf('%s/%s-temp.gif',savedir, fileprefix), ...
                        'gif','LoopCount',Inf,'DelayTime',gifdelay);
            else
                imwrite(img, cmap, ...
                        sprintf('%s/%s-temp.gif',savedir, fileprefix), ...
                        'gif','WriteMode','append','DelayTime',gifdelay);
            end  
        end
    end
    
    if displayflag == false
        close(tempfig);
    end
end
