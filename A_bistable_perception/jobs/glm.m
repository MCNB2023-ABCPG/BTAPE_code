function glm(folder_path_derivative_glm, folder_path_derivative_func, folder_path_derivative_anat, folder_path_log, run_ses, conditions, s, file_path_info, add_motion, add_mask)
    
    job = [];
    job{1}.spm.stats.fmri_spec.dir = {folder_path_derivative_glm};
    job{1}.spm.stats.fmri_spec.timing.units = 'secs';
    job{1}.spm.stats.fmri_spec.timing.RT = 1;
    job{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
    job{1}.spm.stats.fmri_spec.timing.fmri_t0 = 8;


    for i = 1:numel(run_ses)

    pattern = strcat('^sw.*','run-', run_ses{i}, '.*\.nii$');
    file_path_run = cellstr(spm_select('ExtFPListRec', folder_path_derivative_func, pattern));
    job{1}.spm.stats.fmri_spec.sess(i).scans = file_path_run;
    
    pattern = strcat('^.*','run-', run_ses{i}, '.*\log.mat$');
    file_path_log = spm_select('FPList', folder_path_log, pattern);

    for j = 1:numel(conditions)
    condition = conditions{j}.identity;

    %onset = get_onset(file_path_log, condition);
    onset = get_onset_ext(file_path_log, file_path_info, condition, s, 1);
    
    job{1}.spm.stats.fmri_spec.sess(i).cond(j).name = conditions{j}.name;
    job{1}.spm.stats.fmri_spec.sess(i).cond(j).onset = onset;
    job{1}.spm.stats.fmri_spec.sess(i).cond(j).duration = 24;
    job{1}.spm.stats.fmri_spec.sess(i).cond(j).tmod = 0;
    job{1}.spm.stats.fmri_spec.sess(i).cond(j).pmod = struct('name', {}, 'param', {}, 'poly', {});
    job{1}.spm.stats.fmri_spec.sess(i).cond(j).orth = 1;

    job{1}.spm.stats.fmri_spec.sess(i).multi = {''};
    job{1}.spm.stats.fmri_spec.sess(i).regress = struct('name', {}, 'val', {});

    if add_motion
        pattern = strcat('^rp.*','run-', run_ses{i}, '.*\.txt$');
        file_path_motion = spm_select('FPList', folder_path_derivative_func, pattern);
        job{1}.spm.stats.fmri_spec.sess(i).multi_reg = {file_path_motion};
    else
        job{1}.spm.stats.fmri_spec.sess(i).multi_reg = {''};
    end
    job{1}.spm.stats.fmri_spec.sess(i).hpf = 128;

    job{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
    job{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
    job{1}.spm.stats.fmri_spec.volt = 1;
    job{1}.spm.stats.fmri_spec.global = 'None';


    if add_mask
    mask = spm_select('ExtFPListRec', folder_path_derivative_anat, '^smask_all_rethresh.*$');
    job{1}.spm.stats.fmri_spec.mask = {mask};
    end

    % masking threshhold
    job{1}.spm.stats.fmri_spec.mthresh = 0.8;
    
    % Autocorrelation
    job{1}.spm.stats.fmri_spec.cvi = 'AR(1)';
    %job{1}.spm.stats.fmri_spec.cvi = 'none';
    
    end % loop condition
    end % loop run

    spm_jobman('run', job)

    %ESTIMATION
    file_path_design = spm_select('FPList', folder_path_derivative_glm, '^SPM.mat$');

    % job options
    job = [];
    job{1}.spm.stats.fmri_est.spmmat = {file_path_design};
    job{1}.spm.stats.fmri_est.write_residuals = 0;
    job{1}.spm.stats.fmri_est.method.Classical = 1;

    spm_jobman('run', job);
end