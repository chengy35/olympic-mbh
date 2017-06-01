function FVEncodeFeatures_w(fullvideoname,gmm,vocab,st,send,featDir,descriptor_path,wpath)
    pcaFactor = 0.5;
    if ~exist(fullfile(featDir,wpath),'dir')
        mkdir(fullfile(featDir,wpath));
    end
    for i = st : min(size(fullvideoname,1),send)   
        [~,partfile,~] = fileparts(fullvideoname{i});
        file = fullfile(featDir,wpath,sprintf('%d.mat',i));         
        descriptorFile = fullfile(descriptor_path,sprintf('%s.mat',partfile));
        if exist(file,'file')
            fprintf('%d --> %s Exists \n',i,file);            
            continue;
        end
        load (descriptorFile);
        timest = tic();
        fprintf('Processing Video file %s\n',partfile);
        mbhx = sqrt(mbhx);mbhy = sqrt(mbhy);
        mbh = [mbhx mbhy];
        frames = unique(obj(:,1));
        fv_mbh = zeros( numel(frames),pcaFactor*size(gmm.pcamap.mbh,1)*2*size(gmm.means.mbh,2));
        for frm = 1 : numel(frames)
            frm_indx = find(obj(:,1)==frames(frm));            
            fv_mbh(frm,:) = getFisherVector(mbh,gmm.means.mbh, gmm.covariances.mbh, gmm.priors.mbh,gmm.pcamap.mbh,pcaFactor,frm_indx);
        end
        file = fullfile(featDir,wpath,sprintf('%d.mat',i));
        dlmwrite(file,fv_mbh);
        timest = toc(timest);
        fprintf('%d--> %s done --> time  %1.1f sec \n',i,file,timest);
    end
end

function h = getFisherVector(mbh, means, covariances, priors,pcamap,pcaFactor,frm_indx)  
    comps = pcamap(:,1:size(pcamap,1)*pcaFactor);
    h = vl_fisher((mbh(frm_indx,:)*comps)', means, covariances, priors);
end