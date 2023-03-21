function varargout = makePlots_light_and_tone(trials,varargin)
close all
generate_second_eye = isfield(trials, 'eyelidpos_2');


us = mode(trials.c_usnum);
cs = mode(trials.c_csnum);
if isfield(trials, 'c_usnum_eye_2')
    us_eye_2 = mode(trials.c_usnum_eye_2);
end


generated_plots = [1,1,1,1];

idxDeAll = find(trials.c_usdur>=0); %%Paired light Trials
idxDePaired_light = find(trials.c_usdur>0 & trials.c_csnum == 7); %%Paired light Trials
idxDeCS_light = find(trials.c_usdur==0 & trials.c_csnum == 7); %%CS Only light Trials
idxDePaired_tone = find(trials.c_usdur>0 & trials.c_csnum == 5); %%Paired tone Trials
idxDeCS_tone = find(trials.c_usdur==0 & trials.c_csnum == 5); %%CS Only tone Trials



%% Eyelid traces
    hf1=figure;
    hf1.WindowState = 'maximized';
    sgtitle('Eyelid Traces')
    
    hax=subplot(2,4,1);
    set(hax,'ColorOrder',jet(length(idxDePaired_light)),'NextPlot','ReplaceChildren');
    plot(trials.tm(1,:),trials.eyelidpos_1(idxDePaired_light,:))
    hold on 
    plot(trials.tm(1,:),mean(trials.eyelidpos_1(idxDePaired_light,:)),'k','LineWidth',2)
    hold on
    axis([trials.tm(1,1) trials.tm(1,end) -0.1 1.1])
    plot([trials.c_isi trials.c_isi],[-0.1 1.1],':k')
    title('Paired light')
    xlabel('Time from Trial Onset (s)')
    ylabel('Eyelid Position (FEC)')
    set(gca,'TickDir','out')
    set(gca,'box','off')

%     hax=subplot(2,4,2);
%     set(hax,'ColorOrder',jet(length(idxDeCS_light)),'NextPlot','ReplaceChildren');
% 
%     
%     plot(trials.tm(1,:),trials.eyelidpos_1(idxDeCS_light,:))
%     hold on 
%     plot(trials.tm(1,:),mean(trials.eyelidpos_1(idxDeCS_light,:)),'k','LineWidth',2)
%     hold on
%     axis([trials.tm(1,1) trials.tm(1,end) -0.1 1.1])
%     plot([trials.c_isi trials.c_isi],[-0.1 1.1],':k')
%     title('Test light (first eye)')
%     xlabel('Time from Trial Onset (s)')
%     ylabel('Eyelid Position (FEC)')
%     set(gca,'TickDir','out')
%     set(gca,'box','off')
    
    hax=subplot(2,4,3);
    set(hax,'ColorOrder',jet(length(idxDePaired_tone)),'NextPlot','ReplaceChildren');
    plot(trials.tm(1,:),trials.eyelidpos_1(idxDePaired_tone,:))
    hold on 
    plot(trials.tm(1,:),mean(trials.eyelidpos_1(idxDePaired_tone,:)),'k','LineWidth',2)
    hold on
    axis([trials.tm(1,1) trials.tm(1,end) -0.1 1.1])
    plot([trials.c_isi trials.c_isi],[-0.1 1.1],':k')
    title('Paired tone')
    xlabel('Time from Trial Onset (s)')
    ylabel('Eyelid Position (FEC)')
    set(gca,'TickDir','out')
    set(gca,'box','off')
    
%     hax=subplot(2,4,4);
%     set(hax,'ColorOrder',jet(length(idxDeCS_tone)),'NextPlot','ReplaceChildren');
%     plot(trials.tm(1,:),trials.eyelidpos_1(idxDeCS_tone,:))
%     hold on 
%     plot(trials.tm(1,:),mean(trials.eyelidpos_1(idxDeCS_tone,:)),'k','LineWidth',2)
%     hold on
%     axis([trials.tm(1,1) trials.tm(1,end) -0.1 1.1])
%     plot([trials.c_isi trials.c_isi],[-0.1 1.1],':k')
%     title('Test tone (first eye)')
%     xlabel('Time from Trial Onset (s)')
%     ylabel('Eyelid Position (FEC)')
%     set(gca,'TickDir','out')
%     set(gca,'box','off')
    


