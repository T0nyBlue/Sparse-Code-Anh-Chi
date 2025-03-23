function [data_decoded] = anhchi_decoder(received_data)
    % load coderate_7_9 list_codeword
    index_lookup_table = anhchi_lookup_table(received_data);
    
    % Convert decimal to binary string
    binaryStr = dec2bin(index_lookup_table - 1, 7);

    % Convert binary string to binary array
    data_decoded = arrayfun(@(x) str2double(x), binaryStr);
end