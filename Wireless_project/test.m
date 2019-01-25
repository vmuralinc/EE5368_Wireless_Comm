clear all
signal = randn(1,8736);

Rician = Rayliegh(5.7*10^-8,20,7);

Rician1 = filter(ricianchan(5.7*10^-8,20,7),signal);

Rician2 = Rician .* signal;

x = 1:1:8736;
subplot(2,1,1), plot(x,Rician1,'r-')
subplot(2,1,2), plot(x,Rician2,'b--');
result=(Rician1==Rician2);