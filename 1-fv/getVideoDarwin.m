function getVideoDarwin(fullvideoname,featDir_FV,descriptor_path,gmmSize,mbhFeatureDimension)
    if ~exist(fullfile(featDir_FV,'wmbh'),'dir')
        mkdir(fullfile(featDir_FV,'wmbh'));
    end
    CVAL = 1 ;
    dimension = gmmSize*mbhFeatureDimension;
    for i = 1:length(fullvideoname) % 1-16 actions
            [~,partfile,~] = fileparts(fullvideoname{i});
            mbhfeatFile = fullfile(featDir_FV,sprintf('/mbh/%d.mat',i));
            wFile = fullfile(featDir_FV,'wmbh',sprintf('%s.mat',partfile));  
            if exist(wFile,'file') == 2
                fprintf('%s exist! \n',wFile);
                continue;
            end
            fprintf('%s\n',mbhfeatFile);
            if exist(mbhfeatFile,'file') == 2
                timest = tic();
                data = dlmread(mbhfeatFile);
                w = VideoDarwin(data);
                dlmwrite(wFile,w');
                clear data;
                clear w;
                timest = toc(timest);
                fprintf('%d/%d -->%s----> %1.2f sec\n',i,length(fullvideoname),wFile,timest);
            end
    end
end