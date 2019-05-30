function my_LBT_optimiser_custom_huff(X)

% This function finds the parameter settings for the LBT (in JPEG scheme)
% that gives the highest SSIM relative to the original image, whilst
% getting number of compression bits to be less than 5kbytes
%Parameters: N, s, qstep, M, opthuff = true/false

penalty = 1424; % To transmit custom table
MAX_size = 40960 - penalty;
X = double(X);
X = X -128;
N_list = [4,8,16,32];
dc_bits = 8;

for i = 1:length(N_list)
    %Arbitrarily set a quantisation level for step size
    qstep = 15;
    
    % Give an upperbound on number of bits to beat
    % best = [bits, s, M]
    best = [MAX_size * 3, -1, -1];
    
    %Loop through M and scaling factor to find smallest number of
    %bits
    
    for s = 1:0.2:2
        for j = 0: (log2(256)-log2(N_list(i)))
            M = N_list(i)*(2^j);
            try
            bits = my_LBT_bits(X, qstep, s, N_list(i), M, 1, dc_bits);
            if bits < best(1)
                best = [bits, s, M];
            end
            catch ME
                disp("yo");
            end
        end
    end
    
    % Now increase quantisation step till bits threshold crossed
    s = best(2);
    M = best(3);
    total_bits = best(1);
    N = N_list(i);
    
    while total_bits> MAX_size
        
        qstep = qstep + 1;
        total_bits = my_LBT_bits(X, qstep, s, N, M, 1, dc_bits);
    end
    
    % Decode the vlc information
    [vlc, bits, huffval] = LBTenc_vyas(X, qstep, s, N, M, 0, dc_bits);
    Zp = LBTdec(vlc, qstep, s, N, M, bits, huffval, dc_bits);
    
    %Find the SSIM to original X
    SSIM = ssim(Zp, X);
    
    %Account for penalty for transmitting custom Huffman table:
    total_bits = total_bits + penalty;
    qstep = qstep -1;
    
    % Display resulst
    disp("N: "+ N+ ", bits: "+ total_bits+ ", s: "+ s+ ", M: "+M+ ", ssim: "+SSIM + ", step: "+ qstep);
    
    figure(N);
    draw(Zp);
end
    
    

return