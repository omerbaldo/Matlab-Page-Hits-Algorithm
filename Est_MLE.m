%{    
    n11 n12
    n21 n22

    N11 N12    M1
    N21 N22    M3
    M2  M4
    
    N = N11 + N12 + N21 + N22
    M1 = N11 + N12 
    M2 = N11 + N21
    M3 = N - M1;
    M4 = N - M2;
    
    N21 = M2 - N11
    N12 = M1 - N11
    N22 = M3 - N21
    
    N11 ^ (T+1) = N11^(T) + G(N11^(T))/G(N11^(T))
%}

function [error] = Est_MLE(n11,n12,n21,n22,M1,M2,N,iter)
     M3 = N - M1; M4 = N - M2; error = zeros(1, iter); N11 = 0; N21 = 0; N12 = 0; N22 = 0; n = n11 + n12 + n21 + n22;
     
     % MARGIN FREE ESTIMATOR
     N11 = (n11/n)*N; error(1,1) = N11;  
     for i =2:iter
         N11 = N11 - g(N11,n11,n12,n21,n22,M1,M2,N)/ g_prime(N11,n11,n12,n21,n22,M1,M2,N);        % computer N11  
         N21 = M2 - N11; N12 = M1 - N11; N22 = M3 - N21;                                           % compute values based off of N11
         error(1,i) = N11; % (N/n)/(1/N11 + 1/(M1-N11) + 1/(M2-N11)+1/(N-M1-M2+N11));                     % compute error 
     end
 end
 
 function [y] = g(N11,n11,n12,n21,n22,M1,M2,N)
    y = (n11/N11) - (n12/(M1-N11)) - (n21/(M2-N11))+ (n22/(N-M1-M2+N11));  
 end
 
 function [y] = g_prime(N11,n11,n12,n21,n22,M1,M2,N)
    y = (-1 * n11/(N11.^2)) - (n12/((M1-N11).^2)) - (n21/((M2-N11).^2))- (n22/((N-M1-M2+N11).^2)); 
 end
 