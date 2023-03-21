% function plotCRamp(database)
%
%
close all
load('Database_031523.mat')
for ii=1:8
    
    clearvars -except database ii nn dates
    newdb=[];newdb_led=[];newdb_tone=[];
    newdb=database(database(:,1)==ii & database(:,2)>0,:);
    newdb_led=newdb(newdb(:,3)==7,:);
    newdb_tone=newdb(newdb(:,3)==5,:);


    mouse=strcat('SS00',num2str(ii),' CR Traces-LED');
    newdb2=[];newdb2_led=[];newdb2_tone=[];mm=1;
    newdb2=newdb_led;
    days=unique(newdb2(:,2));
    figure('units','normalized','outerposition',[0.5 0.5 0.4 0.5])
    for pp=1:length(days)
        ledtrials=[];ledtrials_test=[];tonetrials=[];tonetrials_test=[];
        ledtrials=newdb2(newdb2(:,2)==days(pp) & newdb2(:,3)==7 & newdb2(:,4)~=0,:);
        ledtrials_test=newdb2(newdb2(:,2)==days(pp) & newdb2(:,3)==7 & newdb2(:,4)==0,:);

        if ~isempty(ledtrials)
            subplot(7,7,mm),
            plot((0:5:995)/1000,ledtrials(:,11:end)','color',[0.5 0.5 0.5]);
            hold on
            if ~isempty(ledtrials_test)
                plot((0:5:995)/1000,ledtrials_test(:,11:end)','r')
            end
%             plot((0:5:995)/1000,mean(ledtrials(ledtrials(:,7)==1,11:end),1),'k','LineWidth',2)
            plot([(ledtrials(end,5)+200)/1000 (ledtrials(end,5)+200)/1000],[0 1],'k','LineWidth',2)
            plot([200/1000 200/1000],[0 1],'k','LineWidth',2)
            title(strcat(num2str(days(pp)),'-',dates{days(pp)},'LED'))
            mm=mm+1;
        end
    end
    sgtitle(strcat('SS00',num2str(ii),'-LED'))
    saveas(gcf,mouse,'png')

    mouse=strcat('SS00',num2str(ii),' CR Traces-Tone');
    newdb2=[];newdb2_led=[];newdb2_tone=[];mn=1;
    newdb2=newdb_tone;
    days=unique(newdb2(:,2));
    figure('units','normalized','outerposition',[0.5 0.5 0.4 0.5])
    for pp=1:length(days)
        ledtrials=[];ledtrials_test=[];tonetrials=[];tonetrials_test=[];
        tonetrials=newdb2(newdb2(:,2)==days(pp) & newdb2(:,3)==5 & newdb2(:,4)~=0,:);
        tonetrials_test=newdb2(newdb2(:,2)==days(pp) & newdb2(:,3)==5 & newdb2(:,4)==0,:);
        if ~isempty(tonetrials)
            subplot(7,7,mn),
            plot((0:5:995)/1000,tonetrials(:,11:end)','color',[0.5 0.5 0.5])
            hold on
            if ~isempty(tonetrials_test)
                plot((0:5:995)/1000,tonetrials_test(:,11:end)','r')
            end
            plot([(tonetrials(1,5)+200)/1000 (tonetrials(1,5)+200)/1000],[0 1],'k','LineWidth',2)
            plot([200/1000 200/1000],[0 1],'k','LineWidth',2)
            db=tonetrials(1,10);
            title(strcat('Tone=', num2str(db),'dB','-',num2str(days(pp)),'-',dates{days(pp)}))
            mn=mn+1;
        end
    end
    sgtitle(strcat('SS00',num2str(ii),'-Tone'))
    cd('C:\Users\u239632\Documents\JML\results')
    saveas(gcf,mouse,'png')
end



