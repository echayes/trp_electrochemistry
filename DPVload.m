function [Vall,Iall]=DPVload(echem_file);
% -------------------------------------------------------------------------
ID=fopen(echem_file,'r');
% -------------------------------------------------------------------------
% move to line in text file with data
for i=1:65;
    fgetl(ID);
end
formatparams = '%f %f %f %f %f %f %f %f %f %f %f %*[...........]';
size = [11,Inf];
DPV_= fscanf(ID,formatparams,size);
DPV=DPV_';
Vfwd=DPV(:,3);
Vrev=DPV(:,4);
Vstep=DPV(:,5);
Ifwd=DPV(:,6);
Irev=DPV(:,7);
Idif=DPV(:,8);
sig=DPV(:,9);
ach=DPV(:,10);
fclose(ID);
Iall=[Ifwd Irev Idif];
Vall=[Vfwd Vrev Vrev];
%fclose(ID);

%cd(oldfolder);
end
