%%
% remove all previous actions
clear;
close all;
clc;

addpath("./src/");
addpath("./data/NoCa/");

%% Classify Signatures without Car Noise
M = 200;
w = ["Rectangular", "Triangular", "Bartlett", "Blackman", "Chebyshev", "Gaussian", "Hamming", "Kaiser", "Hann"];

for tt = 1:length(w)
% for tt = 1:1    % for demo  

    % load datasets
    filename = "LabelNoCar," + w(tt) + ",200.mat";
    load(fullfile("data", "NoCar", filename))    % load datasets

    % Reshape and separate the datasets
    % 80% for training, 20% for testing
    data_size = size(SCat,3);
    train_size = data_size * 0.8;
    
    % trained_data = SCat(:,:,1:train_size);
    trained_label = categorical(x(1:train_size));
    % tested_data = SCat(:,:,train_size+1:data_size);
    tested_label = categorical(x(train_size+1:data_size));
    
    
    for ii = 1:train_size
        if ii == 1
            trained_data = SCat(:,:,ii,1);
        else
            trained_data = cat(4,trained_data,SCat(:,:,ii,1));
        end
    end
    
    for ii = train_size+1:data_size
        if ii == train_size+1
            tested_data = SCat(:,:,ii,1);
        else
            tested_data = cat(4,tested_data,SCat(:,:,ii,1));
        end
    end

    % Network Architecture
    layers = [
        imageInputLayer([size(SCat,1),size(SCat,2),1], "Normalization","none")
    
        convolution2dLayer(10,16,"Padding","same")
        batchNormalizationLayer
        sigmoidLayer
        maxPooling2dLayer(10, "Stride", 2)
    
        convolution2dLayer(5,32,"Padding","same")
        batchNormalizationLayer
        sigmoidLayer
        maxPooling2dLayer(10, "Stride", 2)
    
        convolution2dLayer(5,32,"Padding","same")
        batchNormalizationLayer
        sigmoidLayer
        maxPooling2dLayer(10, "Stride", 2)
    
        convolution2dLayer(5,32,"Padding","same")
        batchNormalizationLayer
        sigmoidLayer
        maxPooling2dLayer(5, "Stride", 2)
    
        convolution2dLayer(5,32,"Padding","same")
        batchNormalizationLayer
        sigmoidLayer
        averagePooling2dLayer(2, "Stride", 2)
    
        fullyConnectedLayer(3)
        softmaxLayer
    
        classificationLayer
    ];

    % Specifies optimization solver
    options = trainingOptions("adam", ...
        "ExecutionEnvironment", "GPU", ...
        "MiniBatchSize",30, ...
        "MaxEpochs",60, ...
        "InitialLearnRate",1e-2, ...
        "LearnRateSchedule","piecewise", ...
        "LearnRateDropFactor",0.1, ...
        "LearnRateDropPeriod",10, ...
        "Shuffle","every-epoch", ...
        "Verbose",false, ...
        "Plots","training-progress");
    
    % Train the CNN
    trainedNetNoCar = trainNetwork(trained_data,trained_label,layers,options);
    
    saveas(gcf,fullfile("fig", "train_progress", "train_progress_" + w(tt) + "2.png"))
    % Classification
    predTestLabel = classify(trainedNetNoCar,tested_data);
    testAccuracy = mean(predTestLabel == tested_label)
    
    figure
    confusionchart(tested_label,predTestLabel)
    title("STFT " + w(tt))
    saveas(gcf, "test_"+w(tt)+"2.png")

    save(fullfile("saved_weights","STFT_"+ w(tt)+"2.mat"),"trainedNetNoCar","testAccuracy")
    close all;
end

%% batch size = 8, epoch = 100

% Rectangular
% testAccuracy =    0.9150
% 
% Triangular
% testAccuracy =    0.9550
% 
% Bartlett
% testAccuracy =    0.9300
% 
% Blackman
% testAccuracy =    0.9300
% 
% Chebyshev
% testAccuracy =    0.9150
% 
% Gaussian
% testAccuracy =    0.9400
% 
% Hamming
% testAccuracy =    0.9300
% 
% Kaiser
% testAccuracy =    0.9200
% 
% Hann
% testAccuracy =    0.9600



