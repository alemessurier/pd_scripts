function results=read_DLC_CSV(respath)

data=readtable(respath);
data_struct=table2struct(data,'ToScalar',true);

fns=fieldnames(data_struct);
results=struct;
for f=1:length(fns)
    sf1=data_struct.(fns{f}){1};
    sf2=data_struct.(fns{f}){2};
    vals=cellfun(@(x)str2num(x),data_struct.(fns{f})(3:end));
    results.(sf1).(sf2)=vals;
end