function smoothing(data)

job = [];
job{1}.spm.spatial.smooth.data = data;
job{1}.spm.spatial.smooth.fwhm = [8 8 8];
job{1}.spm.spatial.smooth.dtype = 0;
job{1}.spm.spatial.smooth.im = 0;
job{1}.spm.spatial.smooth.prefix = 's';

spm_jobman('run', job)

end