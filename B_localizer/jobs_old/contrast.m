function contrast(folder_path_derivative_glm, contrasts)

file_path_spmmat = spm_select('FPList', fullfile(folder_path_derivative_glm), 'SPM.mat');

job{1}.spm.stats.con.spmmat = {file_path_spmmat};

for i=1:numel(contrasts)

job{1}.spm.stats.con.consess{i}.tcon.name = contrasts{i}.name;
job{1}.spm.stats.con.consess{i}.tcon.weights = contrasts{i}.weights;
job{1}.spm.stats.con.consess{i}.tcon.sessrep = contrasts{i}.sessrep;
job{1}.spm.stats.con.delete = 1;

end

spm_jobman('run', job)

end