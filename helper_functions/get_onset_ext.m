function [onset] = get_onset(file_path_log, file_path_info, condition, s)
load(file_path_log);
T = readtable(file_path_info);

if condition == 1
    table_cond = 'generate_alternate';
else
    table_cond = 'generate_simultaneous';
end

offset = T{T.sub_nr == s, table_cond};
onset = log.onset(log.conditions == condition);
onset = transpose(onset) + offset;
end