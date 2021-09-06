function w=w0_rubber_2(x)
    if x <= 0 || x >= 1
        w = 0;
        return;
    end
    w = exp(-1/(1-(2*x-1)^2));
end
