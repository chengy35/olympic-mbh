function getVideoDarwin(fullvideoname,featDir,descriptor_path)
    CVAL = 1 ;
    for i = 1:length(fullvideoname) % 1-16 actions
            [~,partfile,~] = fileparts(fullvideoname{i});
            mbhfeatFile = fullfile(featDir,sprintf('/mbh-w/%d.mat',i));
            wFile = fullfile(featDir,'w',sprintf('%s.mat',partfile));  
            if exist(wFile,'file') == 2
                fprintf('%s exist! \n',wFile);
                continue;
            end
            fprintf('%s\n',mbhfeatFile);
            if exist(mbhfeatFile,'file') == 2
                timest = tic();
                data = dlmread(mbhfeatFile);
                w = VideoDarwin(data');
                dlmwrite(wFile,w');
                clear data;
                clear w;
                timest = toc(timest);
                fprintf('%d/%d -->%s----> %1.2f sec\n',i,length(fullvideoname),wFile,timest);
            end
    end
end