% function [code_word] = anhchi_lookup_table(received_data)
%     % Init
%     load coderate_7_9 list_codeword
%     code_word = [];
%     euclidean_distance = 0;
%     cal_euclidean_distance = 0;
%     [numRows, numCols] = size(list_codeword);
% 
%     for i = 1:numRows
%         for j = 1:numCols
%             cal_euclidean_distance = cal_euclidean_distance + (received_data(j) - list_codeword(i,j))^2;
%         end
% 
%         cal_euclidean_distance = sqrt(cal_euclidean_distance);
% 
%         if i == 1
%             euclidean_distance = cal_euclidean_distance;
%         end
% 
%         if cal_euclidean_distance < euclidean_distance
%             euclidean_distance = cal_euclidean_distance;
%             code_word = list_codeword(i);
%             disp(code_word)
%         end
%     end
% end


function [index_lookup_table] = anhchi_lookup_table(received_data)
    % Initialize
    load coderate_7_9 list_codeword
    % list_codeword(list_codeword == 0) = -1;
    list_codeword = list_codeword + 1;
    index_lookup_table = 0;
    % code_word = [];
    euclidean_distance = inf;  % Set initial to infinity for comparison
    [numRows, numCols] = size(list_codeword);

    for i = 1:numRows
        % Reset cal_euclidean_distance for each codeword
        cal_euclidean_distance = 0;
        
        % Calculate Euclidean distance for the current codeword
        for j = 1:numCols
            cal_euclidean_distance = cal_euclidean_distance + (received_data(j) - list_codeword(i,j))^2;
        end
        
        % Take the square root of the summed squared distances
        cal_euclidean_distance = sqrt(cal_euclidean_distance);

        % Update the minimum Euclidean distance and store the corresponding codeword
        if cal_euclidean_distance < euclidean_distance
            euclidean_distance = cal_euclidean_distance;
            % code_word = list_codeword(i, :);  % Store the full row as codeword
            index_lookup_table = i;
            % disp(index_lookup_table)  % Optionally display the codeword
        end
    end
end