%% CR amplitudes
hf2=figure;
hf2.WindowState = 'maximized';
sgtitle('CR Amplitudes')
pre = 1:tm2frm(0.1);
%win = tm2frm(0.2+trials.c_isi/1e3):tm2frm(0.2+trials.c_isi/1e3+0.015);
win=[];
for i=1:length(trials.c_isi)
    win(i,:) = tm2frm(0.2+trials.c_isi(i)/1e3)-20:tm2frm(0.2+trials.c_isi(i)/1e3+0.015);
end

CRamp_1 = NaN(1,length(idxDeAll));
for i=1:length(idxDeAll)
    CRamp_1(i) = (max(trials.eyelidpos_1(idxDeAll(i),win(i,:))) - mean(trials.eyelidpos_1(idxDeAll(i),pre),2))/(1-mean(trials.eyelidpos_1(idxDeAll(i),pre),2));
end
CRampclean(CRamp_1<0.2)=0;
CRampclean(CRamp_1>=0.2)=1;
CRampclean=CRampclean';


CRpercent_1_paired_light=100*sum(CRampclean(idxDePaired_light))/length(CRamp_1(idxDePaired_light));
CRtrials_1_paired_light = trials.eyelidpos_1(find(CRampclean(idxDePaired_light)==1), :);
CRpercent_1_test_light=100*sum(CRampclean(idxDeCS_light))/length(CRamp_1(idxDeCS_light));
CRtrials_1_test_light = trials.eyelidpos_1(find(CRampclean(idxDeCS_light)==1), :);
CRpercent_1_paired_tone=100*sum(CRampclean(idxDePaired_tone))/length(CRamp_1(idxDePaired_tone));
CRtrials_1_paired_tone = trials.eyelidpos_1(find(CRampclean(idxDePaired_tone)==1), :);
CRpercent_1_test_tone=100*sum(CRampclean(idxDeCS_tone))/length(CRamp_1(idxDeCS_tone));
CRtrials_1_test_tone = trials.eyelidpos_1(find(CRampclean(idxDeCS_tone)==1), :);


subplot(2,4,1)
scatter(idxDePaired_light,CRamp_1(idxDePaired_light),15,'filled','b') %%plot CR amplitudes
hold on
plot([1 length(trials.trialnum)],[0.2 0.2],':k') %%plot dotted black line at minimum CR amplitude
axis([1 length(trials.trialnum) -0.1 1.1])
title(['Paired light (first eye), CR%=' num2str(CRpercent_1_paired_light)])
xlabel('Trials')
ylabel('CR amplitude')
set(gca,'TickDir','out')
set(gca,'box','off')

subplot(2,4,2)
scatter(idxDeCS_light,CRamp_1(idxDeCS_light),15,'filled','b') %%plot CR amplitudes
hold on
plot([1 length(trials.trialnum)],[0.2 0.2],':k') %%plot dotted black line at minimum CR amplitude
axis([1 length(trials.trialnum) -0.1 1.1])
title(['Test light (first eye), CR%=' num2str(CRpercent_1_test_light)])
xlabel('Trials')
ylabel('CR amplitude')
set(gca,'TickDir','out')
set(gca,'box','off')

subplot(2,4,3)
scatter(idxDePaired_tone,CRamp_1(idxDePaired_tone),15,'filled','b') %%plot CR amplitudes
hold on
plot([1 length(trials.trialnum)],[0.2 0.2],':k') %%plot dotted black line at minimum CR amplitude
axis([1 length(trials.trialnum) -0.1 1.1])
title(['Paired tone (first eye), CR%=' num2str(CRpercent_1_paired_tone)])
xlabel('Trials')
ylabel('CR amplitude')
set(gca,'TickDir','out')
set(gca,'box','off')

subplot(2,4,4)
scatter(idxDeCS_tone,CRamp_1(idxDeCS_tone),15,'filled','b') %%plot CR amplitudes
hold on
plot([1 length(trials.trialnum)],[0.2 0.2],':k') %%plot dotted black line at minimum CR amplitude
axis([1 length(trials.trialnum) -0.1 1.1])
title(['Test tone (first eye), CR%=' num2str(CRpercent_1_test_tone)])
xlabel('Trials')
ylabel('CR amplitude')
set(gca,'TickDir','out')
set(gca,'box','off')

