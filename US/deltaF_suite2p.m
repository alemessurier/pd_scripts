function deltaF = deltaF_suite2p( F )

for i=1:size(F,1)
    cellName=['cell',num2str(i)];
    deltaF.(cellName)=deltaF_simple(F(i,:));
end

end

