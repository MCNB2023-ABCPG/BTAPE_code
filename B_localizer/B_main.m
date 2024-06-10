function B_main()

% -------- INIT VARIABLES -------- %
% specify 
folder_path_root = '/Users/pschm/bids_test';
spm_path = '/Users/pschm/spm12_dev_main';

% add setup folder and subfolders for access to function
addpath(genpath(fullfile(folder_path_root, 'code')))

% load variables and pipelines
load(fullfile(folder_path_root,'code','exp_var.mat'))
folder_base_pipeline = folder_base_pipelines{4};

% edit pipeline and edit the runs that are associated with it
folder_base_pipeline.runNameFunc = {'007'};


% -------- DATA MANIPULATION -------- %
% copy files to derivative
B_copy_to_derivative(folder_path_root, folder_base_pipeline, spm_path)

% preprocessing
B_preprocessing(folder_path_root, folder_base_pipeline, spm_path)

% first-level analysis
%B_first_level_analysis(folder_path_root, folder_base_pipeline, spm_path)

% 

% -------- CLEANUP -------- %
rmpath(genpath(fullfile(folder_path_root, 'code')))

end