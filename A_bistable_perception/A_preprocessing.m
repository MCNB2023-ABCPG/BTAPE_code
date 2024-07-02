function A_preprocessing(folder_path_root, folder_base_pipeline, spm_path, folder_path_code)
%
% Ideas for general structure from:
% https://github.com/phildean/SPM_fMRI_Example_Pipeline/blob/master/preprocess.m
% https://bids-standard.github.io/bids-starter-kit/
% https://youtube.com/playlist?list=PLhzkDK3o0fcCO3hQORMU6GjKGBjMRWBSb&si=wE4SUJ1x1r-jQyFG
% https://dartbrains.org/content/Group_Analysis.html
% https://github.com/Neurocomputation-and-Neuroimaging-Unit/fMRI_task-based
% 
%
% Variable names for files and folders
%   file_path_              % full path to file
%   folder_path_            % full path to folder
%   file_base_              % basename file (usually appended to path)
%   folder_base_            % basename folder (usually appended to path)
%
%
% Parameters
% ----------
%       folder_path_root = char
%           specify the folder in which the data folder is located -> TOP
% 
% Returns
% ----------
%       None
%     
% Other
% ----------
%       Writes to disk

% initialization
addpath(spm_path)
spm('defaults', 'fmri') 
spm_jobman('initcfg')


% specifying the steps: fill in switch_prep
% 1 - realign
% 2 - coregister
% 3 - segment
% 4 - normalise
% 5 - smooth
switch_prep = [1 2 3 4 5 6];


