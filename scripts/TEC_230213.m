close all
clear

list_of_mice =          [146        155        148         154              153];
Lists_of_days =         {[74:86]    [54:60],   [72:80],    [68:74 77 78],   [80:81]};
Lists_of_days_oot =     {[63:73],   [40:50],   [61:71],    [57:67],         [69:79]};

time = (1:200)*0.005 - 0.2 -0.235;

% Onset search parameters
frame_duration = 0.005;
add_time_after_us = 0;
Velocity_Duration=tm2frm(0.025); % in ms
CRwindow = 0.39; % in seconds

for m = [146 153] % list_of_mice

    clear percentCR;
    list_of_days = Lists_of_days{find(list_of_mice==m)};
    list_of_days_oot = Lists_of_days_oot{find(list_of_mice==m)};
    d = LoadData(m);
    cmap = cool(numel(list_of_days));
    cmap_oot = hot(numel(list_of_days_oot)+3);
    
    figure('Color', 'w', 'Units','normalized', 'Position',[0.3000    0.3185    0.2896    0.6219]);
    subplot(3,2,1)
        clear p;
        hold on
            line([-0.235 -0.235],[0 1.05], 'LineStyle', ':', 'Color', 'k')
            line([-0.2 -0.2],[0 1.05], 'LineStyle', ':', 'Color', 'k')
                rectangle('Position',[-0.235 1.05 0.035 0.1], 'FaceColor','g', 'EdgeColor','g')
                text(-0.235, 1.15, 'LED', 'VerticalAlignment','bottom' )
            line([0 0],[0 1.05], 'LineStyle', ':', 'Color', 'k')
                rectangle('Position',[0 1.05 0.025 0.1], 'FaceColor','w', 'EdgeColor','k')
                text(0, 1.15, 'puff', 'VerticalAlignment','bottom' )
            for i = 1:numel(list_of_days)
                p(i) = plot(time, mean(d.Days(list_of_days(i)).Sessions.TracesAligned,2), 'color', cmap(i,:), 'LineWidth', 2  );
            end
        hold off
        xlabel('time from US, s')
        ylabel('FEC')
        xlim([time(1) 0.2])
        ylim([-0.05 1.25])
        yticks([0:0.2:1])
        leg = legend(p, arrayfun(@num2str, list_of_days-list_of_days(1)+1, 'UniformOutput', 0), 'Location','west');
        leg.Title.String = 'training day';
    %     legend boxoff
    subplot(3,2,2)
        clear percentCR;
        for i = 1:numel(list_of_days)
            percentCR(i) = d.Days(list_of_days(i)).Sessions.percentCR;
        end
        plot(percentCR*100, 'ro-', 'LineWidth',3)
        xlabel('training day')
        ylabel('%CR')
        xlim([0.5 numel(list_of_days)+0.5])
        ylim([0 100])
        xticks(1:numel(list_of_days))
    sgtitle(sprintf('MM%03d TEC', m))     
    
    
    
    % Onsets
