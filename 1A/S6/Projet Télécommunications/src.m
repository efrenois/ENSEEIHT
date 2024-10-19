clear all;
close all;

%% Paramètres du problème 

Fe = 24000; % Fréquence d'échantillonage 
Te = 1/Fe; % Période d'échantillonage 

alpha  = 0.35; % Roll off du cosinus surélevé 
L = 7; % Span

Rb = 3000; % Débit binaire 
Tb = 1/Rb; 

Ts = 2*Tb; % Période symbole
Ns = floor(Ts/Te); % Nombre de symbole 

Fp = 2000; % Fréquence porteuse 

nbits = 10000; % Nombre de bits
bits = randi([0 1],1,nbits);

ak = 1 - 2 * bits(1:2:end); % Mapping de ak
bk = 1 - 2 * bits(2:2:end); % Mapping de bk

dk = ak + 1j * bk; % Calcul de dk

h = rcosdesign(alpha,L, Ns); % Filtre de mise en forme 

xk = [kron(dk,[1 zeros(1,Ns-1)]) zeros(1, length(h))]; % Peigne de dirac 

signal_filtre = filter(h,1,xk); % Signal filtré 
I = real(signal_filtre); % Signal sur la voie en phase 
Q = imag(signal_filtre); % Signal sur la voie en quadrature 


% Tracé des signaux générés sur les voies en phase et en quadrature
figure(1);
subplot(2,1,1);
plot(I);
xlabel("Temps(s)");
ylabel("Amplitude");
title("Signal généré sur la voie en phase");
grid on;
subplot(2,1,2);
plot(Q);
xlabel("Temps(s)");
ylabel("Amplitude");
title("Signal généré sur la voie en quadrature");
grid on;

% Calcul de x(t)
temps = 0:Te:(length(signal_filtre)-1)*Te;
x = real(signal_filtre .* exp(1j*2*pi*Fp*temps));

% Tracé du signal transmis sur fréquence porteuse
figure(2);
plot(x);
xlabel("Temps(s)");
ylabel("Amplitude");
title("Signal transmis sur fréquence porteuse");
grid on;

% Densité spectrale de puissance du signal transmis sur fréquence porteuse
dsp_signal = pwelch(x, [], [], [], Fe, 'twosided');
echelle_frequentielle = linspace(-Fe/2,Fe/2,length(dsp_signal));

% Tracé de la densité spectrale de puissance du signal transmis sur fréquence porteuse
figure(3);
semilogy(echelle_frequentielle,fftshift(abs(dsp_signal)));
xlabel("Fréquence(Hz)");
ylabel("Puissance");
title("Densité spectrale de puissance du signal transmis sur fréquence porteuse");
grid on;

% Explication du tracé de la dsp sur le rapport 

% Simulation avec du bruit 
SNRdB = linspace(0,6,12);
TEB_simule = zeros(1, length(SNRdB));
TEB_theorique  = zeros(1, length(SNRdB));
SNR = 10 .^ (SNRdB / 10);

for i = 1:length(SNR)

    n = Bruit_gaussien(x, SNR(i), Ns, 4); % ajout du bruit additif et gaussien 
    signal_bruite = x + n; % signal bruité

    % Démodulation
    x_cos = signal_bruite.*cos(2*pi*Fp*temps);
    x_sin = signal_bruite.*sin(2*pi*Fp*temps);

    % Signal à démoduler en bande de base
    signal_complex = x_cos - 1j*x_sin;

    h_r = h; % filtre de réception adapté 

    signal_z = filter(h_r,1,signal_complex);

    % Echantillonnage du signal en sortie de filtre de réception 
    signal_z_echant = signal_z(length(h):Ns:length(signal_z)-1);


    % Démapping
    bits_estim(1:2:nbits) = real(signal_z_echant) < 0;
    bits_estim(2:2:nbits) = imag(signal_z_echant) < 0;

    erreur = abs(bits - bits_estim);
    TEB_simule(i) = mean(erreur);
    TEB_theorique(i) = qfunc(sqrt(2*SNR(i)));

