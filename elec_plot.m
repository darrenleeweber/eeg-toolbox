function elec_plot(p)

% elec_plot - plots electrode positions in 3D
%
% Usage: elec_plot(p)
%

% $Revision: 1.3 $ $Date: 2004/04/16 18:49:10 $

% Licence:  GNU GPL, no express or implied warranties
% History:  10/2003, Darren.Weber_at_radiology.ucsf.edu
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tic; fprintf('\nELEC_PLOT...\n');

x = p.elec.data.x;
y = p.elec.data.y;
z = p.elec.data.z;

Xsp = p.elec.data.Xsp;
Ysp = p.elec.data.Ysp;
Zsp = p.elec.data.Zsp;

Rsp =  p.elec.data.Rsp(1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot the electrode positions

figure('NumberTitle','off','Name','Electrode Placements');
set(gca,'Projection','perspective');
set(gca,'DataAspectRatio',[1 1 1]);

map = ones(size(colormap('gray'))) .* 0.7; colormap(map);
[Xs,Ys,Zs]=sphere;
Xs = Xs * Rsp;
Ys = Ys * Rsp;
Zs = Zs * Rsp;
surf(Xs,Ys,Zs,'FaceAlpha',0.75); view(2);
shading interp; rotate3d; hold on

plot3(x,y,z,'.');
plot3(Xsp,Ysp,Zsp,'ro');
legend('input xyz','fitted sphere',-1);

axis tight; hold off;

t = toc; fprintf('...done (%6.2f sec).\n\n',t);

return
