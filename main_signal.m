% remove all previous actions
clear;
close all;
clc;

addpath("./src/");
addpath("./data/");
addpath("./PedestrianAndBicyclistClassificationUsingDeepLearningExample/");
addpath("PedBicCarData");

%%

% load(fullfile("data","LabelNoCar.mat"))

%% Generate 1000 samples
% for jj = 1:length(testLabelNoCar)
for jj = 1:1000
%     labels = split(string(testLabelNoCar(jj)), "+"); % changed here
    labels = split(string(testLabelCarNoise(jj)), "+"); % changed here
    numPed = 0;
    numBic = 0;
    numCar = 0; % numCar == 1 with car noise; else, numCar == 0
    for ii = 1:length(labels)
        if labels(ii) == "ped"
            numPed = 1;
        elseif labels(ii) == "bic"
            numBic = 1;
        else
            numCar = 1;
        end
    end
    [xPedRec,xBicRec,xCarRec,Tsamp] = Generator(numPed, numBic, numCar);

%     xSigRec = xPedRec + xBicRec;    % no car signals
    xSigRec = xPedRec + xBicRec + xCarRec;
    
    if jj == 1
        xSig = xSigRec;
        if (numPed==1) && (numBic==1)
            x = "ped+bic";
        else
            if numPed == 1
                x = "ped";
            else
                x = "bic";
            end
        end
    else
        xSig = cat(3, xSig, xSigRec);
        if (numPed==1) && (numBic==1)
            x(end+1) = "ped+bic";
        else
            if numPed == 1
                x(end+1) = "ped" ;
            else
                x(end+1) = "bic";
            end
        end
    end
    fprintf("Loop number %d completed\n", jj);
end

save("generated data_2.mat","xSig","x","-v7.3");