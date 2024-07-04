function normalization(deformation, resample, voxel_size, prefix)

job = [];
job{1}.spm.spatial.normalise.write.subj.def = {deformation};
job{1}.spm.spatial.normalise.write.subj.resample = resample;
job{1}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -70
                                                  78 76 85];
job{1}.spm.spatial.normalise.write.woptions.vox = voxel_size;
job{1}.spm.spatial.normalise.write.woptions.interp = 4;
job{1}.spm.spatial.normalise.write.woptions.prefix = prefix;        


spm_jobman('run', job)


end