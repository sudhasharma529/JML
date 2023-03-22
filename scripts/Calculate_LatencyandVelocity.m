function [slps,crlatency_sigmafit,crlatency_greg,select_traces]=Calculate_LatencyandVelocity(data)

norm_data=data(:,51:170)-mean(data(:,40:50),2);
slps=[];crlatency_sigmafit=[];select_traces=[];crlatency_greg=[];
    for ll=1:size(norm_data,1)
        [V,I]=max(norm_data(ll,:));
        data2=[];
        data2=norm_data(ll,1:I);
        if length(data2)>20
            [param,stat]=sigm_fit(1:length(data2),data2,[],[],[]);
            fit=goodnessOfFit(data2',stat.ypred,'MSE');
            if param(4)<0.5 && param(4)>0 && fit<0.0099
                slps(ll)=param(4);
                crlatency_sigmafit(ll)=knee_pt(stat.ypred);

                %%%%%%%%%%%%%%% latency method by greg%%%%%%%%%%%%
                if data(ll,5)==600
                    CRwindow = 0.585; % in seconds
                else
                    CRwindow = 0.185; % in seconds
                end
                ISI=frm2tm(data(ll,8)-40)*1000;
                onsets=calculateCRonsets_OddballPaper(data(ll,11:end),ISI,@tm2frm,@frm2tm,CRwindow);
                newonsets=[zeros(length(ISI),40) onsets];
                ab=find(newonsets==1);
                if ~isempty(ab)
                    crlatency_greg(ll)=ab(1);
                else
                    crlatency_greg(ll)=crlatency_sigmafit(ll);
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                select_traces(ll,:)=data(ll,11:end);

                %                 if ~isempty(ab)
                %                     plot(data(ll,11:end)-mean(data(ll,20:30)))
                %                     hold on
                %                     plot(ab(1),0,'*b')
                %                     new_ypred=[zeros(1,40) stat.ypred'];
                %                     plot(new_ypred,'r')
                %                     hold on
                %                     plot(crlatency_sigmafit(ll)+40,0,'*r')
                %                     pause
                %                     clf
                %                 end
            end
        end
    end