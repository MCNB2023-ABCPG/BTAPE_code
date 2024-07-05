function [onset, offset] = get_onset_ext(file_path_log, file_path_info, condition, s, add_offset)
load(file_path_log);
T = readtable(file_path_info);

if condition == 1
    table_cond = 'generate_alternate';
else
    table_cond = 'generate_simultaneous';
end


onset = log.onset(log.conditions == condition);
onset = transpose(onset);
if add_offset
    offset = T{T.sub_nr == s, table_cond};
    offset = (offset*800)/1000;
    onset = onset + offset;
else
    offset = 0;
end


end