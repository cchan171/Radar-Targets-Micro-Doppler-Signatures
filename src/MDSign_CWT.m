function [SP,F] = MDSign_CWT(x, fsamp)
% Referring to helperDopplerSignatures provided from Matlab official
    
    %% CWT process
    [S,F] = cwt(squeeze(sum(x,1)),fsamp);
    SP = S(:,:,1);  % positive scales (analytic part or counterclockwise component)
%     SN = S(:,:,2);  % negative scales (anti-analytic part or clockwise component)

    SP=helperPreProcess(SP); % process data for plotting
end