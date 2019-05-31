function scores = my_image_tester()
    image_directory = uigetdir;
    myFiles = dir(fullfile(image_directory,'*.mat')); 
    scores = zeros(3,9)
    for i = 1:length(myFiles)
        baseFileName = myFiles(i).name;
        display(baseFileName)
        X = matfile(image_directory + "/" + baseFileName);
        X = X.I;
        figure(i)
        draw(X)
        figure(i+100)
        scheme = final_superscheme(X);
        switch scheme
            case 11
                scores(1,1) = scores(1,1)+1
            case 21
                scores(2,1) = scores(2,1)+1
            case 31
                scores(3,1) = scores(3,1)+1
            case 12
                scores(1,2) = scores(1,2)+1
            case 22
                scores(2,2) = scores(2,2)+1
            case 32
                scores(3,2) = scores(3,2)+1
            case 13
                scores(1,3) = scores(1,3)+1
            case 23
                scores(2,3) = scores(2,3)+1
            case 33
                scores(3,3) = scores(3,3)+1
            case 14
                scores(1,4) = scores(1,4)+1
            case 24
                scores(2,4) = scores(2,4)+1
            case 34
                scores(3,4) = scores(3,4)+1
            case 15
                scores(1,5) = scores(1,5)+1
            case 25
                scores(2,5) = scores(2,5)+1
            case 35
                scores(3,5) = scores(3,5)+1  
            case 16
                scores(1,6) = scores(1,6)+1
            case 26
                scores(2,6) = scores(2,6)+1
            case 36
                scores(3,6) = scores(3,6)+1
            case 17
                scores(1,7) = scores(1,7)+1
            case 27
                scores(2,7) = scores(2,7)+1
            case 37
                scores(3,7) = scores(3,7)+1
            case 18
                scores(1,8) = scores(1,8)+1
            case 28
                scores(2,8) = scores(2,8)+1
            case 38
                scores(3,8) = scores(3,8)+1
            otherwise
                scores(1,9) = scores(1,9)+1
        end
    end
