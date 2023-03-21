% function plotCRamp(database)
%
%
load('Database_031523.mat')
nn=1;
for ii=[5,7,8]
    figure('units','normalized','outerposition',[0 0 0.3 0.5])
    clearvars -except database ii nn
    newdb=[];newdb_led=[];newdb_tone=[];
    newdb=database(database(:,1)==ii & database(:,2)>0,:);
    newdb_led=newdb(newdb(:,3)==7,:);
    newdb_tone=newdb(newdb(:,3)==5,:);

    mouse=strcat('SS00',num2str(ii),' mean CR Traces for last 30 days');


    cols=colormap(summer);
    newdb2=[];newdb2_led=[];newdb2_tone=[];mm=1;
    newdb2=newdb(newdb(:,2)>20,:);
    days=unique(newdb2(:,2));
    for pp=1:length(days)
        ledtrials=[];
        ledtrials=newdb2(newdb2(:,2)==days(pp) & newdb2(:,3)==7  & newdb2(:,7)==1,:);

        if ~isempty(ledtrials)
            mt=mean(ledtrials(:,11:end),1);
            mt=mt-mean(mt(30:40));
            mt=mt/max(mt);
            plot((0:5:995)/1000,mt,'color',cols(pp*8,:),'LineWidth',2);
            hold on
        end
    mm=mm+2;
    end
    hold on
    plot([200/1000 200/1000],[0 1],'k','LineWidth',2)
    plot([800/1000 800/1000],[0 1],'k','LineWidth',2)
    colorbar('Ticks',[0 0.25 0.5 0.75 1],...
        'TickLabels',{num2str(days(1)), num2str(days(7)), num2str(days(13)), num2str(days(19)), num2str(days(25))})
    title(mouse)
    ylabel('mean FEC of successful trials')
    xlabel('Time(s)')
    cd('C:\Users\u239632\Documents\JML\results')
    saveas(gcf,mouse,'png')
end




% nn=1;
% for ii=[2 3 4]
%     figure('units','normalized','outerposition',[0 0 0.3 0.5])
%     clearvars -except database ii nn
%     newdb=[];newdb_led=[];newdb_tone=[];
%     newdb=database(database(:,1)==ii & database(:,2)>0,:);
%     newdb_led=newdb(newdb(:,3)==7,:);
%     newdb_tone=newdb(newdb(:,3)==5,:);
% 
%     mouse=strcat('SS00',num2str(ii),' mean CR Traces for last 20 days');
% 
% 
%     cols=colormap(summer);
%     newdb2=[];newdb2_led=[];newdb2_tone=[];mm=1;
%     newdb2=newdb(newdb(:,2)>20,:);
%     days=unique(newdb2(:,2));
%     for pp=1:length(days)
%         ledtrials=[];
%         ledtrials=newdb2(newdb2(:,2)==days(pp) & newdb2(:,3)==5  & newdb2(:,7)==1,:);
% 
%         if ~isempty(ledtrials)
%             mt=mean(ledtrials(:,11:end),1);
%             plot((0:5:995)/1000,mt,'color',cols(pp*8,:),'LineWidth',2);
%             hold on
%         end
% mm=mm+2;
%     end
%     hold on
%     plot([200/1000 200/1000],[0 1],'k','LineWidth',2)
%     plot([800/1000 800/1000],[0 1],'k','LineWidth',2)
%     title(mouse)
%     cd('C:\Users\u239632\Documents\JML\results')
%     saveas(gcf,mouse,'png')
% end
% 
% 
% 
% 
% 
% 









% onsets=calculateCRonsets_OddballPaper(fec',ISI,@tm2frm,@frm2tm,CRwindow);


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
