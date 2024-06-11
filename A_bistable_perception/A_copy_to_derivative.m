function A_copy_to_derivative(folder_path_root, folder_base_pipeline, spm_path, folder_path_code)

%load(fullfile(folder_path_root,'code','exp_var.mat'))
load(fullfile(folder_path_code, 'exp_var.mat'));

for s=1:numel(sub_all)
    sub = strcat('sub-', sub_all{s});
    folder_path_sub = fullfile(folder_path_root, sub);
        
    if isnan(folder_base_pipeline.name{:})
        folder_path_derivative_sub = fullfile(folder_path_root, 'derivatives', sub);
    else
        folder_path_derivative_sub = fullfile(folder_path_root,'derivatives', folder_base_pipeline.name{:}, sub);
    end
    

    
    for ss=1:numel(ses_all(s,:))

        ses_sub = ses_all(s,:);

        if isscalar(ses_sub)
            folder_path_ses = folder_path_sub;
            folder_path_derivative_ses = folder_path_derivative_sub;
        else
            folder_path_ses = fullfile(folder_path_sub, ses_sub{ss});
            folder_path_derivative_ses = fullfile(folder_path_derivative_sub, ses_sub{ss});
        end
        
        
        for m=folder_base_pipeline.modalities
            
            file_path_raw = [];

            if strcmp(m{:}, 'anat')
                file_path_raw = cellstr(spm_select('FPList', fullfile(folder_path_ses, m{:}), '^.*\.nii$'));
            elseif strcmp(m{:}, 'func')
                
                for r=folder_base_pipeline.runNameFunc
                    file_path_raw = [file_path_raw ; spm_select('FPList', fullfile(folder_path_ses, m{:}), strcat('^.*', 'run-',r{:}, '.*\.nii$'))];
                end
                file_path_raw = cellstr(file_path_raw);
            end
            
            folder_path_derivative_ses_mod = fullfile(folder_path_derivative_ses,m{:});
            
            if ~isempty(file_path_raw)
                for f=transpose(file_path_raw)
                    copyfile(f{:}, folder_path_derivative_ses_mod)
                end
            end
        end


        

    end
end