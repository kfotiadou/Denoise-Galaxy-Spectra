clc;clear all;close all

%% LOAD DATA
% addpath('Dictionaries')
% addpath('Data')
load Dicts_medium_snr_noisy_clean_data.mat
load('Original_region_of_interest');
load('Mid_SNR_Noisy_region_of_interest');

%% TEST DATA
lambda = 0.1; %sparsity regularization term

h1=figure('units','normalized','outerposition',[0 0 1 1]);
for kk = 1:100
    tic;
    [reconstructed_signal_from_Mid_SNR] = Sc_Denoising(Mid_SNR_Noisy_region_of_interest(:,kk), D_clean_high_snr, D_noisy_high_snr, lambda);
    t=toc;
    reconstructed_signal_from_Mid_SNR = reconstructed_signal_from_Mid_SNR./repmat(sqrt(sum(reconstructed_signal_from_Mid_SNR.^2, 1)), size(reconstructed_signal_from_Mid_SNR,1), 1);
    Err = (Original_region_of_interest(:,kk) - reconstructed_signal_from_Mid_SNR).^2;
    rmse1 = sqrt(mean(Err(:)));

    figure(h1); clf;
    subplot(1,3,1);
    plot(Original_region_of_interest(:,kk),'b'); axis([1,4000,-0.2,+0.4]); title('Clean Signal');
    subplot(1,3,2);
    plot(Mid_SNR_Noisy_region_of_interest(:,kk),'k'); axis([1,4000,-0.2,+0.4]); title('Noisy Signal');
    subplot(1,3,3);
    plot(reconstructed_signal_from_Mid_SNR,'r'); axis([1,4000,-0.2,+0.4]); title(sprintf('Recovered Signal @ %.4f (%.2f sec)',rmse1,t));

    pause(1);
end


