clear
close all

alldays1={'230303'};

for ii=4%[4,8]
    for date =1:length(alldays1)
        path=strcat('\\blinklab\Data0\users\Sudha\Data\Dec2022\SS00',num2str(ii),'\',alldays1{date},'\compressed\');
        cd(path)

        files=dir('*meta.mat');
        tbdel=[];
        for tbd=1:length(files)
            if contains(files(tbd).name,'calib')
                tbdel=[tbdel tbd];
            end
        end
        files(tbdel)=[];

        vals=zeros(length(files),200);
        for ff=1:length(files)
            load (files(ff).name)
            vals(ff,1:length(metadata.encoder.time(:,1)))=metadata.encoder.time(:,1);
        end

        cd('C:\Users\u239632\Desktop\Encoder')
        load('vals')
        load('database')
        newdb=[];newdb_led=[];newdb_tone=[];
        newdb=database(database(:,1)==ii & database(:,2)==43,:);



        testtrials=[];
        traces=[];testtrials=find(newdb(:,4)==0);
        traces=newdb(:,11:end);traces(testtrials,:)=[];

        vals(testtrials,:)=[];
        inds=zeros(size(traces,1),1);
        temp=[];
        for kk=1:size(vals,1)
            temp(kk,:)=diff(vals(kk,:));
        end
        for jj=1:size(vals,1)
            aa=[];
            aa=find(temp(jj,:)~=5);
            inds2(jj,1)=aa(1);
            inds2(jj,2)=aa(2);
        end
        [B,I]=sort(inds2(:,1));
        newtraces2=traces(I,:);
        newvals2=temp(I,:);
        inds3=inds2(I,:);
        subplot(2,2,3),imagesc(newvals2)
        subplot(2,2,4),imagesc(newtraces2)
        hold on
        for ll=1:size(inds3,1)
            plot(B(ll),ll,'*r')
            plot(inds3(ll,2),ll,'*r')
hold on
        end



        % for kk=1:size(traces,1)
        %     aa=[];
        %     aa=find(traces(kk,:)>0.8& traces(kk,:)<0.9);
        %     if ~isempty(aa)
        %         inds(kk)=aa(1);
        %     end
        % end
        % [B,I]=sort(inds);
        % newtraces=traces(I,:);
        % newvals=vals(I,:);
        %
        % subplot(2,2,1),imagesc(newvals)
        % subplot(2,2,2),imagesc(newtraces)
        %
       
        % subplot(2,2,1)
        %
        % imagesc(temp)
        % colorbar

       


    end
end