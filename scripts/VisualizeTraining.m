close all
clear all
user = '\\blinklab\Data0\users\Sudha\Data\Dec2022';
% user = 'C:\Users\u239632\Documents\JML\data';
mice={'SS001','SS002','SS003','SS004','SS005','SS006','SS007','SS008'};

alldays={'230322'};
% mice={'testing'};
% alldays={'subtest'};
for ii= 1:length(mice)
    mouse = mice{ii};
    for jj=1:length(alldays)
    day=alldays{jj};
        folder = fullfile(user, mouse, day);
        if isdir(folder)
        trials = processTrialsWithEncoder(fullfile(folder,'compressed'));
        save(fullfile(folder, 'trialdata.mat'),'trials');
        end
    end
end
        



% close all
% clear all
% % figure('units','normalized','outerposition',[0 0 1 1])
% 
% user = '\\blinklab\Data0\users\Sudha\Data\Dec2022';
% mice={'SS001','SS002','SS003','SS004','SS005','SS006','SS007','SS008'};
% alldays={'230125','230126','230127','230206','230207'};
% [x,y]=CalibrationData;
% for ii= 1:length(mice)
%     mouse = mice{ii};
% %     figure('units','normalized','outerposition',[0 0 1 1])
%     figure
%     nn=1;
%     for jj=1:length(alldays)
%         clearvars -except ii mouse jj nn alldays mice user x y
%         day=alldays{jj};
%         folder2 = fullfile(user, mouse, day);
%         cd(folder2)
%         load trialdata.mat
%         tone1=trials.eyelidpos_1(trials.c_csnum==5,:);
% 
% 
%         timestamps_tone=(trials.camtime(trials.c_csnum==5).time);
% 
%         led1=trials.eyelidpos_1(trials.c_csnum==7,:);%./repmat(max(trials.eyelidpos_1(trials.c_csnum==7,:),[],2),1,200);
%        
%         timestamps_led=(trials.camtime(trials.c_csnum==7).time);
%       
% %         subplot(5,2,nn+1),plot(trials.encodertimes(1,:)./1000,tone1','k')
%         subplot(5,2,nn+1),plot((0:5:995)/1000,tone1','k')
%         ylabel(strcat('Day  ',day))%,'FontSize',30,'Rotation',0,'Position',[-20,0.5])
% 
% 
%         xlim([0 1.2])
%         hold on
%         ts=timestamps_tone;
%         plot([ts(1)/1000 ts(1)/1000],[0 1],'r','LineWidth',2)
%         for tt=2:length(timestamps_tone)
%             ts(tt)=timestamps_tone(tt)+ts(tt-1);
%             plot([ts(tt)/1000 ts(tt)/1000],[0 1],'r','LineWidth',2)
%             hold on
% 
%         end
%         [db]=VoltoDB(x,y,trials.c_csinten(1));
%         title(strcat('Tone=', num2str(db),'dB'),'FontSize',30)
% 
% %         subplot(5,2,nn),plot(trials.encodertimes(1,:)./1000,led1','k')
%         subplot(5,2,nn),plot((0:5:995)/1000,led1','k')
%         ylabel(strcat('Day  ',day))%,'FontSize',30,'Rotation',0,'Position',[-20,0.5])
% 
%       
%         xlim([0 1.2])
%         hold on
%         ts=timestamps_tone;
%         plot([ts(1)/1000 ts(1)/1000],[0 1],'r','LineWidth',2)
%         for tt=2:length(timestamps_led)
%             ts(tt)=timestamps_led(tt)+ts(tt-1);
%             plot([ts(tt)/1000 ts(tt)/1000],[0 1],'r','LineWidth',2)
%             hold on
%         end
%         title('LED','FontSize',30)
% %         ylabel(strcat('Day  ',day),'FontSize',30,'Rotation',0,'Position',[-20,0.5])
%         nn=nn+2;
% 
%     end
%     cd('C:\Users\u239632\Desktop\figs')
%     sgtitle(mouse, 'FontSize',50)
%     saveas(gcf,strcat(mouse,'CR Traces'),'png')
% end
% 
% % FolderName = 'C:\Users\u239632\Desktop\figs';
% % FigList = findobj(allchild(0), 'flat', 'Type', 'figure');  
% % for iFig = 1:length(FigList)
% %     FigHandle = FigList(iFig);
% %     FigName   = num2str(get(FigHandle, 'Number'));
% %     set(0, 'CurrentFigure', FigHandle);
% %     savefig(fullfile(FolderName, [FigName '.fig']));
% % end
% 
