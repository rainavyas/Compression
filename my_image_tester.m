function scores = my_image_tester()
    image_directory = uigetdir;
    myFiles = dir(fullfile(image_directory,'*.mat')); 
    
    scores = zeros(4,40)
    for i = 1:length(myFiles)
        baseFileName = myFiles(i).name;
        display(baseFileName)
        pause(5)
        X = matfile(image_directory + "/" + baseFileName);
        X = X.I
        image(X)
        [N, step, error] = my_DCT_compressor_return(X);
        a = log2(N)-1; 
        scores(a,step) = scores(a,step)+1;
        display(scores)
        pause(5)
    end
    display(scores)