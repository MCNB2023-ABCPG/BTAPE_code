function B_main()

% -------- INIT VARIABLES -------- %
% specify 
folder_path_root = '/Users/pschm/fubox/BTAPE_local';
spm_path = '/Users/pschm/spm12_dev_main';
folder_path_code = pwd;

% add setup folder and subfolders for access to function
%addpath(genpath(fullfile(folder_path_root, 'code')))
addpath(genpath(folder_path_code))

% load variables and pipelines
%load(fullfile(folder_path_root,'code','exp_var.mat'))
load(fullfile(folder_path_code,'exp_var.mat'))
folder_base_pipeline = folder_base_pipelines{3};

% edit pipeline and edit the runs that are associated with it
folder_base_pipeline.runNameFunc = {'007'};


% -------- DATA MANIPULATION -------- %
% copy files to derivative
B_copy_to_derivative(folder_path_root, folder_base_pipeline, spm_path, folder_path_code)

% preprocessing
B_preprocessing(folder_path_root, folder_base_pipeline, spm_path, folder_path_code)

% first-level analysis
% A_first_level_analysis(folder_path_root, folder_base_pipeline, spm_path)


% -------- CLEANUP -------- %
rmpath(genpath(fullfile(folder_path_root, 'code')))

end