%load(fullfile(folder_path_root, 'code', 'exp_var.mat'))
load(fullfile(folder_path_code, 'exp_var.mat'))

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
        
        folder_path_str = folder_path_derivative_anat;
        folder_path_run = folder_path_derivative_func;
        %run_sub = run_all(s:numel(ses_sub),:);
        %run_ses = run_sub(ss,:);
        run_ses = folder_base_pipeline.runNameFunc;


        % REALIGN
        if any(switch_prep == 1)
            
            % select files
            file_path_ses = [];
            for r=1:numel(run_ses)
                pattern = strcat('^.*','run-', run_ses{r}, '.*\.nii$');
                file_path_run = cellstr(spm_select('ExtFPListRec', folder_path_derivative_func, pattern));
                
                file_path_ses = [file_path_ses {file_path_run}];
                
            end

            % run realignment
            realignment(file_path_ses);
        end
        
        % COREGISTER
        if any(switch_prep == 2)
            % select the structural source
            file_path_str = spm_select('ExtFPListRec', folder_path_str, '^sub.*\.nii$', 1);
            
            % select mean image as reference
            file_path_mean = spm_select('ExtFPListRec', folder_path_run, '^mean.*\.nii', 1);
        
            %run
            coregistration(file_path_str, file_path_mean)
        end
        
        % SEGMENTATION
        if any(switch_prep == 3)
            % select nii files from spm path
            spm_path_nii = spm_select('FPList', fullfile(spm_path,'tpm'), '^TPM.nii$');
            spm_path_nii_list = cellstr([repmat(spm_path_nii,6,1) strcat(',',num2str([1:6]'))]);
            
            % select structural
            file_path_str = spm_select('ExtFPListRec', folder_path_str, '^sub.*\.nii$', 1);
        
            % run
            segmentation(file_path_str, spm_path_nii_list)
        end
        
        % NORMALIZATION
        if any(switch_prep == 4)
            % select deformation field from segmentation
            file_path_str_y = spm_select('FPList', folder_path_str, '^y_.*\.nii$');
        
            % select volumes
            file_path_volumes = cellstr(spm_select('ExtFPListRec', folder_path_run, '^sub.*\.nii$', 1:360));
        
            % run
            normalization(file_path_str_y,file_path_volumes)

            % select anatomical volumes
            file_path_volumes = cellstr(spm_select('ExtFPListRec', folder_path_str, '^.*\.nii$'));
        
            % run
            normalization(file_path_str_y,file_path_volumes)

        end
        
        % SMOOTHING
        if any(switch_prep == 5)
            % select normalized volumes
            file_path_volumes_norm = cellstr(spm_select('ExtFPListRec', folder_path_run, '^w.*\.nii$', 1:360));
        
            % run
            smoothing(file_path_volumes_norm)


            % select normalized volumes
            file_path_volumes_norm = cellstr(spm_select('ExtFPListRec', folder_path_str, '^w.*\.nii$'));
        
            % run
            smoothing(file_path_volumes_norm)

        end
        
        % CREATE MASK
        if any(switch_prep==6)
            outdir = cellstr(folder_path_derivative_anat);
            
            % grey matter thresh
            input = cellstr(spm_select('FPList', folder_path_derivative_anat, '^wc1.*\.nii$'));
            output = 'mask_grey';
            expression = 'i1 > 0.4';
            create_mask(input, output, outdir, expression);

            % grey matter smooth
            mask = cellstr(spm_select('FPList', folder_path_str, '^mask_grey.*$'));
            smoothing(mask);

            % rethresh
            input1 = cellstr(spm_select('FPList', folder_path_derivative_anat, '^smask_grey.*$'));
            %input2 = cellstr(spm_select('FPList', folder_path_derivative_anat, '^wc[4-5].*$'));
            input2 = cellstr(spm_select('FPList', folder_path_derivative_anat, '^wc4.*$'));
            input3 = cellstr(spm_select('FPList', folder_path_derivative_anat, '^wc5.*$'));
            %input4 = cellstr(spm_select('FPList', folder_path_derivative_anat, '^wc2.*$'));

            input = [input1 ; input2; input3];
            %input = [input1 ; input2];
            output = 'smask_all_rethresh';
            expression = '(i1 > 0) & (i2 < 0.5) & (i3 < 0.5)';
            create_mask(input, output, outdir, expression)


            % TODO
            % 1 - grey matter mask
            % 2 - grey matter mask smoothed
            % 3 - grey and white matter
            % 4 - grey and white matter smoothed
            mode = 1;

            switch 0
                case 1
                    input = cellstr(spm_select('FPList', folder_path_derivative_anat, '^wc1.*\.nii$'));
                    output = 'mask_grey';
                    expression = 'i1 > 0.2';
                    create_mask(input, output, outdir, expression)

                case 2
                    % thresh
                    input = cellstr(spm_select('FPList', folder_path_derivative_anat, '^wc1.*\.nii$'));
                    output = 'mask_grey';
                    expression = 'i1 > 0.2';
                    create_mask(input, output, outdir, expression);

                    % smooth
                    mask = cellstr(spm_select('FPList', folder_path_str, '^mask_grey.*$'));
                    smoothing(mask);

                    % rethresh
                    input = cellstr(spm_select('FPList', folder_path_derivative_anat, '^smask_grey.*$'));
                    output = 'smask_grey_rethresh';
                    expression = 'i1 > 0';
                    create_mask(input, output, outdir, expression)
                    
                case 3
                case 4
                    % thresh
                    input = cellstr(spm_select('FPList', folder_path_derivative_anat, '^wc1.*\.nii$'));
                    output = 'mask_grey';
                    expression = 'i1 > 0.2';
                    create_mask(input, output, outdir, expression);

                    % thresh
                    input = cellstr(spm_select('FPList', folder_path_derivative_anat, '^wc2.*\.nii$'));
                    output = 'mask_white';
                    expression = 'i1 > 0.2';
                    create_mask(input, output, outdir, expression);

                    % smooth
                    mask = cellstr(spm_select('FPList', folder_path_str, '^mask_.*$'));
                    smoothing(mask);

                    % rethresh
                    input = cellstr(spm_select('FPList', folder_path_derivative_anat, '^smask_.*$'));
                    output = 'smask_both_rethresh';
                    expression = '(i1 + i2) > 0';
                    create_mask(input, output, outdir, expression)

            end
            

        end


    end % loop ses
end % loop sub
end % function 