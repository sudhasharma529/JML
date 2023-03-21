% function plotCRs(database2)

close all
clear all

load('Database_031523.mat')
database2=database;
% database2(:,5)=(database2(:,5)+200)/5;
for ii=1:8
    figure
    nn=1;
    clearvars -except database database2 ii nn
    newdb=[];newdb_led=[];newdb_tone=[];newdbb=[];
    newdbb=database2(database2(:,1)==ii,:);
    newdb=newdbb(newdbb(:,2)==max(newdbb(:,2)-5),:);
    newdb_led=newdb(newdb(:,3)==7,:);
    newdb_tone=newdb(newdb(:,3)==5,:);


    aligned_to_start_led_train=newdb_led(newdb_led(:,6)>0.2 & newdb_led(:,4)~=0,11:end);
    subplot(2,2,nn),plot(mean(aligned_to_start_led_train,1))
    hold on
    aligned_to_start_tone_train=newdb_tone(newdb_tone(:,6)>0.2 & newdb_tone(:,4)~=0,11:end);
    subplot(2,2,nn),plot(mean(aligned_to_start_tone_train,1))
    title('train trials(aligned to start)')
    plot([newdb_led(1,5) newdb_led(1,5)],[0 1],'k')
    plot([newdb_tone(1,5) newdb_tone(1,5)],[0 1],'k')
    xlim([0 200])
    legend('led','tone','','Location','northwest','FontSize',5)
    text(70,-0.1,'tone puff')
    text(150,-0.1,'led puff')
    ylabel('mean CR amplitude')
    xlabel('Time(ms)')
    ylim([-0.2 1.2])
    xticks(0:20:200)
    xticklabels({'0','100','200','300','400','500','600','700','800','900','1000'})
    legend('boxoff')


    aligned_to_puff_led_train=aligned_to_start_led_train(:,newdb_led(:,5)-70:newdb_led(:,5)+20);
    aligned_to_puff_tone_train=aligned_to_start_tone_train(:,newdb_tone(:,5)-70:newdb_tone(:,5)+20);
    subplot(2,2,nn+1),plot(mean(aligned_to_puff_led_train,1))
    hold on
    subplot(2,2,nn+1),plot(mean(aligned_to_puff_tone_train,1))
    title('train trials(aligned to puff)')
    plot([70 70],[0 1],'k')
    xlim([0 100])
    legend('led','tone','','Location','northwest','FontSize',5)
    ylabel('mean CR amplitude')
    xlabel('Time(ms)')
    ylim([-0.2 1.2])
    xticks(0:10:100)
    xticklabels({ '-350' , '-300' , '-250' ,'-200' , '-150' , '-100' ,  '-50'  ,   'puff'   , '50'  , '100','150'})
    legend('boxoff')



    aligned_to_start_led_test=newdb_led(newdb_led(:,6)>0.2 & newdb_led(:,4)==0,9:end);
    subplot(2,2,nn+2),plot(mean(aligned_to_start_led_test,1))
    hold on
    aligned_to_start_tone_test=newdb_tone(newdb_tone(:,6)>0.2 & newdb_tone(:,4)==0,9:end);
    subplot(2,2,nn+2),plot(mean(aligned_to_start_tone_test,1))
    title('test trials(aligned to start)')
    plot([newdb_led(1,5) newdb_led(1,5)],[0 1],'k')
    plot([newdb_tone(1,5) newdb_tone(1,5)],[0 1],'k')
    xlim([0 200])
    legend('led','tone','','Location','northwest','FontSize',5)
    ylabel('mean CR amplitude')
    text(70,-0.1,'tone puff')
    text(150,-0.1,'led puff')
    xlabel('Time(ms)')
    ylim([-0.2 1.2])

    xticks(0:20:200)
    xticklabels({'0','100','200','300','400','500','600','700','800','900','1000'})
    legend('boxoff')
    aligned_to_puff_led_test=aligned_to_start_led_test(:,newdb_led(:,5)-70:newdb_led(:,5)+20);
    aligned_to_puff_tone_test=aligned_to_start_tone_test(:,newdb_tone(:,5)-70:newdb_tone(:,5)+20);
    subplot(2,2,nn+3),plot(mean(aligned_to_puff_led_test,1))
    hold on
    subplot(2,2,nn+3),plot(mean(aligned_to_puff_tone_test,1))
    title('test trials(aligned to puff)')
    plot([70 70],[0 1],'k')
    xlim([0 100])
    legend('led','tone','','Location','northwest','FontSize',5)
    legend('boxoff')
    ylabel('mean CR amplitude')
    xlabel('Time(ms)')
    ylim([-0.2 1.2])
    xticks(0:10:100)
    xticklabels({ '-350' , '-300' , '-250' ,'-200' , '-150' , '-100' ,  '-50'  ,   'puff'   , '50'  , '100','150'})


    cd('C:\Users\u239632\Desktop\figs')
    mouse1=strcat('SS00',num2str(ii),'- Tone-',num2str((newdb_tone(1,5)*5)-200),' -LED-',num2str((newdb_led(1,5)*5)-200));
    sgtitle(mouse1, 'FontSize',10)
    saveas(gcf,mouse1,'png')
    [size(aligned_to_puff_tone_test,1) size(aligned_to_puff_led_test,1)]
%%%%%%%%% add number of trials information%%%%%%%%%%
end




% ml=mean(CRtrials{3,11},1);
%     ml_reps=(CRtrials{3,11});
%     int_light=((isi(1,2)-25+200)/5)-70:((isi(1,2)-25+200)/5)+20;
%     int_tone=((isi(2,2)-25+200)/5)-70:((isi(2,2)-25+200)/5)+20;
% 
%     ml_reps1=ml_reps(:,int_light);
%     try
%         subplot(2,2,ii+1),shadedErrorBar([1:size(ml_reps1,2)],mean(ml_reps1),(std(ml_reps1)),'lineProps','g')
%     end