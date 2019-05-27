function bpp_result = my_dctbpp(Yr,N)
    [m,n] = size(Yr);
    Grids = n/N;
    sum = 0;
    
    for i=1:Grids:m,
        for k=1:Grids:m,
            Ys = Yr(i:i+Grids-1,k:k+Grids-1);
            sum = sum + bpp(Ys);
        end
    end
    
    bpp_result = sum / N^2;
end