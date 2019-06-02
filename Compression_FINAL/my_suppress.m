function Y = my_suppress(X, N, cutoff)

% This function suppresses (to zero) all pixels beyond cutoff diagonally in
% each N x N block of the 256 x 256 image

% maximum cutoff is 2N

Y = X;

for block_row = 0: (256/N) -1
    for block_col = 0 : (256/N) -1
        for i = 1: N
            for j = 1: N
                sum = i+j;
                if sum > cutoff
                    Y((block_row*N)+i, (block_col*N) + j) = 0;
                end
            end
        end
    end
end

return