if generate_second_eye
   
    pre_eye_2 = 1:tm2frm(0.1);
    %win_eye_2 = tm2frm(0.2+trials.c_isi_eye_2/1e3):tm2frm(0.2+trials.c_isi_eye_2/1e3+0.015);
    win_eye_2 = tm2frm(0.2+trials.c_isi_eye_2/1e3):tm2frm(0.2+trials.c_isi_eye_2/1e3+0.015);
    
   
    
    CRamp_2 = NaN(1,length(idxDeAll));
    for i=1:length(idxDeAll)
        CRamp_2(i) = (max(trials.eyelidpos_2(idxDeAll(i),win_eye_2)) - mean(trials.eyelidpos_2(idxDeAll(i),pre_eye_2),2))/(1-mean(trials.eyelidpos_2(idxDeAll(i),pre_eye_2),2));
    end
    CRampclean(CRamp_2<0.2)=0;
    CRampclean(CRamp_2>=0.2)=1;
    CRampclean=CRampclean';


    CRpercent_2_paired_light=100*sum(CRampclean(idxDePaired_light))/length(CRamp_2(idxDePaired_light));
    CRtrials_2_paired_light = trials.eyelidpos_2(find(CRampclean(idxDePaired_light)==1), :);
    CRpercent_2_test_light=100*sum(CRampclean(idxDeCS_light))/length(CRamp_2(idxDeCS_light));
    CRtrials_2_test_light = trials.eyelidpos_2(find(CRampclean(idxDeCS_light)==1), :);
    CRpercent_2_paired_tone=100*sum(CRampclean(idxDePaired_tone))/length(CRamp_2(idxDePaired_tone));
    CRtrials_2_paired_tone = trials.eyelidpos_2(find(CRampclean(idxDePaired_tone)==1), :);
    CRpercent_2_test_tone=100*sum(CRampclean(idxDeCS_tone))/length(CRamp_2(idxDeCS_tone));
    CRtrials_2_test_tone = trials.eyelidpos_2(find(CRampclean(idxDeCS_tone)==1), :);
    

    subplot(2,4,5)
    scatter(idxDePaired_light,CRamp_2(idxDePaired_light),15,'filled','b') %%plot CR amplitudes
    hold on
    plot([1 length(trials.trialnum)],[0.2 0.2],':k') %%plot dotted black line at minimum CR amplitude
    axis([1 length(trials.trialnum) -0.1 1.1])
    title(['Paired light (second eye), CR%=' num2str(CRpercent_2_paired_light)])
    xlabel('Trials')
    ylabel('CR amplitude')
    set(gca,'TickDir','out')
    set(gca,'box','off')

    subplot(2,4,6)
    scatter(idxDeCS_light,CRamp_2(idxDeCS_light),15,'filled','b') %%plot CR amplitudes
    hold on
    plot([1 length(trials.trialnum)],[0.2 0.2],':k') %%plot dotted black line at minimum CR amplitude
    axis([1 length(trials.trialnum) -0.1 1.1])
    title(['Test light (second eye), CR%=' num2str(CRpercent_2_test_light)])
    xlabel('Trials')
    ylabel('CR amplitude')
    set(gca,'TickDir','out')
    set(gca,'box','off')

    subplot(2,4,7)
    scatter(idxDePaired_tone,CRamp_2(idxDePaired_tone),15,'filled','b') %%plot CR amplitudes
    hold on
    plot([1 length(trials.trialnum)],[0.2 0.2],':k') %%plot dotted black line at minimum CR amplitude
    axis([1 length(trials.trialnum) -0.1 1.1])
    title(['Paired tone (second eye), CR%=' num2str(CRpercent_2_paired_tone)])
    xlabel('Trials')
    ylabel('CR amplitude')
    set(gca,'TickDir','out')
    set(gca,'box','off')

    subplot(2,4,8)
    scatter(idxDeCS_tone,CRamp_2(idxDeCS_tone),15,'filled','b') %%plot CR amplitudes
    hold on
    plot([1 length(trials.trialnum)],[0.2 0.2],':k') %%plot dotted black line at minimum CR amplitude
    axis([1 length(trials.trialnum) -0.1 1.1])
    title(['Test tone (second eye), CR%=' num2str(CRpercent_2_test_tone)])
    xlabel('Trials')
    ylabel('CR amplitude')
    set(gca,'TickDir','out')
    set(gca,'box','off')
end



