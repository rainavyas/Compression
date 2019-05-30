function my_DWT_optimiser(X)

% This function finds the parameter settings for the DWT (in JPEG scheme)
% that gives the highest SSIM relative to the original image, whilst
% getting number of compression bits to be less than 5kbytes
%Parameters: N, n, qstep, M, opthuff = true/false
% N = block size in regrouping for scanning
% n = levels of dwt

MAX_size = 40960;
X = double(X);
X = X -128;
N_list = [4,8,16,32];
dc_bits = 8;

for i = 1:length(N_list)
    %Arbitrarily set a quantisation level for step size
    qstep = 10;
    
    % Give an upperbound on number of bits to beat
    % best = [bits, s, M]
    best = [MAX_size * 3, -1, -1];
    
    %Loop through M and levels to find smallest number of
    %bits
    
    for n = 1:7
        for j = 0: (log2(256)-log2(N_list(i)))
            M = N_list(i)*(2^j);
            try
               [vlc bits huffval] = DWTenc(X, qstep, N_list(i), n, M, 0, dc_bits);
               total_bits = sum(vlc(:,2));
            
            if total_bits < best(1)
                best = [total_bits, n, M];
            end
            catch ME
                disp("hey I caught an error")
            end
        end
    end
    
    % Now increase quantisation step till bits threshold crossed
    n = best(2);
    M = best(3);
    total_bits = best(1);
    N = N_list(i);
    
    while total_bits> MAX_size
        qstep = qstep + 1;
        try 
            [vlc bits huffval] = DWTenc(X, qstep, N, n, M, 0, dc_bits);
             total_bits = sum(vlc(:,2));
        catch ME
            disp("caught error")
        end
    end
    
    % Decode the vlc information
    [vlc, bits, huffval] = DWTenc(X, qstep, N, n, M, 0, dc_bits);
    Zp = DWTdec(vlc, qstep, n, N, M, bits, huffval, dc_bits);
    
    %Find the SSIM to original X
    SSIM = ssim(Zp, X);
    
    qstep = qstep -1;
      
    % Display resulst
    disp("N: "+ N+ ", bits: "+ total_bits+ ", n: "+ n+ ", M: "+M+ ", ssim: "+SSIM + ", step: "+ qstep);
    
    figure(N);
    draw(Zp);
end
    
    

return