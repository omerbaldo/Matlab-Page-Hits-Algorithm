function TestIPSandMLE
    M1 = 300; M2=500; N = 2000;
    n11 = round(rand*20+10); n12 = round(rand*40+20);
    n21 = round(rand*80+40); n22 = round(rand*150+75);
    iter = 20;
    %{
        Debugging
    
            Ask : How do I zoom in so that the x axis is 2-10
    %}
        
    IPS = Est_IPS(n11,n12,n21,n22,M1,M2,N,iter);
    MLE = Est_MLE(n11,n12,n21,n22,M1,M2,N,iter);
    figure;
    semilogy(2:iter, abs(IPS(2:end)-IPS(1:end-1)),'r-o','linewidth',2);
    hold on; grid on;
    semilogy(2:iter, abs(MLE(2:end)-MLE(1:end-1)),'b-d','linewidth',2);
    title(num2str([n11 n12 n21 n22]));
    set(gca,'FontSize',20); xlabel('Iteration'); ylabel('Convergence error');
    legend('IPS','MLE');
end