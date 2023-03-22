
close all
clear all

user = '\\blinklab\Data0\users\Sudha\Data\Dec2022';
mice={'SS001','SS002','SS003','SS004','SS005','SS006','SS007','SS008'};

alldays={'221205','221206','221207','221208','221209','221212','221213','221214','221215','221216',...
         '221220','221221','221222','221227','221228','221229','221230','230103','230104','230109',...
         '230110','230111','230112','230113','230118','230120','230123','230124','230125','230126',...
         '230127','230206','230207','230217','230220','230221','230223','230224','230227','230228',...
         '230301','230302','230303','230306','230307','230308','230310','230312','230313','230317',...
         '230320','230321','230322'};
% alldays={'230222'};
[x,y]=CalibrationData;
database=[];allfec=[];
for ii= 1:length(mice)
    mouse = mice{ii};

    %     for jj=length(alldays)-15:length(alldays)
    for jj=3:length(alldays)
        clearvars -except ii mouse jj alldays1 alldays2 alldays mice user database x y allfec dates
        db=[];

        day=alldays{jj};

        folder2 = fullfile(user, mouse, day);
        if isfolder(folder2)
            cd(folder2)
            load trialdata.mat


            db(:,3)=trials.c_csnum;
            fec=trials.eyelidpos_1;
            allfec=[allfec; fec];
            db(:,4)=trials.c_usdur;

            for uu=1:length(trials.c_usdur)
                isi(uu)=trials.camtime(1,uu).time(2);
            end
            db(:,5)=isi;

            pre = 1:tm2frm(0.1);
            win=[];
            for i=1:length(trials.c_isi)
                win(i,:) = tm2frm(0.2+trials.c_isi(i)/1e3):tm2frm(0.2+trials.c_isi(i)/1e3+0.015);
            end

            CRamp_1 = NaN(1,length(trials.c_csnum));
            for i=1:length(trials.c_csnum)
                CRamp_1(i) = (max(trials.eyelidpos_1(i,win(i,:))) - mean(trials.eyelidpos_1(i,pre),2));%/(1-mean(trials.eyelidpos_1(alltrials(i),pre),2));
            end



            CRampclean(CRamp_1<0.2)=0;
            CRampclean(CRamp_1>=0.2)=1;
            CRampclean=CRampclean';
            db(:,6)=CRamp_1;
            db(:,7)=CRampclean;
            db(:,8)=win(:,1);
            [db2]=VoltoDB(x,y,trials.c_csinten(end));
            db(:,10)=db2;
            db(:,9)=trials.ITIs;
            db(:,1)=ii;
            db(:,2)=jj;%str2double(alldays{jj});
            dates{jj}=alldays{jj};
            database=[database; db];
        end
    end
end

indices=find(database(:,4)~=0);
database(indices,5)=database(indices,5)-25;

database=[database allfec];
clearvars -except allfec database dates
% plotCRs(database)


