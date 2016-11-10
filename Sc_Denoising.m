function [denoised] = Sc_Denoising(noisy_in, Dh, Dl, lambda)


%% Initialization %%%%
denoised = zeros([size(noisy_in,1),size(noisy_in,2)]);

for jj = 1:size(noisy_in,2),
          jj/size(noisy_in,2)

        noisy_part = noisy_in(:,jj);
       
       % Calculate the norm
        mNorm = sqrt(sum(noisy_part(:).^2));

        % And normalize the input noisy signal
        if mNorm ~= 0 
            y = double(noisy_part)./double(mNorm);
        else
            y = double(noisy_part);
        end        
        % Solve the sparse decomposition problem, to find the sparse
        % coefficients
%         w=SolveOMP(Dl, y, size(Dl,2), lambda);
         w=SolveLasso(Dl, y, size(Dl,2),'nnlasso',lambda);
        
        % Map to the clean high resolution Dictionary 
%         denoised_sig = Dh* w;
        denoised_sig = Dh* w *mNorm;
        denoised(:,jj) =  denoised_sig;

end

