function getTotalN(video_dir)
    category = dir(video_dir);
    index = 1;
    frameNum = [];
    for i = 3 : length(category)
    	fnames = dir(fullfile(video_dir,category(i).name));
    	for j = 3: length(fnames)
        	fullvideoname{index}=fullfile(video_dir,category(i).name,fnames(j).name);
        	obj = mmreader(fullvideoname{index});
        	frameNum = [frameNum; obj.NumberOfFrames];
        	index = index+1;
        end
    end
    save('frameNumucf','frameNum');
end