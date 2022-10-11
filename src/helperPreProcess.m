function S = helperPreProcess(S)
%helperPreProcess converts each spectrogram into log-scale and normalizes
%each log-scale spectrogram/scalogram
%to [0,1].
    
    S = 10*log10(abs(S)); % logarithmic scaling to dB
    for ii = 1:size(S,3)
        zs = S(:,:,ii);
        zs = (zs - min(zs(:)))/(max(zs(:))-min(zs(:))); % normalize amplitudes of each map to [0,1]
        S(:,:,ii) = zs;
    end
end