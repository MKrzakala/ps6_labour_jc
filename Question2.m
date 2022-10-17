%% Question 2

clear;

cd 'C:\Users\mpkrz\OneDrive - SGH\Dokumenty\GitHub\ps6_labour_jc'

ybart=1;

rng(0,'twister');

ybar1=1+(sqrt(0.38))*randn(1000,1);

selection=unidrnd(1000);

y1=ybar1(selection);


z=nan(60,1);

z(1)=y1-1;

z1=z(1);

gamma=0.96;
sigma2epsilon=0.045;

for j=2:60
    z(j)=gamma*z(j-1)+(sqrt(sigma2epsilon))*randn(1,1);
end

plot(z)

%% Aproximation of the process through a Markov Chain

[y,p]=tauchen(0.99,0.045,18);

[zmarkov,ind]=mcdraws(y,p,60,z1,500);

subplot(1,2,1)
plot(z); grid on;
xlabel('Length','Interpreter','latex','fontsize',12)
ylabel('z','Interpreter','latex','fontsize',12)
%set(gca,'Color',[0 0.4470 0.7410])

subplot(1,2,2)
plot(zmarkov); grid on;
xlabel('Length','Interpreter','latex','fontsize',12)
ylabel('zmarkov','Interpreter','latex','fontsize',12)
%set(gca,'Color',[0 0.4470 0.7410])

plot(zmarkov)

