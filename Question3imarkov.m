clear all;% this clears variables from the workspace

rng(345)
%create z grid
    %notice that here, we don't have persistent, rho=0
 %generate the z grid first
sigma_e=sqrt(0.05);
rho=0;
znum=10; %grid
[z_grid,P] = tauchen(rho,sigma_e,znum,1);  


% Section 1: Functional Forms

     sigma=2;  % c^(1-sigma)/(1-sigma)
     beta=.9;
     r=1/beta-1;

% Life span     

T=10;

% wage vector

wvector=[0.5 0.5 ...
    0.75 0.75...
    1 1 ...
    0.75 0.75...
    0.25 0.25];

% Asset grid
Amin=0;
Amax=1;
n=300;
A=linspace(Amin,Amax,n);

%saving level for all shocks
Aa=kron(A,ones([znum,1]))';

Z=1+z_grid; %normalize

%income matrix for every state of shocks and all grid

%V=zeros(n,T);
%g=zeros(n,T-1);

%at the last period C=A+h*z
    %value function for all A grids and all z values
Vv=zeros([n,znum]);
I_mean=wvector(T)*ones([n,znum]);

Zz=kron(Z,ones([n,1]));
%stochastic income 
Ii=I_mean.*Zz;

%consumption for all a all shocks at T 
    %C=saving+stochastic income
Cc=Aa+Ii;
Uu=(Cc.^(1-sigma))/(1-sigma);
Vv=Uu;

EV=(P*Vv')'; %expected value of each state at T-1 for each A grid policy


V_pol=zeros([n,znum,T]);
g_pol=zeros([n,znum,T]);

for d=1:10

%for T-1, need to find for all z grid 
for t=1:T-1
I_mean=wvector(T-t)*ones([n,znum]);
%stochastic income 
Ii=I_mean.*Zz;
for i=1:n
    A_prevous=ones([n,znum])*A(1,i);
    Cc=A_prevous+Ii-Aa/(1+r);
    Uu=(Cc.^(1-sigma))/(1-sigma);
    Uu(Cc<0)=-10000;
    Vv=Uu+beta*EV;
    [Vmax(i,1:znum) gmax(i,1:znum)] = max(Vv);
end
    %%store policy value
    EV=(P*Vmax')';
    V_pol(:,:,T-t)=Vmax;
    g_pol(:,:,T-t)=gmax;
end 

%gererate one person first
[z_mock,i_z_mock]=mcdraws(Z,P,10,0,100);

A_index=linspace(1,n,n);

a_store=zeros([1,T]);
a_store_ind=ones([1,T]);
for t=2:T
loca_a=a_store_ind(1,t-1);
loca_z=i_z_mock(t-1,1);
a_store_ind(1,t)=g_pol(loca_a,loca_z,t-1);
a_store(1,t)=A(1,a_store_ind(1,t));
end

a_store_r(d,:)=a_store(1,:);

%income 
I_mock=wvector.*z_mock';
I_mock_r(d,:)=I_mock(1,:);

%saving
save_mock=zeros([1,T]);
save_mock(1,1:T-1)=a_store(1,2:T);
save_mock_r(d,:)=save_mock(1,:);

c_mock=a_store+I_mock-save_mock;
c_mock_r(d,:)=c_mock(1,:);

end

a_store_r=a_store_r';
I_mock_r=I_mock_r';
save_mock_r=save_mock_r';
c_mock_r=c_mock_r';

m=matfile("deter.mat")
Copt_deter=m.Copt_deter;
assetlevel_deter=m.assetlevel_deter;
savingdec_deter=m.savingdec_deter;
wvector_deter=m.wvector_deter;

plot(c_mock_r);
hold on
plot(Copt_deter,'color','blue','LineWidth',6);xlabel('Time');ylabel('Consumption');title('Consumption according to shocks on wages');grid on
hold off
saveas(gcf,'q3icons','png')
figure

plot(a_store_r);
hold on
plot(assetlevel_deter,'color','blue','LineWidth',6);xlabel('Time');ylabel('Asset level');title('Asset level according to shocks on wages');grid on
hold off
saveas(gcf,'q3iasset','png')
figure

plot(save_mock_r);
hold on
plot(savingdec_deter,'color','blue','LineWidth',6);xlabel('Time');ylabel('Savings');title('Savings according to shocks on wages');grid on
hold off
saveas(gcf,'q3isavings','png')
figure

plot(I_mock_r);
hold on
plot(wvector_deter,'color','blue','LineWidth',6);xlabel('Time');ylabel('Income');title('Income according to shocks on wages');grid on
hold off
saveas(gcf,'q3isavings','png')
figure

subplot(2,2,1)
plot(c_mock_r);
hold on
plot(Copt_deter,'color','blue','LineWidth',6);xlabel('Time');ylabel('Consumption');grid on
hold off

subplot(2,2,2)
plot(a_store_r);
hold on
plot(assetlevel_deter,'color','blue','LineWidth',6);xlabel('Time');ylabel('Asset level');grid on
hold off

subplot(2,2,3)
plot(save_mock_r);
hold on
plot(savingdec_deter,'color','blue','LineWidth',6);xlabel('Time');ylabel('Savings');grid on
hold off

subplot(2,2,4)
plot(I_mock_r);
hold on
plot(wvector_deter,'color','blue','LineWidth',6);xlabel('Time');ylabel('Income');grid on
hold off

saveas(gcf,'q3iall','png')