end 

% Tracé de comparaison du TEB simulé avec le TEB théorique de la chaine étudiée
figure(4);
semilogy(SNRdB, TEB_simule);
hold on;
semilogy(SNRdB, TEB_theorique);
xlabel("SNR (dB)");
ylabel("TEB");
title("TEB en fonction de SNR");
leg = legend('TEB simulé','TEB théorique','Location','NorthWest');
grid on; 


%% Partie 3 : Implantation de la chaine passe-bas équivalente à la chaine de transmission sur porteuse précédente

Fe_pb = 6000; % Fréquence d'échantillonage de la chaîne passe bas
Te_pb = 1/Fe_pb; % Période d'échantillonage de la chaîne passe bas 

% QUESTION 1 
x_reel = real(signal_filtre); % Signal sur la voie en phase 
x_im = imag(signal_filtre); % Signal sur la voie en quadrature 

% Tracé des signaux générés sur les voies en phase et en quadrature
figure(5);
subplot(2,1,1);
plot(x_reel);
xlabel("Temps(s)");
ylabel("Amplitude");
title("Signal généré sur la voie en phase");
grid on;
subplot(2,1,2);
plot(x_im);
xlabel("Temps(s)");
ylabel("Amplitude");
title("Signal généré sur la voie en quadrature");
grid on;

% QUESTION 2
% Densité spectrale de puissance de l'enveloppe complexe associée au signal transmis sur fréquence porteuse.
dsp_signal_pb = pwelch(signal_filtre, [], [], [], Fe_pb, 'twosided');
echelle_frequentielle_pb = linspace(-Fe_pb/2,Fe_pb/2,length(dsp_signal_pb));

% Tracé de la densité spectrale de puissance de l'enveloppe complexe associée au signal transmis sur fréquence porteuse.
figure(6);
semilogy(echelle_frequentielle_pb,fftshift(abs(dsp_signal_pb)));
xlabel("Fréquence(Hz)");
ylabel("Puissance");
title("Tracé de la densité spectrale de puissance de l'enveloppe complexe associée au signal transmis sur fréquence porteuse.");
grid on;

% QUESTION 3
% Tracé de comparaison entre la DSP de l’enveloppe complexe associée au
% signal transmis sur fréquence porteuse et la DSP du signal sur fréquence porteuse
figure(7)
semilogy(echelle_frequentielle,fftshift(abs(dsp_signal))); hold on;
semilogy(echelle_frequentielle_pb,fftshift(abs(dsp_signal_pb))); hold off;
legend("DSP de l’enveloppe complexe associée au signal transmis sur fréquence porteuse", "DSP du signal sur fréquence porteuse")
title ("Comparaison des DSP")


% QUESTION 4 
% Tracé de la constellation en sortie de mapping 
figure(8);
plot(real(dk),imag(dk),'oblue','linewidth',1);
title('Constellation en sortie du mapping');
xlim([-2 2]);
ylim([-2 2]);
line(xlim, [0 0], 'Color', 'k', 'LineWidth', 0.5);
line([0 0], ylim, 'Color', 'k', 'LineWidth', 0.5);

h_r = h; % Filtre de réception

% Tracé des constallations en sortie de l échantillonneur pour différentes valeurs de Eb/N0

SNR1 = 0.1; % Rapport signal sur bruit Eb/n0
n1 = Bruit_complexe(signal_filtre, SNR1, Ns, 4);
signal_bruite1 = signal_filtre + n1; 
signal_z1 = filter(h_r,1,signal_bruite1);
signal_z1_echant = signal_z1(length(h):Ns:length(signal_z1)-1); % échantillonage 

SNR2 = 1; % Rapport signal sur bruit Eb/n0
n2 = Bruit_complexe(signal_filtre, SNR2, Ns, 4);
signal_bruite2 = signal_filtre + n2; 
signal_z2 = filter(h_r,1,signal_bruite2);
signal_z2_echant = signal_z2(length(h):Ns:length(signal_z2)-1); % échantillonage 

