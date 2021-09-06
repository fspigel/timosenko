function animate(w, T, fname)
    x_max = max(max(w));
    x_min = min(min(w));
    abs = max([abs(x_max),abs(x_min)]);
    k=1;
    num_t = size(w,2);
    for j = 1:num_t
        plot(w(:,j))
        title(['rubber, t = ',  num2str(T*j/num_t, '%06.3f'), '/', num2str(T)]);
        ylim([-abs*1.1 abs*1.1]);
        pause(0.1);
        %saveas(gcf, ['rubber_GIF/', fname, num2str(k,'%05.f'), '.jpg'])
        k=k+1;
    end
end