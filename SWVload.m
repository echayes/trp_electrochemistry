%%
function [Vall,Iall]=SWVload(echem_file);
% -------------------------------------------------------------------------
ID=fopen(echem_file,'r');
% -------------------------------------------------------------------------
% move to line in text file with data
for i=1:65;
    fgetl(ID);
end
formatparams = '%f %f %f %f %f %f %f %f %f %f %f %*[...........]';
size = [11,Inf];
SWV_= fscanf(ID,formatparams,size);
SWV=SWV_'
Vfwd=SWV(:,3);
Vrev=SWV(:,4);
Vstep=SWV(:,5);
Ifwd=SWV(:,6);
Irev=SWV(:,7);
Idif=SWV(:,8);
sig=SWV(:,9);
ach=SWV(:,10);
fclose(ID);
Iall=[Ifwd Irev Idif];
Vall=[Vfwd Vrev Vstep];

%cd(oldfolder);
end
