function [M, L] = generate_system_CC(L, kappa, A, G, E, I, n)
    
    %2n+2n-2+2n-2+n-1+n-1+n-1+n-1
    num_elem = 10*n-8;  % total non-zero elements in the sparse matrix\
    h = L/(n+1);
    
    % M1
    i_info = zeros(3*n-2,1);
    j_info = zeros(3*n-2,1);
    v_info = zeros(3*n-2,1);
    i = 1;
    
    i_info(i:i+n-1) = 1:n;
    j_info(i:i+n-1) = 1:n;
    v_info(i:i+n-1) = 2;
    i = i+n;
    i_info(i:i+n-2) = 1:n-1;
    j_info(i:i+n-2) = 1+(1:n-1);
    v_info(i:i+n-2) = -1;
    i = i+n-1;
    i_info(i:i+n-2) = 1+(1:n-1);
    j_info(i:i+n-2) = 1:n-1;
    v_info(i:i+n-2) = -1;
    M1 = sparse(i_info, j_info, v_info);
    
    % M2
    i_info = zeros(2*n-2,1);
    j_info = zeros(2*n-2,1);
    v_info = zeros(2*n-2,1);
    i = 1;

    i_info(i:i+n-2) = 1:n-1;
    j_info(i:i+n-2) = 1+(1:n-1);
    v_info(i:i+n-2) = 1;
    i = i+n-1;
    i_info(i:i+n-2) = 1+(1:n-1);
    j_info(i:i+n-2) = 1:n-1;
    v_info(i:i+n-2) = -1;
    i = i+n-1;
    M2 = sparse(i_info, j_info, v_info);
    
    % M3:
    i_info = zeros(3*n-2,1);
    j_info = zeros(3*n-2,1);
    v_info = zeros(3*n-2,1);
    i = 1;

    i_info(i:i+n-1) = 1:n;
    j_info(i:i+n-1) = 1:n;
    v_info(i:i+n-1) = 4;
    i = i+n;
    i_info(i:i+n-2) = 1:n-1;
    j_info(i:i+n-2) = 1+(1:n-1);
    v_info(i:i+n-2) = 1;
    i = i+n-1;
    i_info(i:i+n-2) = 1+(1:n-1);
    j_info(i:i+n-2) = 1:n-1;
    v_info(i:i+n-2) = 1;
    i = i+n-1;
    M3 = sparse(i_info, j_info, v_info);
    
    M = sparse([], [], [], 2*n, 2*n, num_elem);
    M(1:n,1:n) = kappa*A*G*(1/h)*M1;
    M(1:n,n+(1:n)) = -1*kappa*A*G*(1/2)*M2;
    M(n+(1:n),1:n) = kappa*A*G*(1/2)*M2;
    M(n+(1:n),n+(1:n)) = E*I*(1/h)*M1+kappa*A*G*h*(1/6)*M3;
    
    % right hand side:
    
    L = sparse([],[],[], 2*n, 2*n, 6*n-4);
    L(1:n,1:n) = A*h*(1/6)*M3;
    L(n+(1:n),n+(1:n)) = I*h*(1/6)*M3;
    
end
