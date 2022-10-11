function [S,T,F] = MDSign_STFT(x, Tsamp, M, w)
% Referring to helperDopplerSignatures provided from Matlab official

    %% STFT parameters
    switch w
        case "Rectangular"
            win = rectwin(M);
        case "Triangular"
            win = triang(M);
        case "Bartlett"
            win = bartlett(M);
        case "Blackman"
            win = blackman(M);
        case "Chebyshev"
            win = chebwin(M);   % ripple set as default 100 dB
        case "Gaussian"
            win = gausswin(M);
        case "Hamming"
            win = hamming(M);
        case "Kaiser"
            win = kaiser(M);
        case "Hann"
            win = hann(M);
        otherwise
            fprintf("Wrong window keyword" + w);
            return
    end
       
    beta = 6;   % shape factor for original kaiser window, keep it for the same overlapping
    R = floor(1.7*(M-1)/(beta+1));
    noverlap = M - R;

    %% STFT process
    % sum(x,1) is a column vector containing the sum of each row
    [S,F,T] = stft(squeeze(sum(x,1)),1/Tsamp,'Window',win,'FFTLength',M*2,'OverlapLength',noverlap);
    S = helperPreProcess(S);    % preprocessing of the spectrogram
end
