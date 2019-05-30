function my_DWT_optimiserv2(X)

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
    
    % Give an upperbound on number of bits to beat
    % best = [bits, s, M, SSIM]
    best = [MAX_size * 3, -1, -1, -1];
    
    n = best(2);
    M = best(3);
    total_bits = best(1);
    N = N_list(i);
    
    %Loop through M and n to find smallest number of bits
    for n = 1:4
        for j = 0: (log2(256)-log2(N))
            M = N *(2^j);
            %Initisalise quantisation step
            qstep = 25;
            while (total_bits > MAX_size && qstep < 256)
                try
                   [vlc bits huffval] = DWTenc(X, qstep, N_list(i), n, M, 0, dc_bits);
                   total_bits = sum(vlc(:,2));
                catch ME
                    disp("hey I caught an error")
                end
                qstep = qstep + 1;
            end
            Zp = DWTdec(vlc, qstep, n, N, M, bits, huffval, dc_bits);
            SSIM = ssim(Zp, X);
               
            if SSIM < best(4)
                best = [total_bits, n, M, SSIM];
            end
        end
    end
    
    qstep = qstep -1;
      
    % Display results
    disp("N: "+ N+ ", bits: "+ total_bits+ ", n: "+ n+ ", M: "+M+ ", ssim: "+SSIM + ", step: "+ qstep);
    
    figure(N);
    draw(Zp);
end
    
    

return