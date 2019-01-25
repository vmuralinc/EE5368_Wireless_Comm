function[Rician] = Rician(Tsample, Fm, K)

%N - No of multipaths
N = 70;

M = 0.5 * ((N / 2) - 1);

Wm = 2 * pi * Fm;

a = 0;

t0 = 2;

G = zeros(1,8736);
Gi = zeros(1,8736);
Gq = zeros(1,8736);

for i = 1:1:8736
    
    t = t0 + (i * Tsample);
    
    for n = 1:1:M

        Bn = n * pi / M;

        Wn = Wm * cos(2 * pi * n / N);
    
        Gi(i) = Gi(i) + (2 * cos(Bn) * cos(Wn * t));
        
        Gq(i) = Gq(i) + (2 * sin(Bn) * cos(Wn * t));

    end
    
    Gi(i) = (Gi(i) + (sqrt(2) * cos(Wm * t) * cos(a))) / sqrt(M + 1);
        
    Gq(i) = (Gq(i) + (sqrt(2) * cos(Wm * t) * sin(a))) / sqrt(M);
    
end

G = complex(Gi,Gq);

%Rayleigh 

Aric = 10 ^ (-K / 20);

Bric = 1 / sqrt(1 + Aric ^ 2);

Rician = (1 + Aric .* G) .* Bric;

%m = 1:1:8736
%subplot(2,2,1), plot(m,real(Rician));
%subplot(2,2,2), plot(m,imag(Rician));
