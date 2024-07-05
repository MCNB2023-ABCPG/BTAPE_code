function A_main()

% -------- INIT VARIABLES -------- %
% specify 
folder_path_root = '/Users/pschm/BTAPE_local';
spm_path = '/Users/pschm/spm12_dev_main';
folder_path_code = '/Users/pschm/icloud_link/University/mcnb/2_semester/NMP/BTAPE_code';

% add setup folder and subfolders for access to function
%addpath(genpath(fullfile(folder_path_root, 'code')))
addpath(genpath(fullfile(folder_path_code, 'A_bistable_perception')));
addpath(genpath(fullfile(folder_path_code, 'helper_functions')));

% load variables and pipelines
%load(fullfile(folder_path_root,'code','exp_var.mat'))
load(fullfile(folder_path_code,'exp_var.mat'))
folder_base_pipeline = folder_base_pipelines{3};

% edit pipeline and edit the runs that are associated with it
save_runNameFunc = 1;
folder_base_pipeline.runNameFunc = {'001', '002', '003', '004', '005', '006'};

if save_runNameFunc == 1
    filename = strcat(folder_base_pipeline.name{:},'_pipeline.mat');
    filepath = fullfile(folder_path_code, folder_base_pipeline.name{:});
    save(fullfile(filepath,filename), 'folder_base_pipeline');
end


% -------- DATA MANIPULATION -------- %
% copy files to derivative
copy_to_derivative(folder_path_root, folder_base_pipeline, spm_path, folder_path_code)

% preprocessing
A_preprocessing(folder_path_root, folder_base_pipeline, spm_path, folder_path_code)

% first-level analysis
A_first_level_analysis(folder_path_root, folder_base_pipeline, spm_path, folder_path_code)


% -------- CLEANUP -------- %
rmpath(genpath(fullfile(folder_path_code, folder_base_pipeline.name{:})));
rmpath(genpath(fullfile(folder_path_code, 'helper_functions')));


end