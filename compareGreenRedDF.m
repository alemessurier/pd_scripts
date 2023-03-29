function compareGreenRedDF(path_2p,date_exp)

% load data
    path_thisDate=[path_2p,date_exp,filesep,'suite2p',filesep,'plane0',filesep];

load([path_thisDate,'reducedBySession_',date_exp,'.mat'],'deltaF_all');
load([path_thisDate,'reducedBySessionRED_',date_exp,'.mat'],'deltaF_all_red');



cellnames=fieldnames(deltaF_all(1));
numcells=length(cellnames);

% combine dF/F for each cell across
dFgreen=cellfun(@(x)cat(2,deltaF_all(:).(x)),cellnames,'un',0);
dFgreen=cat(1,dFgreen{:});

dFred=cellfun(@(x)cat(2,deltaF_all_red(:).(x)),cellnames,'un',0);
dFred=cat(1,dFred{:});

[inds_ex]=check_dF_greenVred( dFgreen,dFred )
end