SNR3 = 10; % Rapport signal sur bruit Eb/n0
n3 = Bruit_complexe(signal_filtre, SNR3, Ns, 4);
signal_bruite3 = signal_filtre + n3; 
signal_z3 = filter(h_r,1,signal_bruite3);
signal_z3_echant = signal_z3(length(h):Ns:length(signal_z3)-1); % échantillonage 

SNR4 = 100; % Rapport signal sur bruit Eb/n0
n4 = Bruit_complexe(signal_filtre, SNR4, Ns, 4);
signal_bruite4 = signal_filtre + n4; 
signal_z4 = filter(h_r,1,signal_bruite4);
signal_z4_echant = signal_z4(length(h):Ns:length(signal_z4)-1); % échantillonage 

figure(9);

subplot(2,2,1);
plot(real(signal_z1_echant),imag(signal_z1_echant),'oblue','linewidth',1);
title("Constellation en sortie de l'échantilloneur pour un SNR = 0.1");
xlim([-2 2]);
ylim([-2 2]);
line(xlim, [0 0], 'Color', 'k', 'LineWidth', 0.5);
line([0 0], ylim, 'Color', 'k', 'LineWidth', 0.5);
grid on;


subplot(2,2,2);
plot(real(signal_z2_echant),imag(signal_z2_echant),'oblue','linewidth',1);
title("Constellation en sortie de l'échantilloneur pour un SNR = 1");
xlim([-2 2]);
ylim([-2 2]);
line(xlim, [0 0], 'Color', 'k', 'LineWidth', 0.5);
line([0 0], ylim, 'Color', 'k', 'LineWidth', 0.5);
grid on;

subplot(2,2,3);
plot(real(signal_z3_echant),imag(signal_z3_echant),'oblue','linewidth',1);
title("Constellation en sortie de l'échantilloneur pour un SNR = 10");
xlim([-2 2]);
ylim([-2 2]);
line(xlim, [0 0], 'Color', 'k', 'LineWidth', 0.5);
line([0 0], ylim, 'Color', 'k', 'LineWidth', 0.5);
grid on;

subplot(2,2,4);
plot(real(signal_z4_echant),imag(signal_z4_echant),'oblue','linewidth',1);
title("Constellation en sortie de l'échantilloneur pour un SNR = 100");
xlim([-2 2]);
ylim([-2 2]);
line(xlim, [0 0], 'Color', 'k', 'LineWidth', 0.5);
line([0 0], ylim, 'Color', 'k', 'LineWidth', 0.5);
grid on;

% QUESTION 5
% Simulation avec du bruit 
SNRdB_pb = linspace(0,6,12);
TEB_simule_pb = zeros(1, length(SNRdB_pb));
SNR_pb = 10 .^ (SNRdB_pb / 10);

for i = 1:length(SNR_pb)

    n = Bruit_complexe(signal_filtre, SNR_pb(i), Ns, 4); % ajout du bruit complexe 
    signal_bruite_pb = signal_filtre + n; % signal bruité

    h_r = h; % filtre de réception adapté 

    signal_z_pb = filter(h_r,1,signal_bruite_pb);

    % Echantillonnage du signal en sortie de filtre de réception 
    signal_z_echant_pb = signal_z_pb(length(h_r):Ns:length(signal_z_pb)-1);


    % Démapping
    bits_estim(1:2:nbits) = real(signal_z_echant_pb) < 0;
    bits_estim(2:2:nbits) = imag(signal_z_echant_pb) < 0;

    erreur = abs(bits - bits_estim);
    TEB_simule_pb(i) = mean(erreur);

end 

