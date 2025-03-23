clear all
clc

% Init
sigma_mu = 7;
mean_offsets = [-0.25, -0.2, -0.15, -0.1, -0.05];

% P = 0.642;
P = 0.611;
% P = [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9];
% P = 0.5;
% P1 = 2.2e-4;
% P1 = 2.14e-4;
P1 = 2.2e-4;

N = 7;
% packet = N*1000000;
packet = 10000000;
% packet = 1000;

diff_bits_no_coding = zeros(1,length(mean_offsets));
diff_bits = zeros(1,length(mean_offsets));

% Testing MRAM with Sparse Code and Hamming Code
tic;
parfor ct = 1:length(mean_offsets)
    % Initialize local counter for each parallel worker
    local_diff_bits = 0;

    for page = 1:packet
        disp(['Processing of calculating BER at ' num2str(mean_offsets(ct)) ': ' num2str((page/packet)*100) '%'])
        
        % Generate user data
        user_data = double(rand(1,N) >= 0.5);

        % Encoding
        data_encoded = anhchi_encoder(user_data);

        % Passing code word through cascased channel
        % received_data = cascased_channel(code_word, sigma_mu(ct)/100);
        received_data = cascased_channel_with_P(data_encoded, sigma_mu/100, P1, mean_offsets(ct));

        % Decoding
        data_decoded = anhchi_decoder(received_data);

        % data_decoded = data_decoded - 1;

        % data_decoded(data_decoded == -1) = 0

        % % Calculate difference bit
        % diff_bits(1,ct) = diff_bits(1,ct) + sum(abs(user_data - data_decoded))

        % Calculate local difference bits
        local_diff_bits = local_diff_bits + sum(abs(user_data - data_decoded));
    end

    % Calculate difference bits
    diff_bits(ct) = local_diff_bits
end
toc;


% Draw BER
figure
BER_no_coding = diff_bits_no_coding/(N*packet);
% BER_sc_hm_MRAM_with_P1 = diff_bits/(N*packet);
BER_sc_hm_MRAM = diff_bits/(N*packet);

% file_name = ['BER_my_sparse_code_P_' num2str(P) '_' datetime];
% save(file_name,BER_sc_hm_MRAM);

semilogy(mean_offsets,BER_sc_hm_MRAM,'--b');
xlabel('Mean offset \mu_off')
ylabel('BER')
grid on
legend('7/9 Sparse code')
axis([-0.25 -0.05 1e-7 1e-1])