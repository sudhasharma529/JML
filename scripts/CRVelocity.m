clear 
close all

load('Database_031523.mat')

nn=1;
for ii=8%[5,7,8]
    clearvars -except database ii nn
    
    allonsets=[];db=[];

    if ii==8
        daysbef=29:33;
    elseif ii==5
        daysbef=24:28;
    elseif ii==7
        daysbef=26:30;
    end
    daysaft=44:49;


    ledtrials=database(database(:,1)==ii & database(:,3)==7 & database(:,7)~=0,:);
    tonetrials=database(database(:,1)==ii & database(:,3)==5 & database(:,7)~=0,:);

    bef=ledtrials(ledtrials(:,2)>=daysbef(1) & ledtrials(:,2)<=daysbef(end),:);
    aft=ledtrials(ledtrials(:,2)>=daysaft(1) & ledtrials(:,2)<=daysaft(end),:);

    norm_bef=bef(:,51:170)-mean(bef(:,40:50),2);

    slps_bef=[];crlatency_bef=[];select_trace=[];
    for ll=1:size(norm_bef,1)
        [V,I]=max(norm_bef(ll,:));
        bf2=[];
        bf2=norm_bef(ll,1:I);
        if length(bf2)>20
            [param,stat]=sigm_fit(1:length(bf2),bf2,[],[],[]);
            fit=goodnessOfFit(bf2',stat.ypred,'MSE');
            if param(4)<0.5 && param(4)>0 && fit<0.0099
                slps_bef(ll)=param(4);
                crlatency_bef(ll)=knee_pt(stat.ypred);
                %                 select_trace(ll,:)=stat.ypred;
                plot(bf2)
                hold on
                plot(stat.ypred,'r')
                hold on
                plot(crlatency_bef(ll),0,'*r')
                pause
                clf
            end
        end
    end

remain=bef(nonzeros(crlatency_bef),:);
[V,I]=sort(nonzeros(crlatency_bef));
subplot(2,2,1),imagesc(remain(:,1:end))
subplot(2,2,2),imagesc(remain(I,1:end))
newbefs=remain(I,1:end);
newlats=remain_lats(I);
figure

for ii=1:size(newbefs,1)
    plot(newbefs(ii,:))
    hold on
    plot(newlats(ii)+40,0,'*r')
    pause
    clf
end

remain_lats=nonzeros(crlatency_bef);
hold on
plot(remain_lats(I),1:length(remain_lats),'*r')









    norm_aft=aft(:,51:170)-mean(aft(:,40:50),2);
    slps_aft=[];crlatency_aft=[];
    for ll=1:size(norm_aft,1)
        [V,I]=max(norm_aft(ll,:));
        aft2=[];
        aft2=norm_aft(ll,1:I);
        if length(aft2)>20
            [param,stat]=sigm_fit(1:length(aft2),aft2,[],[],[]);
            fit=goodnessOfFit(aft2',stat.ypred,'MSE');
            if param(4)<0.5 && param(4)>0 && fit<0.0099
                slps_aft(ll)=param(4);
                crlatency_aft(ll)=knee_pt(stat.ypred);
                
            end
        end
    end
    close


    myboxplot(nonzeros(slps_bef),nonzeros(slps_aft))
    
    ylabel('FEC per unit time')
    xticklabels({'Before tone(200msISI) removal','After tone(200msISI) removal'})
    sgtitle(strcat('SS00',num2str(ii),'CR Velocity to','-LED(600msISI)'))
    mouse=strcat('SS00',num2str(ii),'CR Velocity to','-LED(600msISI)');
    cd('C:\Users\u239632\Documents\JML\results')
    saveas(gcf,mouse,'png')

    myboxplot(nonzeros(crlatency_bef),nonzeros(crlatency_aft))

    ylabel('CR Latency')
    xticklabels({'Before tone(200msISI) removal','After tone(200msISI) removal'})
    sgtitle(strcat('SS00',num2str(ii),' CR Latency to','-LED(600msISI)'))
    mouse=strcat('SS00',num2str(ii),'CR Latency to','-LED(600msISI)');
    cd('C:\Users\u239632\Documents\JML\results')
    saveas(gcf,mouse,'png')
end







% close all
% load('Database_031523.mat')
% for ii=[5,7,8]
%     figure('units','normalized','outerposition',[0.5 0.5 0.3 0.3])
%     allonsets=[];db=[];
%     clearvars -except database ii nn allonsets
%     newdb=[];newdb_led=[];newdb_tone=[];
%     newdb=database(database(:,1)==ii & database(:,2)>0,:);
%     newdb_led=newdb(newdb(:,3)==7,:);
%     newdb_tone=newdb(newdb(:,3)==5,:);
%
%     days=unique(newdb_led(:,2));
%     for pp=1:length(days)
%
%         ledtrials=[];fec=[];ISI=[];onsets=[];newonsets=[];
%         ledtrials=newdb_led(newdb_led(:,2)==days(pp), :);
%
%         bf=ledtrials(:,51:170)-mean(ledtrials(:,40:50),2);
%         nn=1;slps_bef=[];
%         for ll=1:size(bf,1)
%             xx=[];bf2=[];
%             [V,I]=max(bf(ll,:));bf2=bf(ll,1:I);
%             if length(bf2)>20
%                 xx=1:1:length(bf2);
%                 [param,stat]=sigm_fit(xx,bf2,[],[],[]);
%                 fit(ll)=goodnessOfFit(bf2',stat.ypred(1:length(bf2)),'MSE');
%                 %             title(fit(ll))
%                 %             pause
%                 %             clf
%                 if param(4)<0.5&param(4)>0 & fit(ll)<0.0099
%                     slps_bef(nn)=param(4);
%                     nn=nn+1;
%                 end
%             end
%         end
%
%         scatter(ones(1,length(slps_bef))*pp,slps_bef,'filled','SizeData',10,'Jitter','on','JitterAmount',0.1)
%         meds(pp)=median(nonzeros(slps_bef));
%         hold on
%
%     end
%
%     mouse=strcat('SS00',num2str(ii),'CR Velocity to','-LED(600msISI)');
%     plot(meds,'k','LineWidth',2)
%     ylabel('FEC per unit time')
%     xlabel('Day of recording')
%     sgtitle(mouse, 'FontSize',10)
%     cd('C:\Users\u239632\Documents\JML\results')
%     saveas(gcf,mouse,'png')
% end