% Comparaison de ce TEB avec celui celui obtenu prècédemment sur la chaine implantée avec transposition de fréquence
figure(10);
semilogy(SNRdB_pb, TEB_simule_pb);
hold on;
semilogy(SNRdB, TEB_simule); % TEB obtenu sur la chaine implantée en transposition de fréquence
xlabel("SNR (dB)");
ylabel("TEB");
title("TEB en fonction de SNR");
leg = legend('TEB simulé passe bas équivalent','TEB simulé pour transposition de fréquence','Location','NorthWest');
grid on; 


%% Partie 4 : Comparaison du modulateur DVS-S avec un modulateur 4-ASK
% 4.1 Implantation de la modulation 4-ASK
entiers=bi2de(reshape(bits, 2, nbits/2)')'; % Mapping 4-ASK
ak_ask = pammod(entiers, 4,0, 'gray');
dk_ask = real(ak_ask); % On s'assure que bk est nul

xk_ask = [kron(dk_ask,[1 zeros(1,Ns-1)]) zeros(1, length(h))]; % Peigne de dirac 

signal_filtre_ask = filter(h,1,xk_ask); % Signal filtré


% Tracé de la constellation en sortie de mapping 
figure(11);
plot(real(dk_ask),imag(dk_ask),'oblue','linewidth',1);
title('Constellation en sortie du mapping');
xlim([-4 4]);
ylim([-4 4]);
line(xlim, [0 0], 'Color', 'k', 'LineWidth', 0.5);
line([0 0], ylim, 'Color', 'k', 'LineWidth', 0.5);

h_r = h; % Filtre de réception

% Tracé des constallations en sortie de l échantillonneur pour différentes valeurs de Eb/N0

SNR1 = 0.1; % Rapport signal sur bruit Eb/n0
n1 = Bruit_complexe(signal_filtre_ask, SNR1, Ns, 4);
signal_bruite1 = signal_filtre_ask + n1; 
signal_z1 = filter(h_r,1,signal_bruite1);
signal_z1_echant = signal_z1(length(h):Ns:length(signal_z1)-1); % échantillonage 

SNR2 = 1; % Rapport signal sur bruit Eb/n0
n2 = Bruit_complexe(signal_filtre_ask, SNR2, Ns, 4);
signal_bruite2 = signal_filtre_ask + n2; 
signal_z2 = filter(h_r,1,signal_bruite2);
signal_z2_echant = signal_z2(length(h):Ns:length(signal_z2)-1); % échantillonage 

SNR3 = 10; % Rapport signal sur bruit Eb/n0
n3 = Bruit_complexe(signal_filtre_ask, SNR3, Ns, 4);
signal_bruite3 = signal_filtre_ask + n3; 
signal_z3 = filter(h_r,1,signal_bruite3);
signal_z3_echant = signal_z3(length(h):Ns:length(signal_z3)-1); % échantillonage 

SNR4 = 100; % Rapport signal sur bruit Eb/n0
n4 = Bruit_complexe(signal_filtre_ask, SNR4, Ns, 4);
signal_bruite4 = signal_filtre_ask + n4; 
signal_z4 = filter(h_r,1,signal_bruite4);
signal_z4_echant = signal_z4(length(h):Ns:length(signal_z4)-1); % échantillonage 

figure(12);

subplot(2,2,1);
plot(real(signal_z1_echant),imag(signal_z1_echant),'oblue','linewidth',1);
title("Constellation en sortie de l'échantilloneur pour un SNR = 0.1");
xlim([-4 4]);
ylim([-4 4]);
line(xlim, [0 0], 'Color', 'k', 'LineWidth', 0.5);
line([0 0], ylim, 'Color', 'k', 'LineWidth', 0.5);
grid on;

subplot(2,2,2);
plot(real(signal_z2_echant),imag(signal_z2_echant),'oblue','linewidth',1);
title("Constellation en sortie de l'échantilloneur pour un SNR = 1");
xlim([-4 4]);
ylim([-4 4]);
line(xlim, [0 0], 'Color', 'k', 'LineWidth', 0.5);
line([0 0], ylim, 'Color', 'k', 'LineWidth', 0.5);
grid on;

subplot(2,2,3);
plot(real(signal_z3_echant),imag(signal_z3_echant),'oblue','linewidth',1);
title("Constellation en sortie de l'échantilloneur pour un SNR = 10");
xlim([-4 4]);
ylim([-4 4]);
line(xlim, [0 0], 'Color', 'k', 'LineWidth', 0.5);
line([0 0], ylim, 'Color', 'k', 'LineWidth', 0.5);
grid on;

subplot(2,2,4);
plot(real(signal_z4_echant),imag(signal_z4_echant),'oblue','linewidth',1);
title("Constellation en sortie de l'échantilloneur pour un SNR = 100");
xlim([-4 4]);
ylim([-4 4]);
line(xlim, [0 0], 'Color', 'k', 'LineWidth', 0.5);
line([0 0], ylim, 'Color', 'k', 'LineWidth', 0.5);
grid on;

% Simulation avec du bruit 
SNRdB_ask = linspace(0,6,12);
TEB_simule_ask = zeros(1, length(SNRdB_ask));
TEB_theorique_ask  = zeros(1, length(SNRdB_ask));
SNR_ask = 10 .^ (SNRdB_ask / 10);

for i = 1:length(SNR_ask)

    n = Bruit_complexe(signal_filtre_ask, SNR_ask(i), Ns, 4); % ajout du bruit additif complexe 
    signal_bruite_ask = signal_filtre_ask + n; % signal bruité

    h_r = h; % filtre de réception adapté 

    signal_z_ask = filter(h_r,1,signal_bruite_ask);

    % Echantillonnage du signal en sortie de filtre de réception 
    signal_z_echant_ask = signal_z_ask(length(h_r):Ns:length(signal_z_ask)-1);


    % Démapping
    symboles = pamdemod(signal_z_echant_ask, 4, 0, 'gray');
    bits_recup = de2bi(symboles,2);
    bits_recup = reshape(bits_recup',1, []);

    erreur_ask = abs(bits - bits_recup);
    TEB_simule_ask(i) = mean(erreur_ask);
    TEB_theorique_ask(i) = (3/4)*qfunc(sqrt((4/5)*SNR_ask(i)));

end 

% Tracé de comparaison du TEB simulé avec le TEB théorique de la chaine étudiée
figure(13);
semilogy(SNRdB_ask, TEB_simule_ask);
hold on;
semilogy(SNRdB_ask, TEB_theorique_ask);
xlabel("SNR (dB)");
ylabel("TEB");
title("TEB en fonction de SNR");
leg = legend('TEB simulé','TEB théorique','Location','NorthWest');
grid on; 


% 4.2 (Voir rapport)
% Comparaison des DSP pour les modulateurs Q-PSK et 4-ASK
dsp_signal_ask = pwelch(signal_filtre_ask, [], [], [], Fe_pb, 'twosided');
figure(14)
semilogy(echelle_frequentielle_pb,fftshift(abs(dsp_signal_ask))); hold on;
semilogy(echelle_frequentielle_pb,fftshift(abs(dsp_signal_pb))); hold off;
legend("DSP de l’enveloppe complexe associée au signal transmis sur fréquence porteuse", "DSP associée à la modulation 4-ASK")
title ("Comparaison des DSP")
% 
% % Comparaison des TEB Q-PSK et 4-ASK
figure(15);
semilogy(SNRdB_pb, TEB_simule_pb);
hold on;
semilogy(SNRdB_ask, TEB_simule_ask); % TEB obtenu sur la chaine implantée en transposition de fréquence
xlabel("SNR (dB)");
ylabel("TEB");
title("TEB en fonction de SNR");
leg = legend('TEB simulé passe bas équivalent (Q-PSK)','TEB simulé 4-ASK','Location','northeast');
grid on; 


 


 %% Partie 5 :Comparaison du modulateur DVS-S avec un des modulateurs proposés par le DVB-S2
% 5.1 Implantation de la modulation DVB-S2
alpha_8_psk = 0.20; % Roll_off 8-PSK
M = 8; % ordre de modulation


Ts_8psk = 3*Tb; % Période symbole
Ns_8psk = floor(Ts_8psk/Te); % Nombre de symbole


% Génération de l’information binaire 
bits_8_psk = randi([0, M - 1], 1, nbits);

% Utilisation de la fonction pskmod
dk_8_psk = pskmod(bits_8_psk, M, pi / M);

% Tracé de la constellation en sortie de mapping 
figure(16);
plot(real(dk_8_psk),imag(dk_8_psk),'oblue','linewidth',1);
title('Constellation en sortie du mapping');
xlim([-2 2]);
ylim([-2 2]);
line(xlim, [0 0], 'Color', 'k', 'LineWidth', 0.5);
line([0 0], ylim, 'Color', 'k', 'LineWidth', 0.5);

h_8_psk = rcosdesign(alpha_8_psk,L, Ns_8psk); % Filtre de mise en forme 

xk_8_psk = [kron(dk_8_psk,[1 zeros(1,Ns_8psk-1)]) zeros(1, length(h_8_psk))]; % Peigne de dirac 

signal_filtre_8_psk = filter(h_8_psk,1,xk_8_psk); % Signal filtré

hr_8_psk = h_8_psk; % Filtre de réception

% Tracé des constallations en sortie de l échantillonneur pour différentes valeurs de Eb/N0

SNR1 = 0.1; % Rapport signal sur bruit Eb/n0
n1 = Bruit_complexe(signal_filtre_8_psk, SNR1, Ns_8psk, 8);
signal_bruite1 = signal_filtre_8_psk + n1; 
signal_z1 = filter(hr_8_psk,1,signal_bruite1);
signal_z1_echant = signal_z1(length(h_8_psk):Ns_8psk:length(signal_z1)-1); % échantillonage 

SNR2 = 1; % Rapport signal sur bruit Eb/n0
n2 = Bruit_complexe(signal_filtre_8_psk, SNR2, Ns_8psk, 8);
signal_bruite2 = signal_filtre_8_psk + n2; 
signal_z2 = filter(hr_8_psk,1,signal_bruite2);
signal_z2_echant = signal_z2(length(h_8_psk):Ns_8psk:length(signal_z2)-1); % échantillonage 

SNR3 = 10; % Rapport signal sur bruit Eb/n0
n3 = Bruit_complexe(signal_filtre_8_psk, SNR3, Ns_8psk, 8);
signal_bruite3 = signal_filtre_8_psk + n3; 
signal_z3 = filter(hr_8_psk,1,signal_bruite3);
signal_z3_echant = signal_z3(length(h_8_psk):Ns_8psk:length(signal_z3)-1); % échantillonage 

SNR4 = 100; % Rapport signal sur bruit Eb/n0
n4 = Bruit_complexe(signal_filtre_8_psk, SNR4, Ns_8psk, 8);
signal_bruite4 = signal_filtre_8_psk + n4; 
signal_z4 = filter(hr_8_psk,1,signal_bruite4);
signal_z4_echant = signal_z4(length(h_8_psk):Ns_8psk:length(signal_z4)-1); % échantillonage 

figure(17);

subplot(2,2,1);
plot(real(signal_z1_echant),imag(signal_z1_echant),'oblue','linewidth',1);
title("Constellation en sortie de l'échantilloneur pour un SNR = 0.1");
xlim([-2 2]);
ylim([-2 2]);
line(xlim, [0 0], 'Color', 'k', 'LineWidth', 0.5);
line([0 0], ylim, 'Color', 'k', 'LineWidth', 0.5);
grid on;

subplot(2,2,2);
plot(real(signal_z2_echant),imag(signal_z2_echant),'oblue','linewidth',1);
title("Constellation en sortie de l'échantilloneur pour un SNR = 1");
xlim([-2 2]);
ylim([-2 2]);
line(xlim, [0 0], 'Color', 'k', 'LineWidth', 0.5);
line([0 0], ylim, 'Color', 'k', 'LineWidth', 0.5);
grid on;

subplot(2,2,3);
plot(real(signal_z3_echant),imag(signal_z3_echant),'oblue','linewidth',1);
title("Constellation en sortie de l'échantilloneur pour un SNR = 10");
xlim([-2 2]);
ylim([-2 2]);
line(xlim, [0 0], 'Color', 'k', 'LineWidth', 0.5);
line([0 0], ylim, 'Color', 'k', 'LineWidth', 0.5);
grid on;

subplot(2,2,4);
plot(real(signal_z4_echant),imag(signal_z4_echant),'oblue','linewidth',1);
title("Constellation en sortie de l'échantilloneur pour un SNR = 100");
xlim([-2 2]);
ylim([-2 2]);
line(xlim, [0 0], 'Color', 'k', 'LineWidth', 0.5);
line([0 0], ylim, 'Color', 'k', 'LineWidth', 0.5);
grid on;

% Simulation avec du bruit 
SNRdB_8psk = linspace(0,6,12);
TEB_simule_8psk = zeros(1, length(SNRdB_8psk));
TEB_theorique_8psk  = zeros(1, length(SNRdB_8psk));
TES = zeros(1, length(SNRdB_8psk));
SNR_8psk = 10 .^ (SNRdB_8psk / 10);

for i = 1:length(SNRdB_8psk)

    n = Bruit_complexe(signal_filtre_8_psk, SNR_8psk(i), Ns_8psk, 8); % ajout du bruit additif complexe 
    signal_bruite_8psk = signal_filtre_8_psk + n; % signal bruité

    hr_8_psk = h_8_psk; % filtre de réception adapté 

    signal_z_8psk = filter(hr_8_psk,1,signal_bruite_8psk);

    % Echantillonnage du signal en sortie de filtre de réception 
    signal_z_echant_8psk = signal_z_8psk(length(h_8_psk):Ns_8psk :length(signal_z_8psk)-1);

    % Démapping
    bits_estims_8PSK = pskdemod(signal_z_echant_8psk, M, pi/M); % Detecteur à seuil


    TES(i) = length(find(bits_estims_8PSK ~= bits_8_psk)) / length(bits_8_psk);     % Calcul du TES

    TEB_simule_8psk(i) = TES(i)/ log2(M);
    TEB_theorique_8psk(i) = (2/3)*qfunc(sqrt(6*SNR_8psk(i))*sin(pi/M));

end 
% Tracé de comparaison du TEB simulé avec le TEB théorique de la chaine étudiée
figure(18);
semilogy(SNRdB_8psk, TEB_simule_8psk);
hold on;
semilogy(SNRdB_8psk, TEB_theorique_8psk);
xlabel("SNR (dB)");
ylabel("TEB");
title("TEB en fonction de SNR");
leg = legend('TEB simulé','TEB théorique','Location','NorthWest');
grid on; 

% 5.2
% % Comparaison des DSP pour les modulateurs 8-PSK et QPSK
dsp_signal_8psk = pwelch(signal_filtre_8_psk, [], [], [], Fe_pb, 'twosided');
echelle_frequentielle_8psk = linspace(-Fe_pb/2,Fe_pb/2,length(dsp_signal_8psk));

figure(19)
semilogy(echelle_frequentielle_8psk,fftshift(abs(dsp_signal_8psk))); hold on;
semilogy(echelle_frequentielle_pb,fftshift(abs(dsp_signal_pb))); hold off;
legend("DSP 8-PSK", "DSP associée à la modulation Q-PSK")
title ("Comparaison des DSP")                                       
 
% % Comparaison des TEB QPSK et 8-PSK
figure(20);
semilogy(SNRdB_pb, TEB_simule_pb);
hold on;
semilogy(SNRdB_8psk, TEB_simule_8psk); 
xlabel("SNR (dB)");
ylabel("TEB");
title("TEB en fonction de SNR");
leg = legend('TEB simulé QPSK','TEB simulé 8-PSK','Location','NorthWest');
grid on; 