%% ITIs
hf3=figure;
scatter(1:length(trials.ITIs),trials.ITIs,15,'filled','r');
hold on
axis([0 length(trials.ITIs)+1 0 max(trials.ITIs)+1]);
title('ITIs')
xlabel('ITI number')
ylabel('Duration (seconds)')
set(gca,'TickDir','out')
set(gca,'box','off')






%% Mean Velocity and Position Graph All Trials

hf4=figure;
hf4.WindowState = 'maximized';
sgtitle('Position vs. Velocity')

VPx=trials.tm(1,:);

meanPos_paired_light=mean(trials.eyelidpos_1(idxDePaired_light,:));
Vel_paired_light=zeros(length(meanPos_paired_light));
for i=1:length(meanPos_paired_light)-1
    Vel_paired_light(i+1)=(meanPos_paired_light(i+1)-meanPos_paired_light(i))/(VPx(i+1)-VPx(i));
end
subplot(2,4,1)
[PV, h1, h2] = plotyy(VPx,meanPos_paired_light,VPx,Vel_paired_light);
title('Paired light (first eye)')
xlabel('Time')
set(PV(1),'YLim',[-0.1 1.1])
set(PV(2),'YLim',[-15 50])
set(PV(1),'YTick',[-0.1:0.2:1.1])
set(PV(2),'YTick',[-15:5:50])
ylabel(PV(1),'Position') % left y-axis
ylabel(PV(2),'Velocity') % right y-axis
set(gca,'TickDir','out')
set(gca,'box','off')


meanPos_test_light=mean(trials.eyelidpos_1(idxDeCS_light,:));
Vel_test_light=zeros(length(meanPos_test_light));
for i=1:length(meanPos_test_light)-1
    Vel_test_light(i+1)=(meanPos_test_light(i+1)-meanPos_test_light(i))/(VPx(i+1)-VPx(i));
end
subplot(2,4,2)
[PV, h1, h2] = plotyy(VPx,meanPos_test_light,VPx,Vel_test_light);
title('Test light (first eye)')
xlabel('Time')
set(PV(1),'YLim',[-0.1 1.1])
set(PV(2),'YLim',[-15 50])
set(PV(1),'YTick',[-0.1:0.2:1.1])
set(PV(2),'YTick',[-15:5:50])
ylabel(PV(1),'Position') % left y-axis
ylabel(PV(2),'Velocity') % right y-axis
set(gca,'TickDir','out')
set(gca,'box','off')



meanPos_paired_tone=mean(trials.eyelidpos_1(idxDePaired_tone,:));
Vel_paired_tone=zeros(length(meanPos_paired_tone));
for i=1:length(meanPos_paired_tone)-1
    Vel_paired_tone(i+1)=(meanPos_paired_tone(i+1)-meanPos_paired_tone(i))/(VPx(i+1)-VPx(i));
end
subplot(2,4,3)
[PV, h1, h2] = plotyy(VPx,meanPos_paired_tone,VPx,Vel_paired_tone);
title('Paired tone (first eye)')
xlabel('Time')
set(PV(1),'YLim',[-0.1 1.1])
set(PV(2),'YLim',[-15 50])
set(PV(1),'YTick',[-0.1:0.2:1.1])
set(PV(2),'YTick',[-15:5:50])
ylabel(PV(1),'Position') % left y-axis
ylabel(PV(2),'Velocity') % right y-axis
set(gca,'TickDir','out')
set(gca,'box','off')


meanPos_test_tone=mean(trials.eyelidpos_1(idxDeCS_tone,:));
Vel_test_tone=zeros(length(meanPos_test_tone));
for i=1:length(meanPos_test_tone)-1
    Vel_test_tone(i+1)=(meanPos_test_tone(i+1)-meanPos_test_tone(i))/(VPx(i+1)-VPx(i));
end
subplot(2,4,4)
[PV, h1, h2] = plotyy(VPx,meanPos_test_tone,VPx,Vel_test_tone);
title('Test tone (first eye)')
xlabel('Time')
set(PV(1),'YLim',[-0.1 1.1])
set(PV(2),'YLim',[-15 50])
set(PV(1),'YTick',[-0.1:0.2:1.1])
set(PV(2),'YTick',[-15:5:50])
ylabel(PV(1),'Position') % left y-axis
ylabel(PV(2),'Velocity') % right y-axis
set(gca,'TickDir','out')
set(gca,'box','off')


