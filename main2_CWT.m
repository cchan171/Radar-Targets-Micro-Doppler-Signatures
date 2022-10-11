% remove all previous actions
clear;
close all;
clc;

addpath("./src/");

%% Synthetic data generation by simulation
% numPed = 1;
% numBic = 1;
% numCar = 1;
% [xPedRec, xBicRec, xCarRec, Tsamp] = helperBackScatterSignals(numPed, numBic, numCar);

%% Load Synthetic data from generated radar signals

load(fullfile("generated data_1.mat"))

%% transpose the label array from row vector to column vector
x = x';

%%  CWT of radar to genearte the MD signature


Tsamp = 2.815315315315315e-04;  % sampling duration
fsamp = 1/Tsamp;                % sampling frequency

for tt = 1:size(xSig,3)
% for tt = 1:1  % for demo
    [status, msg, msgID] = mkdir(fullfile("fig","CWT"));
    [SigP, F] = MDSign_CWT(xSig(:,:,tt), fsamp);

    if tt == 1
        SigCat = SigP;
    else
        SigCat = cat(3, SigCat, SigP);
    end
    
    sigLen = numel(xSig(:,:,1));
    T = (0:sigLen-1)/fsamp;
    T = (T*2)/1000; % normalized in 2 secs for x axis

    % plot 
    figure(1)
    imagesc(T,F,SigP);
    xlabel('Time (s)');
    ylabel('Frequency (Hz)')
    title('Scalogram ' + x(tt));
    axis square xy

    saveas(gcf,"./fig/CWT/"+ num2str(tt) + ".png")

    % Configure Gaussian noise level at the receiver
    rx = phased.ReceiverPreamp("Gain", 25, "NoiseFigure", 10);
    
    xRadarRec = complex(zeros(size(xSig(:,:,tt))));
    
    xRadarRec(:,:) = rx(xSig(:,:,tt));

    % obtain micro-Doppler signatures of the received signal by using the
    % CWT
    [S,~] = MDSign_CWT(xRadarRec, fsamp);

    % Concatenation
    if tt == 1
        SCat = S;
    else
        SCat = cat(3, SCat, S);
    end

    % plot 
    figure(2)
    imagesc(T,F,SigP);
    xlabel('Time (s)');
    ylabel('Frequency (Hz)')
    title('Scalogram ' + x(tt));
    axis square xy

    saveas(gcf,"./fig/CWT/"+ num2str(tt) + "@ receiver.png")

end
close all;
%%

filename = "LabelNoCar,CWT";
save(fullfile("data",filename),"x","T","F","SigCat","SCat","Tsamp","-v7.3");


