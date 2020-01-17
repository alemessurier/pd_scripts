function [ex_image]=registration_res_multichannel(varargin)
% loads tif stacks from dir_raw, registers using dftregistration.m
% (available on MATLAB file exchange), and saves registered stacks to
% dir_registered. Input 1 must be dir_raw, input 2 must be dir_registered
% (set in 'analysisTemplate.m'). Optional 3rd input is filepath of movie to
% use as refernce; if not included, middle movie will be used. s

indsDir=cellfun(@(x)isdir(x),varargin,'Uni',1);
dirsReg=varargin(indsDir);
dir_to_reg=dirsReg{1};
dir_to_save=dirsReg{2};

indsRef=cellfun(@(x)strfind(x,'.tif'),varargin,'Uni',0);
indsRef=cellfun(@(x)~isempty(x),indsRef,'Uni',1);

cd(dir_to_reg)
imFiles=dir('*.tif');
stackNames=arrayfun(@(x)x.name,imFiles,'Uni',0);

if sum(indsRef)>0
    ref_stack_path=varargin{indsRef};
else
    ref_stack_path=strcat(dir_to_reg,stackNames{ceil(length(stackNames)/2)});
end

ref_stack = LoadTIFF_SI2019(ref_stack_path);
ref=mean(ref_stack,3);
ex_image=ref;
imagesc(ref);

fft2Ref=fft2(ref);
for K=1:length(stackNames);
    display(K)
    FileTif=strcat(dir_to_reg,stackNames{K});
    nameToWrite=strcat('dft',stackNames{K});
    [curr_stack,Metadata]=LoadTIFF_SI2019(FileTif);
    [Metadata] = ReadTIFFHeader_SI2019(Metadata);
    
    
    numChan=length(Metadata.MovieChannels);
    cd(dir_to_save);
    if numChan==1
        reg_stack=zeros(Metadata.RowPixels,Metadata.ColPixels,Metadata.NumFrames);
        reg_stack=uint16(reg_stack);
        
        parfor i=1:size(curr_stack,3)
            curr_im=curr_stack(:,:,i);
            [dft_out,reg]=dftregistration(fft2Ref,fft2(curr_im),100);
            reg_im=abs(ifft2(reg));
            reg_stack(:,:,i)=reg_im;
            
        end
        save([dir_to_save,nameToWrite],'reg_stack','Metadata');
        %         WriteTIFF(reg_stack,Metadata,strcat(dir_to_save,nameToWrite))
    elseif numChan==2
        idxGrn=1:2:size(curr_stack,3);
        idxRed=2:2:size(curr_stack,3);
        reg_grn_all=zeros(Metadata.RowPixels,Metadata.ColPixels,Metadata.NumFrames/2);
        curr_stack_grn=curr_stack(:,:,idxGrn);
        curr_stack_red=curr_stack(:,:,idxRed);
        reg_grn_all=uint16(reg_grn_all);
        reg_red_all=reg_grn_all;
        parfor i=1:size(curr_stack_grn,3)
                        
            curr_im_grn=curr_stack_grn(:,:,i);
            
            [~,reg]=dftregistration(fft2Ref,fft2(curr_im_grn),100);
            reg_grn=abs(ifft2(reg));
            
            reg_grn_all(:,:,i)=reg_grn;
            
            
        end
        parfor i=1:size(curr_stack_red,3)
                      
            curr_im_red=curr_stack_red(:,:,i);
            [~,reg]=dftregistration(fft2Ref,fft2(curr_im_red),100);
            reg_red=abs(ifft2(reg));
            reg_red_all(:,:,i)=reg_red;
            
        end
        dir_red=[dir_to_save,'\red\'];
        dir_green=[dir_to_save,'\green\'];
        %         save([dir_green,nameToWrite],'reg_grn_all','Metadata');
        %         save([dir_red,nameToWrite],'reg_red_all','Metadata');
        WriteTIFF(reg_grn_all,Metadata,[dir_green,'g_',nameToWrite])
        WriteTIFF(reg_red_all,Metadata,[dir_red,'r_',nameToWrite])
    else
        error('stack contains >2 channels')
    end
end
