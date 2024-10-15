clear all
clc

% Init
sigma_mu = [8 9.5 11 12 13 14 15 16];

P = 0.642;
% P = [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9];
% P = 0.5;
P1 = 2.2e-4;

N = 54;
packet = N*1000000;

diff_bits_no_coding = zeros(1,length(sigma_mu));
diff_bits = zeros(1,length(sigma_mu));

% Testing MRAM with Sparse Code and Hamming Code
tic;
for ct = 1:length(sigma_mu)
    for page = 1:packet
        disp([num2str((ct/length(sigma_mu) + page/packet)*100) '%'])
        % Generate user data
        user_data = double(rand(1,N) >= 0.5);

        % Modulate user data using sparse code
        user_data_sparsecode_modulation = my_sparse_code_encoder(user_data);
        
        % Encode using hamming code
        code_word = hamming_code_57p63_encoder(user_data_sparsecode_modulation);

        % Passing code word through cascased channel
        % received_data = cascased_channel(code_word, sigma_mu(ct)/100);
        received_data = cascased_channel_with_P(code_word, sigma_mu(ct)/100, P1);

        % Calculate rth
        % r_th = calc_rth(sigma_mu(ct)/100);
        r_th = optimizing_rth(sigma_mu(ct)/100, P1, P);
        
        % Decode using hamming code
        data_decoded = hamming_code_57p63_decoder(received_data >= r_th, sigma_mu(ct)/100);

        % Demodulation using sparse code
        user_data_sparsecode_demodulation = my_sparse_code_decoder(data_decoded);

        % output_decoding = (output >= threshold);
        % decoding = my_sparse_code_decoder(output_decoding);

        % Calculate difference bit
        diff_bits(1,ct) = diff_bits(1,ct) + sum(abs(user_data - user_data_sparsecode_demodulation))
    end
end
toc;


% Draw BER
figure
BER_no_coding = diff_bits_no_coding/(N*packet);
% BER_sc_hm_MRAM_with_P1 = diff_bits/(N*packet);
BER_sc_hm_MRAM = diff_bits/(N*packet);

% file_name = ['BER_my_sparse_code_P_' num2str(P) '_' datetime];
% save(file_name,BER_sc_hm_MRAM);

semilogy(sigma_mu,BER_no_coding,'r');
hold on
semilogy(sigma_mu,BER_sc_hm_MRAM,'--b');
xlabel('\sigma_0/\mu_0')
ylabel('BER')
grid on
legend('No coding','54/63 Sparse code')
axis([8 16 1e-7 1e-1])