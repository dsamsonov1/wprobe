function [success, bit_array] = selectRange(direction, current_index, bit_array)

    if length(bit_array) ~= 6
        error('bit_array must contain exactly 6 bits');
    end
    
    if current_index < 1 || current_index > 6
        error('current_index must be between 1 and 6');
    end
    
    if direction ~= 0 && direction ~= 1
        error('direction must be 0 or 1');
    end
    
    if sum(bit_array) ~= 1
        error('bit_array must have exactly one bit set to 1');
    end
    
    if bit_array(current_index) ~= 1
        error('current_index does not match the active bit in bit_array');
    end
    
    if direction == 1
        new_index = current_index + 1;
    else
        new_index = current_index - 1;
    end
    
    if new_index < 1 || new_index > 6
        success = false;
        bit_array = bit_array;
    else
        success = true;
        bit_array = zeros(1, 6);
        bit_array(new_index) = 1;
    end
end