if generate_second_eye
    VPx=trials.tm(1,:);

    meanPos_paired_light=mean(trials.eyelidpos_2(idxDePaired_light,:));
    Vel_paired_light=zeros(length(meanPos_paired_light));
    for i=1:length(meanPos_paired_light)-1
        Vel_paired_light(i+1)=(meanPos_paired_light(i+1)-meanPos_paired_light(i))/(VPx(i+1)-VPx(i));
    end
    subplot(2,4,5)
    [PV, h1, h2] = plotyy(VPx,meanPos_paired_light,VPx,Vel_paired_light);
    title('Paired light (second eye)')
    xlabel('Time')
    set(PV(1),'YLim',[-0.1 1.1])
    set(PV(2),'YLim',[-15 50])
    set(PV(1),'YTick',[-0.1:0.2:1.1])
    set(PV(2),'YTick',[-15:5:50])
    ylabel(PV(1),'Position') % left y-axis
    ylabel(PV(2),'Velocity') % right y-axis
    set(gca,'TickDir','out')
    set(gca,'box','off')


    meanPos_test_light=mean(trials.eyelidpos_2(idxDeCS_light,:));
    Vel_test_light=zeros(length(meanPos_test_light));
    for i=1:length(meanPos_test_light)-1
        Vel_test_light(i+1)=(meanPos_test_light(i+1)-meanPos_test_light(i))/(VPx(i+1)-VPx(i));
    end
    subplot(2,4,6)
    [PV, h1, h2] = plotyy(VPx,meanPos_test_light,VPx,Vel_test_light);
    title('Test light (second eye)')
    xlabel('Time')
    set(PV(1),'YLim',[-0.1 1.1])
    set(PV(2),'YLim',[-15 50])
    set(PV(1),'YTick',[-0.1:0.2:1.1])
    set(PV(2),'YTick',[-15:5:50])
    ylabel(PV(1),'Position') % left y-axis
    ylabel(PV(2),'Velocity') % right y-axis
    set(gca,'TickDir','out')
    set(gca,'box','off')



    meanPos_paired_tone=mean(trials.eyelidpos_2(idxDePaired_tone,:));
    Vel_paired_tone=zeros(length(meanPos_paired_tone));
    for i=1:length(meanPos_paired_tone)-1
        Vel_paired_tone(i+1)=(meanPos_paired_tone(i+1)-meanPos_paired_tone(i))/(VPx(i+1)-VPx(i));
    end
    subplot(2,4,7)
    [PV, h1, h2] = plotyy(VPx,meanPos_paired_tone,VPx,Vel_paired_tone);
    title('Paired tone (second eye)')
    xlabel('Time')
    set(PV(1),'YLim',[-0.1 1.1])
    set(PV(2),'YLim',[-15 50])
    set(PV(1),'YTick',[-0.1:0.2:1.1])
    set(PV(2),'YTick',[-15:5:50])
    ylabel(PV(1),'Position') % left y-axis
    ylabel(PV(2),'Velocity') % right y-axis
    set(gca,'TickDir','out')
    set(gca,'box','off')


    meanPos_test_tone=mean(trials.eyelidpos_2(idxDeCS_tone,:));
    Vel_test_tone=zeros(length(meanPos_test_tone));
    for i=1:length(meanPos_test_tone)-1
        Vel_test_tone(i+1)=(meanPos_test_tone(i+1)-meanPos_test_tone(i))/(VPx(i+1)-VPx(i));
    end
    subplot(2,4,8)
    [PV, h1, h2] = plotyy(VPx,meanPos_test_tone,VPx,Vel_test_tone);
    title('Test tone (second eye)')
    xlabel('Time')
    set(PV(1),'YLim',[-0.1 1.1])
    set(PV(2),'YLim',[-15 50])
    set(PV(1),'YTick',[-0.1:0.2:1.1])
    set(PV(2),'YTick',[-15:5:50])
    ylabel(PV(1),'Position') % left y-axis
    ylabel(PV(2),'Velocity') % right y-axis
    set(gca,'TickDir','out')
    set(gca,'box','off')
end





%% Output

if nargout > 0
    varargout{1}=hf1;
    varargout{2}=hf2;
    varargout{3}=hf3;
    varargout{4}=hf4;
    varargout{5}=generated_plots;
end