function coregistration(ref, source)

job = [];


%job{1}.spm.spatial.coreg.estwrite.ref = {ref};
%job{1}.spm.spatial.coreg.estwrite.source = {source};
%job{1}.spm.spatial.coreg.estwrite.other = {''};
%job{1}.spm.spatial.coreg.estwrite.eoptions.cost_fun = 'nmi';
%job{1}.spm.spatial.coreg.estwrite.eoptions.sep = [4 2];
%job{1}.spm.spatial.coreg.estwrite.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
%job{1}.spm.spatial.coreg.estwrite.eoptions.fwhm = [7 7];
%job{1}.spm.spatial.coreg.estwrite.roptions.interp = 4;
%job{1}.spm.spatial.coreg.estwrite.roptions.wrap = [0 0 0];
%job{1}.spm.spatial.coreg.estwrite.roptions.mask = 0;
%job{1}.spm.spatial.coreg.estwrite.roptions.prefix = 'r';


job{1}.spm.spatial.coreg.estimate.ref = {ref};
job{1}.spm.spatial.coreg.estimate.source = {source};
job{1}.spm.spatial.coreg.estimate.other = {''};
job{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
job{1}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
job{1}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
job{1}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];

spm_jobman('run', job)

end