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

function plot_energies(t, m, vx, vy, pe, natoms, ...
                       displayflag, saveflag, savedir, fileprefix)
    % Unit conversions for plots
    EVTOJOU = 1.60219e-19;      % J/eV
    BK = 8.617385e-05;          % Boltzmann constant, eV/K    
    XJOUTOEV = 1.0/EVTOJOU;     % eV/J                   
                   
    % Sum the kinetic and potential energies of all atoms
    tke = 0; tpe = 0;
    for i=1:natoms
        tke = tke + .5*m*vx(i,:).^2 + .5*m*vy(i,:).^2;
        tpe = tpe + pe(i,:);
    end

    tempfig = figure;
    plot(t./1e-12, XJOUTOEV*tke./(natoms*BK), 'LineWidth', 6);
    title(sprintf("Temperature of System over Time"));
    xlabel('time t [ps]','FontWeight','bold','Color','black');
    ylabel('Temperature T [K]','FontSize',18,'FontWeight','bold','Color','black');
    xt = get(gca, 'XTick'); set(gca, 'FontSize', 16);  set(gca, 'LineWidth', 2);
   
    tkefig = figure;
    plot(t, XJOUTOEV*tke, 'LineWidth', 6);
    title(sprintf("Kinetic Energy of System over Time"));
    xlabel('time t [ps]','FontWeight','bold','Color','black');
    ylabel('Kinetic Energy T [eV]','FontSize',18,'FontWeight','bold','Color','black');
    xt = get(gca, 'XTick'); set(gca, 'FontSize', 16);  set(gca, 'LineWidth', 2);
    
    tpefig = figure;
    plot(t, XJOUTOEV*tpe, 'LineWidth', 6);
    title(sprintf("Potential Energy of System over Time"));
    xlabel('time t [ps]','FontWeight','bold','Color','black');
    ylabel('Potential Energy T [eV]','FontSize',18,'FontWeight','bold','Color','black');
    xt = get(gca, 'XTick'); set(gca, 'FontSize', 16);  set(gca, 'LineWidth', 2);

    tengfig = figure;
    plot(t./1e-12, XJOUTOEV*(tpe+tke), 'LineWidth', 6);
    title(sprintf("Total Energy of System over Time"));
    xlabel('time t [ps]','FontWeight','bold','Color','black');
    ylabel('Total Energy T [eV]','FontSize',18,'FontWeight','bold','Color','black');
    xt = get(gca, 'XTick'); set(gca, 'FontSize', 16);  set(gca, 'LineWidth', 2);

    if saveflag == true
        saveas(tempfig,sprintf('%s/%s-temp.png',savedir, fileprefix));
        saveas(tkefig, sprintf('%s/%s-tke.png',savedir, fileprefix));
        saveas(tpefig, sprintf('%s/%s-tpe.png',savedir, fileprefix));
        saveas(tengfig,sprintf('%s/%s-teng.png',savedir, fileprefix));
    end
    
    if displayflag == false
        close(tempfig);
        close(tkefig);
        close(tpefig);
        close(tengfig);
    end
end
