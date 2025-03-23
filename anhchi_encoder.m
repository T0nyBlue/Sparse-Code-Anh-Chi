function [code_word] = anhchi_encoder(user_data)
    load coderate_7_9 list_codeword
    
    % Convert to decimal
    index_lookup_table = sum(user_data .* 2.^(length(user_data)-1:-1:0));

    % Get code word from lookup table
    code_word = list_codeword(index_lookup_table + 1, :);
end