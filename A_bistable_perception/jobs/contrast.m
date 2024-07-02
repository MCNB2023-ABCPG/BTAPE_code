function contrast(folder_path_derivative_glm, contrasts)

file_path_spmmat = spm_select('FPList', fullfile(folder_path_derivative_glm), 'SPM.mat');

job{1}.spm.stats.con.spmmat = {file_path_spmmat};
job{1}.spm.stats.con.delete = 1;


for i=1:numel(contrasts)

if strcmp(contrasts{i}.type, 't')
job{1}.spm.stats.con.consess{i}.tcon.name = contrasts{i}.name;
job{1}.spm.stats.con.consess{i}.tcon.weights = contrasts{i}.weights;
job{1}.spm.stats.con.consess{i}.tcon.sessrep = contrasts{i}.sessrep;

elseif strcmp(contrasts{i}.type, 'f')
job{1}.spm.stats.con.consess{i}.fcon.name = contrasts{i}.name;
job{1}.spm.stats.con.consess{i}.fcon.weights = contrasts{i}.weights;
job{1}.spm.stats.con.consess{i}.fcon.sessrep = contrasts{i}.sessrep;
end

end

spm_jobman('run', job)

end