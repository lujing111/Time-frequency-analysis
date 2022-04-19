clc
clear
close all

tic
%%
%addpath 'F:\matlab\toolbox\fieldtrip-20181012';
addpath 'C:\Users\Administrator\Documents\MATLAB\Add-Ons\fieldtrip-20181012';
ft_defaults;
Path = 'D:\Children_open1\';
dname = uigetdir(Path);
listing = dir(Path);
filename = {listing.name};
filename = filename(3:end)';
SubNum = length(filename);

for i = 1:SubNum
    subPath = strcat('D:\Children_open1\',char(filename(i)));   % The path of each subject's EEG data in A/AV0/AV200 folder
    cd(subPath)
    file = 'Step05_Resample_Epoch.set';
    hdr = ft_read_header(file); 
    data = ft_read_data(file, 'header', hdr);
    interest_elec = ['F3';'F4';'Fz';'F7';'F8';'C3';'CZ';'C4';'P3';'P4';'Pz';'P7';'P8';'O1';'O2'];
    %data1 = squeeze(data([13 69 7 20 67 22 70 58 32 49 37 35 52 41 45],:));
    %64导的nuronscan
    data1 = squeeze(data([8 12 10 6 14 26 28 30 44 48 46 42 50 59 61],:));
    fs = 250;
    window = 8*fs;
    noverlap = 2*fs;
    nfft = 10*fs ;
    for k = 1:size(data1,1)
       [S,F,T,P_o] = spectrogram(data1(k,:),window,noverlap,nfft,fs, 'power');
       P1 = mean(P_o,2);
       P2_o = mean(P_o(find(F>=8 & F<=12),:),2);
       addpath 'C:\Users\Administrator\Documents\MATLAB\Add-Ons\fieldtrip-20181012';
       ft_defaults;
       Path = 'D:\Children_close1\';
       %dname = uigetdir(Path);
       listing_c = dir(Path);
       filename_c = {listing_c.name};
       filename_c = filename_c(3:end)';
       SubNum_c = length(filename_c);  
       subPath_c = strcat('D:\Children_close1\',char(filename_c(i)));   % The path of each subject's EEG data in A/AV0/AV200 folder
       cd(subPath_c)
       file_c = 'Step05_Resample_Epoch.set';
       hdr_c = ft_read_header(file_c); 
       data_c = ft_read_data(file_c, 'header', hdr_c);
       interest_elec = ['F3';'F4';'Fz';'F7';'F8';'C3';'CZ';'C4';'P3';'P4';'Pz';'P7';'P8';'O1';'O2'];
       data1_c = squeeze(data_c([13 69 7 20 67 22 70 58 32 49 37 35 52 41 45],:));
       %64导的nuronscan
       %data1_c = squeeze(data_c([8 12 10 6 14 26 28 30 44 48 46 42 50 59 61],:));
       [S_c,F_c,T_c,P_c] = spectrogram(data1_c(k,:),window,noverlap,nfft,fs, 'power');
       P1_c = mean(P_c,2);
       P2_c = mean(P_c(find(F>=8 & F<=12),:),2); 
       P2 = P2_c-P2_o;   
       [M,I] = max(P2(:));
       fm_c = (I+79)/10;
       sub_peak_frequency(i,k) = fm_c;
       P_total_c = sum(mean(P_c(find(F>=1 & F<=40),:),2));
       P_delta_c = sum(mean(P_c(find(F>=1 & F<=0.4*fm_c),:),2));
       P_theta_c = sum(mean(P_c(find(F>0.4*fm_c & F<=0.8*fm_c),:),2));
       P_alpha_c = sum(mean(P_c(find(F>0.8*fm_c & F<=1.2*fm_c),:),2));
       P_beta_c = sum(mean(P_c(find(F>1.2*fm_c & F<=3*fm_c),:),2));
       P_gamma_c = sum(mean(P_c(find(F>3*fm_c & F<=40),:),2));
       P_Halpha_c = sum(mean(P_c(find(F>=0.8*fm_c & F<=fm_c),:),2));
       P_Lalpha_c = sum(mean(P_c(find(F>fm_c & F<=1.2*fm_c),:),2));
      
       sub_c(i,k,1) = P_delta_c/P_total_c;
       sub_c(i,k,2) = P_theta_c/P_total_c;
       sub_c(i,k,3) = P_alpha_c/P_total_c;
       sub_c(i,k,4) = P_beta_c/P_total_c;
       sub_c(i,k,5) = P_gamma_c/P_total_c;
      
       
       sub_c_alpha(i,k,1) = P_Halpha_c/P_total_c;
       sub_c_alpha(i,k,2) = P_Lalpha_c/P_total_c;
       
       P_total= sum(mean(P_o(find(F>=1 & F<=40),:),2));
       P_delta = sum(mean(P_o(find(F>=1 & F<=0.4*fm_c),:),2));
       P_theta = sum(mean(P_o(find(F>0.4*fm_c & F<=0.8*fm_c),:),2));
       P_alpha = sum(mean(P_o(find(F>0.8*fm_c & F<=1.2*fm_c),:),2));
       P_beta = sum(mean(P_o(find(F>1.2*fm_c & F<=3*fm_c),:),2));
       P_gamma = sum(mean(P_c(find(F>3*fm_c & F<=40),:),2));
       P_Halpha = sum(mean(P_o(find(F>=0.8*fm_c & F<=fm_c),:),2));
       P_Lalpha = sum(mean(P_o(find(F>fm_c & F<=1.2*fm_c),:),2));
       
       sub(i,k,1) = P_delta/P_total;
       sub(i,k,2) = P_theta/P_total;
       sub(i,k,3) = P_alpha/P_total;
       sub(i,k,4) = P_beta/P_total;
       sub(i,k,5) = P_gamma/P_total;
       
       sub_alpha(i,k,1) = P_Halpha/P_total;
       sub_alpha(i,k,2) = P_Lalpha/P_total;
    end
end

%将三维转换成二维，三维数组中，行i表示被试，列k代表电极点，页12345代表频段
sub_open2D=reshape(sub,i,k*5);
sub_close2D=reshape(sub_c,i,k*5);
sub_alpha_open_2D=reshape(sub_alpha,i,k*2);
sub_alpha_close_2D=reshape(sub_c_alpha,i,k*2);

%拼接顺序：睁眼、闭眼、峰值alpha、睁眼高低alpha、闭眼高低alpha
result=horzcat(sub_open2D,sub_close2D,sub_peak_frequency,sub_alpha_open_2D,sub_alpha_close_2D);
%输出到Data_intergation的excel文件中，其中的sheet叫做Adult_egi,如为儿童数据就改为Child,第一列A1为被试文件名
xlswrite('Data_intergation',result,'child_egi','A1');
xlswrite('Data_intergation',filename,'child_egi','A1');
       
       
       
       