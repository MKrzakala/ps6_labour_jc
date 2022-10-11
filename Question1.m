
cd 'C:\Users\ACER\OneDrive\QEM\Tercer semestre\Clases\Labor\Set6'

T=readtable('data.xlsx','Range','A4:G123');

Table=table2array(T(:,1:end));

Age=Table(:,1);
Proba=Table(:,2);
SurvivalProb=(1-Proba);
CondProbS=NaN;

for k=2:length(Age)
    CondProbS(k)=SurvivalProb(k)/SurvivalProb(k-1);
end

CondProbS=CondProbS';

mu=zeros(length(Age),1);

Fraction24yo=0.01675;
n1=0.02;

mu(26)=(Fraction24yo*CondProbS(26))*(1/(1+n1));

for j=27:length(Age)
    mu(j)=(mu(j-1)*CondProbS(j))*(1/(1+n1));
end

plot(mu)

n2=0.01;

mu2=zeros(length(Age),1);
mu2(26)=(Fraction24yo*CondProbS(26))*(1/(1+n2));

for j=27:length(Age)
    mu2(j)=(mu2(j-1)*CondProbS(j))*(1/(1+n2));
end

plot(mu2)

plot(mu(26:91))
hold on
plot(mu2(26:91))
hold off











