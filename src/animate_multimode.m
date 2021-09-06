function animate_multimode(w, w2, phi, phi2, L, l, T, fname='')
    num_t = size(w,2);
    num_x = size(w,1);

    x_max = max(max(w));
    x_min = min(min(w));
    abs_w = max([abs(x_max),abs(x_min)]);

    x_max_phi = max(max(phi));
    x_min_phi = min(min(phi));
    abs_phi = max([abs(x_max_phi),abs(x_min_phi)]);
    h = L/(num_x-1);

    dif_w = abs(w-w2);
    dif_phi = abs(phi-phi2); 
    max_dif_w = max(max(dif_w))
    max_dif_phi = max(max(dif_phi))
        
    k=1;
    x_spread = linspace(0, L, num_x);
    for j = 1:num_t
        subplot(2,2,1);
        plot(x_spread, w(:,j))
        hold on
        plot(x_spread, w2(:,j))
        hold off
        title(['usporedba odstupanja, t = ',  num2str(T*j/num_t, '%06.3f'), '/', num2str(T)]);
        legend('6 modova', '20 modova');
        ylim([-1,1]);
        xlim([-L/10, 1.1*L]);
        
        subplot(2,2,2);
        plot(x_spread, phi(:,j));
        hold on
        plot(x_spread, phi2(:,j));
        hold off
        ylim([-abs_phi*1.1 abs_phi*1.1]);
        xlim([-L/10, 1.1*L]);
        legend('6 modova', '20 modova');
        title('usporedba poprecnog presjeka');

        subplot(2,2,3);
        plot(x_spread, dif_w(:,j));
        title('absolutna razlika u odstupanju');
        xlim([-L/10, 1.1*L]);
        ylim([-max_dif_w/10, 1.1*max_dif_w]);

        subplot(2,2,4);
        plot(x_spread, dif_phi(:,j));
        title('absolutna razlika u kutu poprecnog presjeka');
        xlim([-L/10, 1.1*L]);
        ylim([-max_dif_phi/10, 1.1*max_dif_phi]);
        
        pause(0.1);
        set(gcf, 'PaperUnits', 'centimeters', 'PaperPosition', [0 0 40 15]);
        saveas(gcf, [fname, num2str(k,'%05.f'), '.png'])
        k=k+1;
    end
end

function [A,B] = CS_points(P, phi, l)
    A = P+[0, l/2];
    move_x = l*sin(phi);
    move_y = l*(cos(phi)-1);
    A = A+[move_x, move_y];
    B = 2*P-A;
end
