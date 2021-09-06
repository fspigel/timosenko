function [w,phi, M1, M2, v, d, consts]=timoshenko_solver_CC(L, T, kappa, rho, A, G, E, I, n_x, n_t, w0, modes)
    
    start = cputime;
    
    % solve the spatial domain
    % (L, kappa, A, G, E, I, n)
    [M1,M2]=generate_system_CC(L, kappa, A, G, E, I, n_x);
    'system generated'
    (cputime-start)*1000

    [v,d]=eigs(M1,M2,modes, 'sm');
    'eigenproblem solved'
    (cputime-start)*1000

    d = diag(d);
    v = [zeros(1,modes); v(1:n_x,:); zeros(2,modes); v(n_x+1:end,:); zeros(1,modes)];
    
    function w = X_w(x, k)
        h = L/(n_x+1);
        n1 = floor(x/h)+1;
        frac = x/h-n1+1;
        w = v(n1,k)*(1-frac)+v(n1+1,k)*frac;
    end

    function phi = X_phi(x, k)
        h = L/(n_x+1);
        n1 = floor(x/h)+1;
        frac = x/h-n1+1;
        if n1+n_x+4 > size(v,1)
            phi = v(end,k);
        else
            phi = v(n1+n_x+3,k)*(1-frac)+v(n1+1+n_x+3,k)*frac;
        end
    end
    
    % solve the temporal domain
    x=linspace(L/n_x, L*(n_x-1)/n_x, modes);
    X = zeros(modes);
    for i = 1:modes
        for k = 1:modes
            X(i,k)=X_w(x(i),k);
        end
    end
    
    w0_vec = arrayfun(w0,x)';
    consts = X\w0_vec;

    'temporal domain solved'
    (cputime-start)*1000
    
    function res = T_fun(t,k)
        res = consts(k)*cos(t*sqrt(d(k)/rho));
    end

    x = linspace(0, L, n_x+2);
    t = linspace(0, T, n_t+1);
    w = zeros(n_x+2,n_t+1);
    phi = zeros(n_x+2,n_t+1);
    for i = 1:n_x+2
        for j = 1:n_t+1
            for k = 1:modes
                w(i,j) = w(i,j) +  X_w(x(i),k)*T_fun(t(j),k);
                phi(i,j) = phi(i,j) + X_phi(x(i),k)*T_fun(t(j),k);
            end
        end
    end
    
    'complete'
    (cputime-start)*1000
    
end
