function n = Bruit_complexe(x, SNR, Ns, M)
%   Génère un bruit complexe d'après un rapport signal sur bruit et un
%   signal
%   n Bruit complexe
Px = mean(abs(x).^2);
sigma_n2 = (Px * Ns) / (2 * log2(M) * SNR);
sigma_n = sqrt(sigma_n2);
bruit_reel = sigma_n * randn(1, length(x));
bruit_imaginaire = sigma_n * randn(1, length(x));
n = bruit_reel + 1j*bruit_imaginaire;
end

