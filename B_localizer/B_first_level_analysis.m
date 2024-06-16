function B_first_level_analysis(folder_path_root, folder_base_pipeline, spm_path, folder_path_code)

% initialization
addpath(spm_path)
spm('defaults', 'fmri') 
spm_jobman('initcfg')

% specifying the steps: fill in switch_prep
% 1 - model specification and estimation
% 2 - contrast
switch_prep = [1 2];

load(fullfile(folder_path_code, 'exp_var.mat'))

conditions = [];
conditions{1}.name = 'Left';
conditions{1}.identity = 1;
conditions{2}.name = 'Right';
conditions{2}.identity = 2;

contrasts = [];
contrasts{1}.name = 'Left>Null';
%contrasts{1}.weights = [1 0 1 0 0 0];
contrasts{1}.weights = [1 0 0];
contrasts{1}.sessrep = 'none';

contrasts{2}.name = 'Right>Null';
%contrasts{2}.weights = [0 1 0 1 0 0];
contrasts{2}.weights = [0 1 0];
contrasts{2}.sessrep = 'none';

contrasts{3}.name = 'Left>Right';
%contrasts{3}.weights = [1 -1 1 -1 0 0];
contrasts{3}.weights = [1 -1 0];
contrasts{3}.sessrep = 'none';

contrasts{4}.name = 'Right>Left';
%contrasts{4}.weights = [-1 1 -1 1 0 0];
contrasts{4}.weights = [-1 1 0];
contrasts{4}.sessrep = 'none';


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

        folder_path_log = fullfile(folder_path_root,sub,'func');
        
        folder_path_str = folder_path_derivative_anat;
        folder_path_run = folder_path_derivative_func;
        %run_sub = run_all(s:numel(ses_sub),:);
        %run_ses = run_sub(ss,:);
        run_ses = folder_base_pipeline.runNameFunc;

        % MODEL SPECIFICATION AND ESTIMATION
        if any(switch_prep == 1)

            % run
            glm(folder_path_derivative_glm, folder_path_derivative_func, folder_path_log, run_ses, conditions);
        end


        % CONTRAST
        if any(switch_prep == 2)

            % run
            contrast(folder_path_derivative_glm, contrasts);
        end


    end % session loop
end % subject loop