%     figure('Color', 'w', 'Units','normalized', 'Position',[0.5964    0.4755    0.3354    0.4644])
    subplot(3,2,3:4)
        clear p;
        isi = find(time>-0.235,1) *frame_duration*1000 + add_time_after_us*1000; % in ms. ISIs for TEC
        hold on
            line([-0.235 -0.235],[0 1.05], 'LineStyle', ':', 'Color', 'k')
            line([-0.2 -0.2],[0 1.05], 'LineStyle', ':', 'Color', 'k')
            text(-0.235+0.035/2, 0.06, 'LED', 'VerticalAlignment','bottom', 'HorizontalAlignment','center')
            for i = 1:numel(list_of_days)
                fec = d.Days(list_of_days(i)).Sessions.TracesAligned;
                ISI = repmat(isi, size(fec,2), 1);
                onsets=calculateCRonsets_OddballPaper(fec',ISI,@tm2frm,@frm2tm,CRwindow); % EyePos: dim1 trial, dim2 time; ISI: in ms
                SessionOnsets_all=mean(onsets);
                SessionOnsets_all=boxsmooth(SessionOnsets_all,Velocity_Duration,1);
    %             SessionOnsets_all = SessionOnsets_all/sum(SessionOnsets_all);
                time2 = -1*(numel(SessionOnsets_all):-1:1)*frame_duration;
                p(i) = plot(time2,SessionOnsets_all, 'color', cmap(i,:), 'LineWidth', 2  );
            end
        hold off
        leg = legend(p, arrayfun(@num2str, list_of_days-list_of_days(1)+1, 'UniformOutput', 0), 'Location','eastoutside');
        leg.Title.String = 'training day';
        xlabel('time from US, s')
        ylabel('P(onset)')
        xlim([-0.3 0])
        ylim([0 0.09])
        title('TEC')
    subplot(3,2,5:6)
        clear p;
        S = d.Days(list_of_days_oot(1)).Sessions; % get sample FEC traces to make time vector
        [time_oot, ~] = MakeTimeVector("traces", S.TracesAligned, 'cs_period', 0.3);
        isi = find(time_oot>-0.235,1) *frame_duration*1000 + add_time_after_us*1000; % in ms. ISIs for OOT
        hold on
            line([-0.235 -0.235],[0 1.05], 'LineStyle', ':', 'Color', 'k')
            line([-0.2 -0.2],[0 1.05], 'LineStyle', ':', 'Color', 'k')
            text(-0.235+0.035/2, 0.015, 'Omission', 'VerticalAlignment','bottom', 'HorizontalAlignment','center')
            for i = 1:numel(list_of_days_oot)
                fec = d.Days(list_of_days_oot(i)).Sessions.TracesAligned;
                ISI = repmat(isi, size(fec,2), 1);
                onsets=calculateCRonsets_OddballPaper(fec',ISI,@tm2frm,@frm2tm,CRwindow); % EyePos: dim1 trial, dim2 time; ISI: in ms
                SessionOnsets_all=mean(onsets);
                SessionOnsets_all=boxsmooth(SessionOnsets_all,Velocity_Duration,1);
    %             SessionOnsets_all = SessionOnsets_all/sum(SessionOnsets_all);
                time2 = -1*(numel(SessionOnsets_all):-1:1)*frame_duration;
                p(i) = plot(time2,SessionOnsets_all,  'LineWidth', 0.5);
                Onsets_oot(i,:) = SessionOnsets_all;
            end
            plot(time2, mean(Onsets_oot), 'color', 'red', 'LineWidth', 4);
    
    %         % Add LdOm ipsi and contra traces day 52
    %         s = d.Days(52).Sessions;
    %         condition = ones(size(s.CRamp));
    %         condition(s.usdur==0 & s.laser_power==0) = 2;
    %         condition(s.usdur==0 & s.laser_power==29) = 3;
    %         condition(s.usdur==0 & s.laser_power==30) = 4;
    %         condition = condition(s.singleLaserFlashTrial==0);
    % 
    %         fec = s.TracesAligned(:, condition==3); % LdOm ipsi
    %         ISI = repmat(isi, size(fec,2), 1);
    %         onsets=calculateCRonsets_OddballPaper(fec',ISI,@tm2frm,@frm2tm,CRwindow); % EyePos: dim1 trial, dim2 time; ISI: in ms
    %         SessionOnsets_all=mean(onsets);
    %         SessionOnsets_all_LdOm_ipsi=boxsmooth(SessionOnsets_all,Velocity_Duration,1) /2; % '2.25' is an arbitrary factor to make the traces compatible with controls
    %         p_ipsi = plot(time2, SessionOnsets_all_LdOm_ipsi, 'color', 'b', 'LineWidth', 4, 'LineStyle',':');
    % 
    %         fec = s.TracesAligned(:, condition==4); % LdOm contra
    %         ISI = repmat(isi, size(fec,2), 1);
    %         onsets=calculateCRonsets_OddballPaper(fec',ISI,@tm2frm,@frm2tm,CRwindow); % EyePos: dim1 trial, dim2 time; ISI: in ms
    %         SessionOnsets_all=mean(onsets);
    %         SessionOnsets_all_LdOm_ipsi=boxsmooth(SessionOnsets_all,Velocity_Duration,1) /2; % '2.25' is an arbitrary factor to make the traces compatible with controls
    %         p_contra = plot(time2, SessionOnsets_all_LdOm_ipsi, 'color', 'g', 'LineWidth', 4, 'LineStyle',':');
    
        hold off
        leg = legend(p , arrayfun(@num2str, list_of_days_oot, 'UniformOutput', 0), 'Location','eastoutside');
    %     leg = legend([p p_ipsi p_contra], [arrayfun(@num2str, list_of_days_oot, 'UniformOutput', 0), 'ipsi', 'contra'], 'Location','eastoutside');
        leg.Title.String = 'training day';
        xlabel('time from US, s')
        ylabel('P(onset)')
        xlim([-0.3 0])
        ylim([0 0.02])
    %     ylim([0 0.03])
        title('OOT')    
    sgtitle(sprintf('MM%03d TEC', m))   


end