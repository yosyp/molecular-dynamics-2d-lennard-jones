
l = 1;
E = 1;
I = 1;
omega = 1;

x = [0:.0001:1];
u_exact = ((omega) / (24 * E * I)) * (6*l^2*x.^2 + x.^4 - 4*l*x.^3);
u_quadt = (omega * l^2 * x.^2) / (12 * E * I);
u_cubic = ((l * omega) / ( 24 * E * I)) * (-2.*x.^3 + 5*l.*x.^2);

plot(x, u_exact, x, u_quadt, x, u_cubic, 'LineWidth', 5);
    title(sprintf('Q2-D: Solutions of beam deformation y(x)'));
    xlabel('^{x}/_{L}','FontWeight','bold','Color','black');
    ylabel('^{\omega}/_{E I}','FontSize',18,'FontWeight','bold','Color','black');
    xt = get(gca, 'XTick'); set(gca, 'FontSize', 16);  set(gca, 'LineWidth', 2);
    legend({'y_{analytical}(x)','y_{quadratic}(x)','y_{cubic}(x)'},'Location','northwest','Orientation','vertical','FontSize',18);
