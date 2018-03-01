%
% This script assumes that main.m was run with at least one completed 
% simulation, and the data from the simulation is still being stored in 
% memory. 
% 2018
% Yosyp Schwab
%

tke = 0;
tpe = 0;
for i=1:natoms
    tke = tke + .5*m*vx(i,:).^2 + .5*m*vy(i,:).^2;
    tpe = tpe + pe(i,:);
end

% temperature
plot(t,tke./(natoms*bk_j)) 
plot(t./1e-12, XJOUTOEV*tke./(natoms*BK), 'LineWidth', 6);
title(sprintf("Temperature of System over Time"));
xlabel('time t [ps]','FontWeight','bold','Color','black');
ylabel('Temperature T [K]','FontSize',18,'FontWeight','bold','Color','black');
xt = get(gca, 'XTick'); set(gca, 'FontSize', 16);  set(gca, 'LineWidth', 2);

plot(t, XJOUTOEV*tke);
plot(t, XJOUTOEV*tpe);
plot(t, XJOUTOEV*(tpe+tke));

plot(t./1e-12, XJOUTOEV*(tpe+tke), 'LineWidth', 6);
title(sprintf("Total Energy of System over Time"));
xlabel('time t [ps]','FontWeight','bold','Color','black');
ylabel('Total Energy T [eV]','FontSize',18,'FontWeight','bold','Color','black');
xt = get(gca, 'XTick'); set(gca, 'FontSize', 16);  set(gca, 'LineWidth', 2);

    
    
    
    
    
    
    
for j=[1 50 100 200 1000]
    figure; grid on;
    axis([-.5*laty*dlat 1.5*laty*dlat -.5*laty*dlat 1.5*laty*dlat]./1e-9);
        xlabel('x [nm]','FontWeight','bold','Color','black');
        ylabel('y [nm]','FontSize',18,'FontWeight','bold','Color','black');
        xt = get(gca, 'XTick'); set(gca, 'FontSize', 16);  set(gca, 'LineWidth', 2);
    % for j=1:20:length(x)
%     j=1000;
        cla(gca);
        for i=1:natoms
            hold on;
    %         plot(atom{i}.x, atom{i}.y, 'b*', 'MarkerSize', 20, 'LineWidth', 4);
            plot(x(i,j)./1e-9, y(i,j)./1e-9, 'bo', 'MarkerSize', 20, 'LineWidth', 4);
            hold off;
        end
        title(sprintf('time = %E, timestep %d', j*dt, j));
        drawnow;
    % end
    saveas(gcf,sprintf('fdt%d.png',j))
end 






for j=[1 10 50 100 200 1000]
    figure; grid on;
%     axis([-.5*laty*dlat 1.5*laty*dlat -.5*laty*dlat 1.5*laty*dlat]./1e-9);
    axis([-.5*laty*dlat 1.5*laty*dlat -.5*laty*dlat 1.5*laty*dlat]./1e-9);
        xlabel('Position component x [nm]','FontWeight','bold','Color','black');
        ylabel('Position component y [nm]','FontSize',18,'FontWeight','bold','Color','black');
        xt = get(gca, 'XTick'); set(gca, 'FontSize', 16);  set(gca, 'LineWidth', 2);
    for j=1:50:length(x)
%     j=10;
        cla(gca);
        for i=1:natoms
            hold on;
            q = quiver(x(i,j)./1e-9, y(i,j)./1e-9, 10e9*fx(i,j), 10e9*fy(i,j));
            q.Marker = 'o';q.MarkerSize = 20;q.Color = 'red';
            q.ShowArrowHead = 'on';q.MarkerEdgeColor = 'blue';
            q.LineWidth = 4;
            hold off;
        end
        title(sprintf('time = %E, timestep %d', j*dt, j));
        drawnow;
     end
    saveas(gcf,sprintf('square-fdt%d.png',j))    
end   

    