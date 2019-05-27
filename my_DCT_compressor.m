function my_DCT_compressor(X)
    N = [4,8,16]
     
    N = 4;
    step = 1;
    bit_length = 1000000;
    while bit_length > 50000,
        try
            vlc = jpegenc(X-128,step,N);
            Z_4 = jpegdec(vlc,step,N);
            bit_length = sum(vlc(:,2))
        catch ME
            display("error coding with step size")
        end
        step = step + 1
    end
    
    N = 8;
    step = 1;
    bit_length = 1000000;
    while bit_length > 50000,
        try
            vlc = jpegenc(X-128,step,N);
            Z_8 = jpegdec(vlc,step,N);
            bit_length = sum(vlc(:,2))
        catch ME
            display("error coding with step size")
        end
        step = step + 1
    end
=======
function my_DCT_compressor(X)
    N_list = [4,8,16,32];
    Z_list = [X, X, X, X];
    [n,m] = size(X)
>>>>>>> a8eca9fb62f75b4c16ae4ea524c75620da60b39f
    
    for i = 1:length(N_list)
        pixel_start = 1 + (i-1)*n
        pixel_end = i*n
        display(pixel_start)
        display(pixel_end)
        pause(2)
        N = N_list(i)
        step = 1;
        bit_length = 1000000;
        while bit_length > 50000,
            try
                vlc = jpegenc(X-128,step,N);
                Z_list(:,pixel_start:pixel_end) = jpegdec(vlc,step,N);
                bit_length = sum(vlc(:,2))
            catch ME
                display("error coding with step size")
            end
        display(bit_length)
        step = step + 1;
        end
    end
    
    Z_4 = Z_list(:,1:256);
    Z_8 = Z_list(:,257:512);
    Z_16 = Z_list(:,513:768);
    Z_32 = Z_list(:,769:1024);
    
    draw(beside(Z_4,beside(Z_8,beside(Z_16,Z_32))))