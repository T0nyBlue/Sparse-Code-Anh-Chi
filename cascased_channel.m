function [readDecisionErrors] = cascased_channel(data, spm_rate)
    % Parameters
    p0 = 1e-6;  % Error probability for 1 -> 0
    p1 = 1.02e-4;   % Error probability for 0 -> 1
    
    q0 = 1-p0;
    q1 = 1-p1;

    mean0 = 1;     % Mean for R0
    mean1 = 2;     % Mean for R1
    
    % 1. Passing bits throught write error model BAC then the read disturb error model Z
    writeErrors = data;  % Copy of data for processing
    
    for i = 1:length(data)
        if data(i) == 0
            if rand <= p0
                writeErrors(i) = 1;  % 0 -> 1 error
            end
        elseif data(i) == 1
            if rand >= q1
                writeErrors(i) = 0;  % 1 -> 0 error
            end
        end
    end

    readDisturbErrors = writeErrors;
    
    % 2. Read decision error using Gaussian Mixture Channel (GMC)
    readDecisionErrors = readDisturbErrors;

    % Calculate Sigma from spm_rate
    sigma0 = mean0*spm_rate;
    sigma1 = mean1*spm_rate;
    
    % Apply Gaussian noise based on bit values
    for i = 1:length(data)
        if readDisturbErrors(i) == 0
            readDecisionErrors(i) = normrnd(mean0, sigma0);  % Gaussian noise for R0
        else
            readDecisionErrors(i) = normrnd(mean1, sigma1);  % Gaussian noise for R1
        end
    end
end