function [centers] =  SelectSalient(kmeans_size,totalnumber,fullvideoname,descriptor_path,vocabDir)
    
    if ~exist(fullfile(vocabDir,'mbh'),'dir')
        mkdir(fullfile(vocabDir,'mbh'));
    end
    vocabDir = [vocabDir '/mbh/'];

    sampleFeatFile = fullfile(vocabDir,'featfile.mat');
    modelFilePath = fullfile(vocabDir,'kmenasmodel.mat');
    if exist(modelFilePath,'file')
        load(modelFilePath);
        return;
    end
    start_index = 1;
    end_index = 1;
    if ~exist(sampleFeatFile,'file')
    	mbhAll = zeros(totalnumber,96*2);
	num_videos = size(fullvideoname,1);
             num_samples_per_vid = round(totalnumber / num_videos);
	for i = 1:num_videos       
	        timest = tic();        
	        [~,partfile,~] = fileparts(fullvideoname{i});
	        descriptorFile = fullfile(descriptor_path,sprintf('%s.mat',partfile));      
		if exist(descriptorFile,'file')
		        load(descriptorFile);
	             else
		        fprintf('%s not exist !!!',descriptorFile);
                                    [obj,trj,hog,hof,mbhx,mbhy] = extract_improvedfeatures(fullvideoname{i}) ;
                                    save(descriptorFile,'obj','trj','hog','hof','mbhx','mbhy'); 
		end
                          mbhx = sqrt(mbhx);mbhy = sqrt(mbhy);
	        	rnsam = randperm(size(mbhx,1));
		if numel(rnsam) > num_samples_per_vid
		          rnsam = rnsam(1:num_samples_per_vid);
		end
	           end_index = start_index + numel(rnsam) - 1;
	           mbhAll(start_index:end_index,:) = [mbhx(rnsam,:) mbhy(rnsam,:)];
	           start_index = start_index + numel(rnsam);        
	           timest = toc(timest);
	           fprintf('%d/%d -> %s --> %1.2f sec\n',i,num_videos,fullvideoname{(i)},timest);  
    	end
    	if end_index ~= totalnumber
    		mbhAll(end_index+1:totalnumber,:) = [];
    	end
    	fprintf('start generating kmeans models\n');
       	fprintf('start saving descriptors\n');
        save(sampleFeatFile,'mbhAll');
     else
     	load(sampleFeatFile);  
    end
    % start to generating kmeans.
    numData = size(mbhAll,1);
    dimension = size(mbhAll,2);
    numClusters = kmeans_size;
    fprintf('%d\n', numData);
    [centers, ~] = vl_kmeans(mbhAll', kmeans_size, 'Initialization', 'plusplus') ; % need to transpose it...
    save(modelFilePath,'centers'); % remember it's size and dimension, take care of it.
end