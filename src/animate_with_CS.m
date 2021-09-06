function animate_with_CS(w, phi, L, l, T, fname='')
    num_t = size(w,2);
    num_x = size(w,1);

    x_max = max(max(w));
    x_min = min(min(w));
    abs_w = max([abs(x_max),abs(x_min)]);

    x_max_phi = max(max(phi));
    x_min_phi = min(min(phi));
    abs_phi = max([abs(x_max_phi),abs(x_min_phi)]);
    h = L/(num_x-1);

    k=1;
    x_spread = linspace(0, L, num_x);
    for j = 1:num_t
        subplot(1,2,1);
        plot(x_spread, w(:,j))
        hold on
        for i = 1:5:num_x
            [A,B] = CS_points([x_spread(i), w(i,j)], phi(i,j), l);
            plot([A(1), B(1)], [A(2), B(2)], 'r');
        end
        hold off
        title(['rubber, t = ',  num2str(T*j/num_t, '%06.3f'), '/', num2str(T)]);
        %ylim([-abs*1.1 abs*1.1]);
        ylim([-1,1])
        xlim([-L/10, 1.1*L])
        
        subplot(1,2,2);
        plot(x_spread, phi(:,j));
        hold on
        dw = -(w(2:end,j)-w(1:end-1,j))/h;
        plot(x_spread(1:end-1), asin(dw));
        hold off
        ylim([-abs_phi*1.1 abs_phi*1.1]);
        legend('phi (T)', 'dw (EB)');
        title('Timosenkov poprecni presjek naspram Euler-Bernoullijevog');
         
        pause(0.1);
        set(gcf, 'PaperUnits', 'centimeters', 'PaperPosition', [0 0 40 10]);
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
