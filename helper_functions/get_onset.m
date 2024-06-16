function [onset] = get_onset(file_path_log, condition)
load(file_path_log);
onset = log.onset(log.conditions == condition);
end