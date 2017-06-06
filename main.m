clear;
clc;
% TODO Add paths
addpath('~/lib/vlfeat/toolbox');
vl_setup();
addpath('~/lib/spams-matlab/build');
setenv('LD_LIBRARY_PATH','/usr/local/lib/'); 
addpath('~/lib/liblinear/matlab');
addpath('~/lib/libsvm/matlab');
addpath(genpath('~/lib/lightspeed'));
addpath('~/lib/natsort');
	[video_data_dir,video_dir,fullvideoname, videoname,vocabDir,featDir_FV,featDir_LLC,descriptor_path,class_category,actionName] = getconfig();
	st = 1;
	send = length(videoname);
	fprintf('Start : %d \n',st);
	fprintf('End : %d \n',send);
	addpath('0-trajectory');
	fprintf('select improved dense trajectory \n');
	getSalient(st,send,fullvideoname,descriptor_path);

	totalnumber = 1000000;
	gmmSize = 256;
	mbhFeatureDimension = 96*2;

	encode = 'fv';
	fprintf('begin fv encoding\n');
	addpath('1-fv');
	fprintf('getGMM \n');
	% create GMM model, Look at this function see if parameters are okay for you.
	[gmm] = getGMMAndBOW(fullvideoname,vocabDir,descriptor_path,totalnumber,gmmSize);
	% generate Fisher Vectors
	fprintf('generate Fisher Vectors \n');
	FVEncodeFeatures_w(fullvideoname,gmm,vocabDir,st,send,featDir_FV,descriptor_path,'mbh');
	clear gmm;
	getVideoDarwin(fullvideoname,featDir_FV,descriptor_path,gmmSize,mbhFeatureDimension);

	encode = 'llc';
	fprintf('begin llc encoding\n');
	addpath('1-cluster');
	
	kmeans_size = 8000;
	fprintf('clustering \n');
	centers = SelectSalient(kmeans_size,totalnumber,fullvideoname,descriptor_path,vocabDir);
	fprintf('llc Encoding now \n');
	llcEncodeFeatures(centers,fullvideoname,descriptor_path,featDir_LLC,class_category,vocabDir);
	clear centers;

	addpath('2-trainAndtest');
%	trainAndTest_normalizedL2_LLC(video_data_dir,fullvideoname,featDir_FV,featDir_LLC,encode,class_category,actionName);
	trainAndTest_normalizedL2_FV(video_data_dir,fullvideoname,featDir_FV,featDir_LLC,encode,class_category,actionName);
%	trainAndTest_normalizedL2_FV_LLC(video_data_dir,fullvideoname,featDir_FV,featDir_LLC,encode,actionName);
