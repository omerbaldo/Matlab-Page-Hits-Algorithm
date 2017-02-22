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
    for m = 1:10^3
        ind = randsample(N,max(K));             % returns max(K)=10000 by 1 vector of random points from 1 to n
                                                % return column vector of random rows/document indexes 
        S1 = W1(ind); S2 = W2(ind);             % return random points 
        for i = 1:length(K)
            s1 = S1(1:K(i));
            s2 = S2(1:K(i));
            n11 = sum(s1==1 & s2==1);
            % LINE
            
            % never be 0 cause that gives an error
            n11 = n11+0.1;n12 = n12+0.1;
            n21 = n21+0.1;n22 = n22+0.1;
            n = n11+n12+n21+n22;
            M1 = sum(W1); M2 = sum(W2);
            ips = Est_IPS(n11,n12,n21,n22,M1,M2,N,20); % prev algorithm
            IPS(m,i) = ips(end);
            %MF(m,i) = LINE
            %LINE
        end
    end
    
    N11 = sum(W1.*W2);            % theroretical value3
    IPS_mse = mean( (IPS - N11).^2);
    % LINE
    figure;
    loglog(K, IPS_mse,'r-o','linewidth',2); hold on; grid on;
    % LINE
    set(gca,'FontSize',20,'YMinorGrid','off');
    xlabel('Sample size');
    ylabel('MSE');
    text(20,2*10^4,[Word1 '--' Word2],'Color','r','FontWeight','Bold','FontSize',20);
    % make sure to include a legend
end

