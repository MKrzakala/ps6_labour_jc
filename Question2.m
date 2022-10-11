%% Question 2

clear;

ybart=1;

rng(0,'twister');

ybar1=1+(sqrt(0.38))*randn(1000,1);

selection=unidrnd(1000);

y1=ybar1(selection);

z=nan(60,1);

z(1)=y1-1;

gamma=0.96;
sigma2epsilon=0.045;

for j=2:60
    z(j)=gamma*z(j-1)+(sqrt(sigma2epsilon))*randn(1,1);
end

plot(z)






