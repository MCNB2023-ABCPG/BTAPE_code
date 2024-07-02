function A_first_level_analysis(folder_path_root, folder_base_pipeline, spm_path, folder_path_code)

% initialization
addpath(spm_path)
spm('defaults', 'fmri') 
spm_jobman('initcfg')

% specifying the steps: fill in switch_prep
% 1 - model specification and estimation
% 2 - contrast
switch_prep = [1 2];
save_conditions = 1;
save_constrasts = 1;

load(fullfile(folder_path_code, 'exp_var.mat'))

conditions = [];

conditions{1}.name = 'A';
conditions{1}.identity = 1;
conditions{2}.name = 'S';
conditions{2}.identity = 2;

% add motion parameters
add_motion = 1;

% add matter mask
add_mask = 1;

n_run = numel(folder_base_pipeline.runNameFunc);

contrasts = [];

contrasts{1}.type = 't';
contrasts{1}.name = 'A>Null';
contrasts{1}.weights = [1 0 repelem(0,6)];
contrasts{1}.sessrep = 'replsc';

contrasts{2}.type = 't';
contrasts{2}.name = 'S>Null';
contrasts{2}.weights = [0 1 repelem(0,6)];
contrasts{2}.sessrep = 'replsc';

contrasts{3}.type = 't';
contrasts{3}.name = 'A>S';
contrasts{3}.weights = [1 -1 repelem(0,6)];
contrasts{3}.sessrep = 'replsc';

contrasts{4}.type = 't';
contrasts{4}.name = 'S>A';
contrasts{4}.weights = [-1 1 repelem(0,6)];
contrasts{4}.sessrep = 'replsc';

contrasts{5}.type = 'f';
contrasts{5}.name = 'F Motion';
contrasts{5}.weights = [repelem(0, 6, 2) eye(6)];
contrasts{5}.sessrep = 'replsc';


if save_conditions == 1
    filename = strcat(folder_base_pipeline.name{:},'_conditions.mat');
    filepath = fullfile(folder_path_code, folder_base_pipeline.name{:});
    save(fullfile(filepath,filename), 'conditions');
end

if save_constrasts == 1
    filename = strcat(folder_base_pipeline.name{:},'_contrasts.mat');
    filepath = fullfile(folder_path_code, folder_base_pipeline.name{:});
    save(fullfile(filepath,filename), 'contrasts');
end


for s=1:numel(sub_all)
    sub = strcat('sub-', sub_all{s});

    if isnan(folder_base_pipeline.name{:})
        folder_path_derivative_sub = fullfile(folder_path_root, 'derivatives', sub);
    else
        folder_path_derivative_sub = fullfile(folder_path_root,'derivatives', folder_base_pipeline.name{:}, sub);
    end

    for ss=1:numel(ses_all(s,:))

        ses_sub = ses_all(s,:);

        if isscalar(ses_sub)
            folder_path_derivative_ses = folder_path_derivative_sub;
        else
            folder_path_derivative_ses = fullfile(folder_path_derivative_sub, ses_sub{ss});
        end
        

        folder_path_derivative_anat = fullfile(folder_path_derivative_ses, 'anat');
        folder_path_derivative_func = fullfile(folder_path_derivative_ses, 'func');
        folder_path_derivative_glm = fullfile(folder_path_derivative_ses, 'glm');

        folder_path_log = fullfile(folder_path_root,sub, 'func');
        file_path_info = fullfile(folder_path_root, 'derivatives', 'BTAPE_info', 'BTAPE-sub-Data_clean.xlsx');
        
        folder_path_str = folder_path_derivative_anat;
        folder_path_run = folder_path_derivative_func;
        %run_sub = run_all(s:numel(ses_sub),:);
        %run_ses = run_sub(ss,:);
        run_ses = folder_base_pipeline.runNameFunc;

        % MODEL SPECIFICATION AND ESTIMATION
        if any(switch_prep == 1)

            % run
            glm(folder_path_derivative_glm, folder_path_derivative_func, folder_path_derivative_anat, folder_path_log, run_ses, conditions, s, file_path_info, add_motion, add_mask)
        end


        % CONTRAST
        if any(switch_prep == 2)

            % run
            contrast(folder_path_derivative_glm, contrasts);
        end


    end % session loop
end % subject loop
