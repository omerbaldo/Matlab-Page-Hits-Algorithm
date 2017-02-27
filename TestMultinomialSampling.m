function TestMultinomialSampling(Word1, Word2)
    % N is total number of documents, 2^16
    % W1 = HONG     W2 = KONG SO COLUMN VECTORS for word 1 and 2 where each row represents one document from 65536
    N = 2^16; W1 = zeros(N,1); W2 = zeros(N,1);    
   
    %this load occurances of word in document 
    data = feval('load',[ Word1]); W1(data(:,2))=1; 
    data = feval('load',[ Word2]); W2(data(:,2))=1;
    
    % k is our sample size small n
    K = [10 20 30 50 80 100 150 200 300 400 500 600 800 1000];
                        %sample size is 100 (select 100 rows from w1 and w2)
    for m = 1:10^3 % fill out row of IPS
        ind = randsample(N,max(K));    % random numbers from 1 to N to represent rows/documents 
        S1 = W1(ind); S2 = W2(ind); % column vector, to count occurances
        % S1: count occurances of word1 each document 
        % S2: count occurances of word2 each document 
        
        for i = 1:length(K) % fill out column of IPS
            
            % s1 is column vector, from 1 to K (different sample size per iteration)
            
            s1 = S1(1:K(i)); 
            s2 = S2(1:K(i));
            n11 = sum(s1==1 & s2==1);        % 2
            n12 = sum(s1==1 & s2==0);
            n21 = sum(s1==0 & s2==1);
            n22 = sum(s1==0 & s2==0);
            
            % never be 0 cause that gives an error
            n11 = n11+0.1;n12 = n12+0.1;
            n21 = n21+0.1;n22 = n22+0.1;
            
            
            % 3 ) estimate the original table by three methods
            n = n11+n12+n21+n22;
            M1 = sum(W1); M2 = sum(W2);
            
                % 1) IPS
                ips = Est_IPS(n11,n12,n21,n22,M1,M2,N,20); % prev algorithm
                IPS(m,i) = ips(end); % get last N1
                % 2) MLE using that wierd formulat the teacher gave 
                MLE(m,i) = (M1*(2*n11+n21) + M2*(2*n11+n12)-sqrt((M1*(2*n11+n21))-(M2*(2*n11+n12).^2) +4*M1*M2*n12*n21))/(2*(2*n11 + n12 + n21));
                
   
                % 3) Margin Free Estimation
                MF(m,i) = (n11/n)*N;                    
        end
    end
    
    % compute theoreticalfor mle
    %for i = 1:14 % 14 estimates
       
    
   % end     
    
    
    %all graphing here 
    
    N11 = sum(W1.*W2);            % theroretical value
    
    %Empirical MSE
    IPS_mse = mean((IPS - N11).^2);  % 1 x 14 double, gets error for each run with diff sample size 
    MLE_mse = mean((MLE - N11).^2);    
    MF_mse = mean((MF - N11).^2);    
    
    % Theoretical MsE of MLE
    
    % get estimation error of MLE and MF 
    % LINE
    figure;
    loglog(K, IPS_mse,'r-o','linewidth',2); hold on; grid on;
    loglog(K, MLE_mse,'k-','linewidth',2); hold on; grid on;
    loglog(K, MF_mse,'b--','linewidth',2); hold on; grid on;
    
    % do the same exact thing above for mle and mse
    % LINE
    set(gca,'FontSize',20,'YMinorGrid','off');
    xlabel('Sample size');
    ylabel('MSE');
    text(10,2*10^3,[Word1 '--' Word2],'Color','r','FontWeight','Bold','FontSize',20);
    legend('IPS','MLE','MF');
end

