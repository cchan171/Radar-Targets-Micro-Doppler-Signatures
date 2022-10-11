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

% load(fullfile("data","generated data_1.mat"))   % radar signal without car
load(fullfile("data","generated data_2.mat"))   % radar signal with car

%% transpose the label array from row vector to column vector
x = x';

%% STFT of radar to generate the MD signature
M = [20,200,2000];  % FFT window length
w = ["Rectangular", "Triangular", "Bartlett", "Blackman", "Chebyshev", "Gaussian", "Hamming", "Kaiser", "Hann"];
Tsamp = 2.815315315315315e-04;  % slow time sampling interval


% for ii = 1:length(M)
for ii = 3
%     for jj = 1:length(w)
    for jj = 8
%         for tt = 1:size(xSig,3)
        for tt = 1:100
            [status, msg, msgID] = mkdir(fullfile("fig","STFT",num2str(M(ii)),w(jj)));
            [Sig, T, F] = MDSign_STFT(xSig(:,:,tt), Tsamp, M(ii), w(jj));

            % Concatenation
            if tt == 1
                SigCat = Sig;
            else
                SigCat = cat(3, SigCat, Sig);
            end

            % Plot the realization of objects    
            figure(1)
            % subplot(3,1,1)
            imagesc(T,F,Sig(:,:,1))    % SPed(:,:,1) -> (row, col, t) for radar
            xlabel("Time (s)")
            ylabel("Frequency (Hz)")
            title("Spectrogram " + x(tt) + " length=" + num2str(M(ii)) + " ", w(jj))
            axis square xy              % plot box aspect ratio = [1 1 1]
    
            saveas(gcf,"./fig/STFT/"+ M(ii) + "/" + w(jj) + "/" + num2str(tt) + ", M=" + num2str(M(ii)) + ", " + w(jj) + ".png")
            
            
            % Configure Gaussian noise level at the receiver
            rx = phased.ReceiverPreamp("Gain", 25, "NoiseFigure", 10);
            
            xRadarRec = complex(zeros(size(xSig(:,:,tt))));
            
            xRadarRec(:,:) = rx(xSig(:,:,tt));

            
            % obtain micro-Doppler signatures of the received signal by using the STFT
            [S,~,~] = MDSign_STFT(xRadarRec, Tsamp, M(ii), w(jj));

            % Concatenation
            if tt == 1
                SCat = S;
            else
                SCat = cat(3, SCat, S);
            end
            
            figure(2)
            imagesc(T,F,S(:,:,1));  % plot the realization
            axis xy
            xlabel("Time (s)")
            ylabel("Frequency (Hz)")
            title("Spectrogram with noise " + x(tt) + " length=" + num2str(M(ii)) + " ", w(jj))
    
            saveas(gcf,"./fig/STFT/"+ M(ii) + "/" + w(jj) + "/" + num2str(tt) + ", M=" + num2str(M(ii)) + ", " + w(jj) + "@ receiver.png")
        end
        close all;
%         filename = "LabelNoCar," + w(jj)+ "," + num2str(M(ii)) + ".mat";
        filename = "LabelWithCar," + w(jj)+ "," + num2str(M(ii)) + ".mat";
        save(fullfile("data",filename),"x","T","F","SigCat","SCat","Tsamp");
    end
end