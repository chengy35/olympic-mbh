% TODO: Change the paths and improved trajectory binary paths
function [obj,mbhx,mbhy] = extract_improvedfeatures(videofile)   
    [~,nameofvideo,~] = fileparts(videofile);
    txtFile = fullfile('~/remote/Data/temp/tmpfiles',sprintf('%s-%1.6f',nameofvideo,tic())); % path of the temporary file
    % Here the path should be corrected
    system(sprintf('~/lib/improved_trajectory/debug/DenseTrackStab %s > %s',videofile,txtFile));
    data = dlmread(txtFile);
    delete(txtFile);
    obj = data(:,1:10);
    mbhx  = data(:,41+96+108:41+96+108+95);
    mbhy  = data(:,41+96+108+96:41+96+108+96+95);
end