%% batch size = 30, epoch = 60

% Rectangular
% testAccuracy =    0.8950
% 
% Triangular
% testAccuracy =    0.9350
% 
% Bartlett
% testAccuracy =    0.9000
% 
% Blackman
% testAccuracy =    0.9350
% 
% Chebyshev
% testAccuracy =    0.9000
% 
% Gaussian
% testAccuracy =    0.9400
% 
% Hamming
% testAccuracy =    0.9200
% 
% Kaiser
% testAccuracy =    0.9100
% 
% Hann
% testAccuracy =    0.9250


%% Uncompleted CWT part
% filename = "LabelNoCar,CWT.mat";
% load(fullfile("data", filename))    % load datasets
% 
% %% Reshape and separate the datasets
% % 80% for training, 20% for testing
% data_size = size(SCat,3);
% train_size = data_size * 0.8;
% 
% % trained_data = SCat(:,:,1:train_size);
% trained_label = categorical(x(1:train_size));
% % tested_data = SCat(:,:,train_size+1:data_size);
% tested_label = categorical(x(train_size+1:data_size));
% 
% 
% for ii = 1:train_size
%     if ii == 1
%         trained_data = SCat(:,:,ii,1);
%     else
%         trained_data = cat(4,trained_data,SCat(:,:,ii,1));
%     end
% end
% 
% for ii = train_size+1:data_size
%     if ii == train_size+1
%         tested_data = SCat(:,:,ii,1);
%     else
%         tested_data = cat(4,tested_data,SCat(:,:,ii,1));
%     end
% end
% 
% %% Network Architecture
% layers = [
%     imageInputLayer([size(SCat,1),size(SCat,2),1], "Normalization","none")
% 
%     convolution2dLayer(10,16,"Padding","same")
%     batchNormalizationLayer
%     sigmoidLayer
%     maxPooling2dLayer(10, "Stride", 2)
% 
%     convolution2dLayer(5,32,"Padding","same")
%     batchNormalizationLayer
%     sigmoidLayer
%     maxPooling2dLayer(10, "Stride", 2)
% 
%     convolution2dLayer(5,32,"Padding","same")
%     batchNormalizationLayer
%     sigmoidLayer
%     maxPooling2dLayer(10, "Stride", 2)
% 
%     convolution2dLayer(5,32,"Padding","same")
%     batchNormalizationLayer
%     sigmoidLayer
%     maxPooling2dLayer(5, "Stride", 2)
% 
%     convolution2dLayer(5,32,"Padding","same")
%     batchNormalizationLayer
%     sigmoidLayer
%     maxPooling2dLayer(5, "Stride", 2)
% 
%     convolution2dLayer(2,64,"Padding","same")
%     batchNormalizationLayer
%     sigmoidLayer
%     averagePooling2dLayer(2, "Stride", 2)
% 
%     fullyConnectedLayer(3)
%     softmaxLayer
% 
%     classificationLayer
% ];
% 
% % Specifies optimization solver
% options = trainingOptions("adam", ...
%     "ExecutionEnvironment", "GPU", ...
%     "MiniBatchSize",128, ...
%     "MaxEpochs",200, ...
%     "InitialLearnRate",1e-2, ...
%     "LearnRateSchedule","piecewise", ...
%     "LearnRateDropFactor",0.1, ...
%     "LearnRateDropPeriod",10, ...
%     "Shuffle","every-epoch", ...
%     "Verbose",false, ...
%     "Plots","training-progress");
% 
% %% Train the CNN
% trainedNetNoCar = trainNetwork(trained_data,trained_label,layers,options);
% 
% saveas(gcf,fullfile("fig", "train_progress", "train_progress_CWT.png"))
% %% Classification
% predTestLabel = classify(trainedNetNoCar,tested_data);
% testAccuracy = mean(predTestLabel == tested_label)
% 
% figure
% confusionchart(tested_label,predTestLabel)
% title("CWT")
% saveas(gcf, "test_CWT.png")
% 
% save(fullfile("saved_weights","STFT_"+ w(tt)+".mat"),"trainedNetNoCar","testAccuracy")
% close all;
