function image_converter()
    image_directory = uigetdir;
    myFiles = dir(fullfile(image_directory,'*.jpg')); 
    
    for i = 1:length(myFiles)
        baseFileName = myFiles(i).name;
        I = imread(baseFileName);
        I = imresize(I, [256 256]);
        I=rgb2gray(I);
        I = double(I);
        [pathstr, name, ext] = fileparts(baseFileName);
        display(name)
        image(I)
        pause(2)
        save(name,'I');
    end
    
    
