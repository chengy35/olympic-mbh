clear;
clc;
% TODO Add paths
addpath('~/lib/vlfeat/toolbox');
vl_setup();
setenv('LD_LIBRARY_PATH','/usr/local/lib/'); 
addpath('~/lib/liblinear/matlab');
addpath('~/lib/libsvm/matlab');

addpath(genpath('~/lib/lightspeed'));

%matlabpool local 4
encode = 'fv';

fprintf('begin fv encoding\n');
[video_data_dir,video_dir,fullvideoname, videoname,vocabDir,featDir,descriptor_path,class_category] = getconfigfv();

name_class = dir(video_dir);
className = cell(1,length(name_class)-2);
ucf_num_in_class = ones(1,length(name_class)-2);

for i = 3:length(name_class)
	className{i-2} =name_class(i).name;
	ucf_num_in_class(i-2) = (length(dir(fullfile(video_dir,name_class(i).name)))-2);
end
className = className'; % '
ucf_num_in_class = ucf_num_in_class'; %';
addpath('2-trainAndtest');
trainAndTest_confusion(video_data_dir,fullvideoname,featDir,encode,className,ucf_num_in_class);