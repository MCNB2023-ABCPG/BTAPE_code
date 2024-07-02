function create_mask(input, output, outdir, expression)

job{1}.spm.util.imcalc.input = input;
job{1}.spm.util.imcalc.output = output;
job{1}.spm.util.imcalc.outdir = outdir;
job{1}.spm.util.imcalc.expression = expression;
job{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
job{1}.spm.util.imcalc.options.dmtx = 0;
job{1}.spm.util.imcalc.options.mask = 0;
job{1}.spm.util.imcalc.options.interp = 1;
job{1}.spm.util.imcalc.options.dtype = 4;

spm_jobman('run', job);

end