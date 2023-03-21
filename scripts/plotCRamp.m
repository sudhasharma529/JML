% function plotCRamp(database)
%
%
close all
nn=1;
for ii=1:8
    figure('units','normalized','outerposition',[0.5 0.5 0.4 0.5])
    clearvars -except database ii nn dates
    newdb=[];newdb_led=[];newdb_tone=[];
    newdb=database(database(:,1)==ii & database(:,2)>0,:);
    newdb_led=newdb(newdb(:,3)==7,:);
    newdb_tone=newdb(newdb(:,3)==5,:);

    mouse=strcat('SS00',num2str(ii),' CR Amplitude');

    subplot(2,1,nn), plot(find(newdb_led(:,4)==0),newdb_led(newdb_led(:,4)==0,6),'*r')
    hold on
    subplot(2,1,nn), plot(1:length(newdb_led(:,6)),newdb_led(:,6),'.b')
    subplot(2,1,nn), plot(find(newdb_led(:,6)>0.2),newdb_led(newdb_led(:,6)>0.2,6),'.r')
    ylim([-0.2 1.1])
    sessions=unique(newdb_led(:,2));
    numsess_train=[];numsess_test=[];CRpercent_train=[];CRpercent_test=[];
    for kk=1:length(sessions)
        numsess_train(kk)=size(newdb_led(newdb_led(:,2)==sessions(kk) & newdb_led(:,4)~=0,7,:),1);
        numsess_test(kk)=size(newdb_led(newdb_led(:,2)==sessions(kk) & newdb_led(:,4)==0,7,:),1);
        CRpercent_train(kk)=100*sum(newdb_led(newdb_led(:,2)==sessions(kk) & newdb_led(:,4)~=0,7))/numsess_train(kk);
        CRpercent_test(kk)=100*sum(newdb_led(newdb_led(:,2)==sessions(kk) & newdb_led(:,4)==0,7))/numsess_test(kk);
    end
    numsess=cumsum(numsess_train+numsess_test);
    hold on
    for ll=1:length(numsess)
        plot([numsess(ll) numsess(ll)],[-0.2 1.1],'k')
        hold on
    end
    mouse1=strcat('SS00',num2str(ii),' -LED-',num2str(newdb_led(1,5)));
    title(mouse1)
    ylabel('CR amplitude')
    xlabel('Trial no')
    ylim([-0.2 1.3])
    xlim([0 max(size(newdb_led,1),size(newdb_tone,1))])
    xticks(numsess)
    for ll=1:length(CRpercent_train)
        if ll==1
            tif=fix((numsess(ll))/2);
        else
            tif=numsess(ll-1)+fix((numsess(ll)-numsess(ll-1))/2);
        end

        text(tif,1,num2str(round(CRpercent_train(ll))))
        text(tif,1.1,num2str(round(CRpercent_test(ll))))
        text(tif,1.2,num2str(sessions(ll)))
    end
    text(-200,1.2,'Day->')
    text(-200,1,'train trl perf%')
    text(-200,1.1,'test trl perf%')

    subplot(2,1,nn+1), plot(find(newdb_tone(:,4)==0),newdb_tone(newdb_tone(:,4)==0,6),'*r')
    hold on
    subplot(2,1,nn+1), plot(1:length(newdb_tone(:,6)),newdb_tone(:,6),'.b')
    subplot(2,1,nn+1), plot(find(newdb_tone(:,6)>0.2),newdb_tone(newdb_tone(:,6)>0.2,6),'.r')
    ylim([-0.2 1.1])



    sessions=[];
    numsess=[];
    sessions=unique(newdb_tone(:,2));
    numsess_train=[];numsess_test=[];CRpercent_train=[];CRpercent_test=[];
    for kk=1:length(sessions)
        numsess_train(kk)=size(newdb_tone(newdb_tone(:,2)==sessions(kk) & newdb_tone(:,4)~=0,7,:),1);
        numsess_test(kk)=size(newdb_tone(newdb_tone(:,2)==sessions(kk) & newdb_tone(:,4)==0,7,:),1);
        CRpercent_train(kk)=100*sum(newdb_tone(newdb_tone(:,2)==sessions(kk) & newdb_tone(:,4)~=0,7))/numsess_train(kk);
        CRpercent_test(kk)=100*sum(newdb_tone(newdb_tone(:,2)==sessions(kk) & newdb_tone(:,4)==0,7))/numsess_test(kk);
    end
    numsess=cumsum(numsess_train+numsess_test);
    hold on
    for ll=1:length(numsess)
        plot([numsess(ll) numsess(ll)],[-0.2 1.1],'k')
        hold on
    end
    mouse1=strcat('SS00',num2str(ii),'- Tone-',num2str(newdb_tone(1,5)));
    title(mouse1)
    ylabel('CR amplitude')
    xlabel('Trial no')
    ylim([-0.2 1.3])
    xticks(numsess)
    xlim([0 max(size(newdb_led,1),size(newdb_tone,1))])
    for ll=1:length(CRpercent_train)
        if ll==1
            tif=fix((numsess(ll))/2);
        else
            tif=numsess(ll-1)+fix((numsess(ll)-numsess(ll-1))/2);
        end
        text(tif,1,num2str(round(CRpercent_train(ll))))
        text(tif,1.1,num2str(round(CRpercent_test(ll))))
        text(tif,1.2,num2str(sessions(ll)))
    end
    text(-200,1.2,'Day->')
    text(-200,1,'train_perf%')
    text(-200,1.1,'test_perf%')
    cd('C:\Users\u239632\Documents\JML\results')
    saveas(gcf,mouse,'png')


    figure('units','normalized','outerposition',[0.5 0.5 0.3 0.5])
    mouse=strcat('SS00',num2str(ii),' CR Traces');
    newdb2=[];newdb2_led=[];newdb2_tone=[];mm=1;
    newdb2=newdb(newdb(:,2)>=max(newdb(:,2))-4,:);
    days=unique(newdb2(:,2));
    for pp=1:length(days)
        ledtrials=[];ledtrials_test=[];tonetrials=[];tonetrials_test=[];
        ledtrials=newdb2(newdb2(:,2)==days(pp) & newdb2(:,3)==7 & newdb2(:,4)~=0,:);
        ledtrials_test=newdb2(newdb2(:,2)==days(pp) & newdb2(:,3)==7 & newdb2(:,4)==0,:);
        tonetrials=newdb2(newdb2(:,2)==days(pp) & newdb2(:,3)==5 & newdb2(:,4)~=0,:);
        tonetrials_test=newdb2(newdb2(:,2)==days(pp) & newdb2(:,3)==5 & newdb2(:,4)==0,:);


        if ~isempty(ledtrials)
            if ~isempty(ledtrials_test)
                subplot(5,2,mm),
                plot((0:5:995)/1000,ledtrials(:,11:end)','color',[0.5 0.5 0.5]);
                hold on
                plot((0:5:995)/1000,ledtrials_test(:,11:end)','r')
                plot((0:5:995)/1000,mean(ledtrials(ledtrials(:,7)==1,11:end),1),'k','LineWidth',2)
                plot([(ledtrials(1,5)+200)/1000 (ledtrials(1,5)+200)/1000],[0 1],'k','LineWidth',2)
                plot([200/1000 200/1000],[0 1],'k','LineWidth',2)
                title(strcat(num2str(days(pp)),'-',dates{days(pp)},'LED'))
            end
        end

        if ~isempty(tonetrials)
            if ~isempty(tonetrials_test)
                subplot(5,2,mm+1),
                plot((0:5:995)/1000,tonetrials(:,11:end)','color',[0.5 0.5 0.5])
                hold on
                plot((0:5:995)/1000,tonetrials_test(:,11:end)','r')
                plot([(tonetrials(1,5)+200)/1000 (tonetrials(1,5)+200)/1000],[0 1],'k','LineWidth',2)
                plot([200/1000 200/1000],[0 1],'k','LineWidth',2)
                db=tonetrials(1,10);
                title(strcat('Tone=', num2str(db),'dB','-',dates{days(pp)}))
            end
        end
        sgtitle(strcat('SS00',num2str(ii)))

        mm=mm+2;
    end
    cd('C:\Users\u239632\Documents\JML\results')
    saveas(gcf,mouse,'png')



end





















% % ITI distribution
% %
% %
% close all
% nn=1;
% for ii=[1,2,3,4,5,7,8]
%     %     figure%('units','normalized','outerposition',[0 0 1 1])
%     clearvars -except database ii nn
%     newdb=[];newdb_led=[];newdb_tone=[];
%     newdb=database(database(:,1)==ii & database(:,2)>0,:);
%     newdb_led=newdb(newdb(:,3)==7,:);
%     newdb_tone=newdb(newdb(:,3)==5,:);
%
%     mouse=strcat('SS00',num2str(ii),'LED');
%
%     subplot(7,4,nn),histogram(newdb_led(:,9),100,'BinWidth',2)
%     xlim([0 100])
%     ylim([0 200])
%     title(mouse)
%     ylabel('No of samples')
%     xlabel('Inter trial interval')
%
%     subplot(7,4,nn+1),histogram(mean(newdb_led(:,40:45),2),50)
%     title(mouse)
%     ylabel('No of samples')
%     xlabel('baseline FEC')
%     xlim([-0.5 1])
%
% %     subplot(8,3,nn+2),plot((1:5:1000)/1000,newdb_led(find(newdb_led(:,4)==0),10:209))
%     mouse=strcat('SS00',num2str(ii),'Tone');
%     subplot(7,4,nn+2),histogram(newdb_tone(:,9),100,'BinWidth',2)
%     xlim([0 100])
%     ylim([0 200])
%     title(mouse)
%     ylabel('No of samples')
%     xlabel('Inter trial interval')
%
%     subplot(7,4,nn+3),histogram(mean(newdb_tone(:,40:45),2),50)
%     title(mouse)
%     ylabel('No of samples')
%     xlabel('baseline FEC')
%     xlim([-0.5 1])
%
%
% nn=nn+4;
% end
%
%
%
%
% % function plotCRamp(database)
% %
% %
% close all
% figure
% nn=1;
% for ii=[1,2,3,4,5,7,8]
%     %     figure%('units','normalized','outerposition',[0 0 1 1])
%     clearvars -except database ii nn
%     newdb=[];newdb_led=[];newdb_tone=[];newdb_led2=[];newdb_tone2=[];
%     newdb=database(database(:,1)==ii & database(:,2)>0,:);
%     newdb_led=newdb(newdb(:,3)==7,:);
%     newdb_tone=newdb(newdb(:,3)==5,:);
%
%     mouse=strcat('SS00',num2str(ii),' -LED-',num2str(newdb_led(1,5)));
%     newdb_led2=newdb_led(find(newdb_led(:,2)>29),:);
%     subplot(7,2,nn),plot((1:5:1000)/1000,newdb_led2(find(newdb_led2(:,4)==0),10:209),'k')
%     title(mouse)
%     ylim([-0.2 1.2])
%     hold on
%     if ii<5
%     plot([(40*5)/1000 (40*5)/1000],[-0.2 1.2],'r','LineWidth',2)
%     plot([(80*5)/1000 (80*5)/1000],[-0.2 1.2],'r','LineWidth',2)
%     else
%     plot([(40*5)/1000 (40*5)/1000],[-0.2 1.2],'r','LineWidth',2)
%     plot([(160*5)/1000 (160*5)/1000],[-0.2 1.2],'r','LineWidth',2)
%     end
%     mouse=strcat('SS00',num2str(ii),' -tone-',num2str(newdb_tone(1,5)));
%     newdb_tone2=newdb_tone(find(newdb_tone(:,2)>29),:);
%     subplot(7,2,nn+1),plot((1:5:1000)/1000,newdb_tone2(find(newdb_tone2(:,4)==0),10:209),'k')
%     title(mouse)
%     ylim([-0.2 1.2])
%     hold on
%     if ii<5
%     plot([(40*5)/1000 (40*5)/1000],[-0.2 1.2],'r','LineWidth',2)
%     plot([(160*5)/1000 (160*5)/1000],[-0.2 1.2],'r','LineWidth',2)
%     else
%     plot([(40*5)/1000 (40*5)/1000],[-0.2 1.2],'r','LineWidth',2)
%     plot([(80*5)/1000 (80*5)/1000],[-0.2 1.2],'r','LineWidth',2)
%     end
%
%     sgtitle('TestTrials last 5 days combined for each animal')
%     nn=nn+2;
% end
%
%
%
%
%
%
%
%
