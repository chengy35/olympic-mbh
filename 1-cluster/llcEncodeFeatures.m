function llcEncodeFeatures(centers,fullvideoname,descriptor_path,featDir_LLC,class_category,video_dir)
   if ~exist(fullfile(featDir_LLC,'mbh'),'dir')
        mkdir(fullfile(featDir_LLC,'mbh'));
    end
    if ~exist(fullfile(featDir_LLC,'cmbh'),'dir')
        mkdir(fullfile(featDir_LLC,'cmbh'));
    end

    category = dir(video_dir);
    pyramid = [1, 2, 4];                % spatial block structure for the SPM               
    knn = 5;                            % number of neighbors for local coding
    index = 0;
    for i = 1:length(fullvideoname)
    	[~,partfile,~] = fileparts(fullvideoname{i});
            descriptorFile = fullfile(descriptor_path,sprintf('%s.mat',partfile));  
	if exist(descriptorFile,'file') == 2 
		mbhfeatFile = fullfile(featDir_LLC,sprintf('/mbh/%d.mat',i));
		if exist(mbhfeatFile,'file') == 0
			timest = tic();
			index = index + 1;
			load(descriptorFile);
			mbhx = sqrt(mbhx);mbhy = sqrt(mbhy);
			mbh = [mbhx , mbhy];
			feaSet.feaArr = mbh';
			feaSet.x = obj(:,2);
			feaSet.y = obj(:,3); 
			video_name = fullvideoname{index};
			videoObj = VideoReader(video_name);
			feaSet.width = videoObj.Width;
			feaSet.height = videoObj.Height;
			fea = LLC_pooling(feaSet, centers, pyramid, knn); % get unnderstand of LLC_pooling
			dlmwrite(mbhfeatFile,fea');
			timest = toc(timest);
			fprintf('%d/%d->%s--> %1.2f sec\n',i,length(fullvideoname),mbhfeatFile,timest);		
		else
			fprintf('%d/%d %s exists! \n',index,length(fullvideoname),mbhfeatFile);
		end
	end
    end
end