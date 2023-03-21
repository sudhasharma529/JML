close all
load('Database_031523.mat')
nn=1;
for ii=[5,7,8]
    figure
    allonsets=[];db=[];
    clearvars -except database ii nn allonsets
    newdb=[];newdb_led=[];newdb_tone=[];
    newdb=database(database(:,1)==ii & database(:,2)>0,:);
     if ii==5
        newdb_led=newdb(newdb(:,3)==7 & newdb(:,5)==600,:);
    else
        newdb_led=newdb(newdb(:,3)==7,:);
    end
    newdb_tone=newdb(newdb(:,3)==5,:);
    cols=colormap(summer);


    mm=1;
    ledtrials=[];fec=[];ISI=[];onsets=[];newonsets=[];
    ledtrials=newdb_led;

    if ledtrials(1,5)==600
        CRwindow = 0.585; % in seconds
    else
        CRwindow = 0.185; % in seconds
    end
    ISI=frm2tm(ledtrials(:,8)-40)*1000;
    fec=ledtrials(:,11:end);
    onsets=calculateCRonsets_OddballPaper(fec,ISI,@tm2frm,@frm2tm,CRwindow);

    newonsets=[zeros(length(ISI),40) onsets];

    for ii=1:size(fec,1)
        
        ab=find(newonsets(ii,:)==1);
        if ~isempty(ab)
        plot(fec(ii,:)-mean(fec(ii,20:30)))
        hold on
        plot(ab(1),0,'*r')
        pause
        clf
        end
    end




    db=zeros(size(newonsets,1),1);

    for kk=1:length(ISI)
        ab=find(newonsets(kk,:)==1);
        if ~isempty(ab)
            db(kk)=(ab(1)-40)*5;
        end
    end
    if ii==8
        daysbef=29:33;
        daysaft=44:49;
    elseif ii==5
        daysbef=24:28;
        daysaft=44:49;
    elseif ii==7
        daysbef=26:30;
        daysaft=44:49;
    end

    bef=[];aft=[];
    bef=nonzeros(db(ledtrials(:,2)>=daysbef(1) & ledtrials(:,2)<=daysbef(end)));
    aft=nonzeros(db(ledtrials(:,2)>=daysaft(1) & ledtrials(:,2)<=daysaft(end)));

xval=[];

for kk=1:length(bef)

    xval=[xval;'1'];
end

for kk=1:length(aft)

    xval=[xval;'2'];
end

alltbp=[bef;aft]; 
boxplot(alltbp,xval)
hold on
s=swarmchart(ones(length(bef),1),bef,'.b');
s.XJitterWidth = 0.2;
s=swarmchart(2.*ones(length(aft),1),aft,'.r');
s.XJitterWidth = 0.2;
xticklabels({'Before','After'})
 [h,p]=ranksum(bef,aft);
    if h<0.05&h>0.01
        text(1.5,0.2,'*','FontSize',20)
    elseif h< 0.01 & h>0.001
        text(1.5,0.2,'**','FontSize',20)
    elseif h< 0.001
        text(1.5,0.2,'***','FontSize',20)
    end
    ylabel('CR onset(ms)')
    sgtitle(strcat('SS00',num2str(ii),'CR onset time distribution to','-LED(600msISI)'))
    mouse=strcat('SS00',num2str(ii),'CR onset time distribution to','-LED(600msISI)');
    cd('C:\Users\u239632\Documents\JML\results')
    saveas(gcf,mouse,'png')
end




close all
load('Database_031523.mat')
for ii=[5,7,8]
    figure('units','normalized','outerposition',[0.5 0.5 0.3 0.3])
    allonsets=[];db=[];
    clearvars -except database ii nn allonsets
    newdb=[];newdb_led=[];newdb_tone=[];
    newdb=database(database(:,1)==ii & database(:,2)>0,:);
    
    newdb_led=newdb(newdb(:,3)==7,:);
    
    newdb_tone=newdb(newdb(:,3)==5,:);

    mouse1=strcat('SS00',num2str(ii),'- LED-',num2str(newdb_led(1,5)),'-CR Onsets');
    days=unique(newdb_led(:,2));
    for pp=1:length(days)

        ledtrials=[];fec=[];ISI=[];onsets=[];newonsets=[];
        ledtrials=newdb_led(newdb_led(:,2)==days(pp), :);

        if ledtrials(1,5)==600
            CRwindow = 0.585; % in seconds
        else
            CRwindow = 0.185; % in seconds
        end

        ISI=frm2tm(ledtrials(:,8)-40)*1000;
        fec=ledtrials(:,11:end);
        onsets=calculateCRonsets_OddballPaper(fec,ISI,@tm2frm,@frm2tm,CRwindow);

        newonsets=[zeros(length(ISI),40) onsets];

        db=zeros(size(newonsets,1),1);

        for kk=1:length(ISI)
            ab=find(newonsets(kk,:)==1);
            if ~isempty(ab)
                db(kk)=(ab(1))*5;
            end
        end

        scatter(ones(1,length(db))*pp,db,'filled','SizeData',10,'Jitter','on','JitterAmount',0.1)
        hold on
        meds(pp)=median(nonzeros(db));

        hold on
    end
    hold on
    plot([0 50],[200 200],'k')
    plot([0 50],[800 800],'k')
    plot(meds,'k','LineWidth',2)
    text(1,190,'CS start')
    text(1,790,'US start')
    ylim([100, 900])
    ylabel('CR Onset Time(ms)')
    xlabel('Day of recording')
    sgtitle(mouse1, 'FontSize',10)
    cd('C:\Users\u239632\Documents\JML\results')
    saveas(gcf,mouse1,'png')


end



