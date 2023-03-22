clear
close all

% alldays1={'221205','221206','221207','221208','221209','221212','221213','221214','221215',...
%     '221216','221220','221221','221222','221227','221228','221229','221230','230103','230104',...
%     '230109','230110','230111','230112','230113','230118','230120','230123','230124','230125',...
%     '230126','230127','230206','230207','230217','230220','230221','230223','230224','230227',...
%     '230228','230301','230302','230303','230306','230307','230308'};

% alldays1={'230303_Session1','230303_Session2','test030323'};
alldays1={'230322'};
% alldays1={'230303'};

for ai=1:8
    % figure('units','normalized','outerposition',[0.5 0.5 0.4 0.5])
    for date =1:length(alldays1)
        
        path=strcat('\\blinklab\Data0\users\Sudha\Data\Dec2022\SS00',num2str(ai),'\',alldays1{date},'\compressed\');
        %      path=strcat('\\blinklab\Data0\users\Xirui\Data\XC0',num2str(32),'\neuroblinks\',alldays1{date},'\compressed\');
        cd(path)
        %         path=strcat('\\blinklab\Data0\users\Sudha\testing\rig4\',alldays1{date},'\compressed\');
        %         cd(path)
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

        % figure
        %     imagesc(vals)
        % title('encoder time')
        temp=[];
        for kk=1:size(vals,1)
            temp(kk,:)=diff(vals(kk,:));
        end
        %     subplot(2,2,date)
        figure
        imagesc(temp)
        colorbar
        title(alldays1{date},'Interpreter','none')

        temp2=zeros(size(temp,1),5);
        for ii=1:size(temp,1)
            temp2(ii,1:length(find(temp(ii,:)>10)))=find(temp(ii,:)>10);
        end
        [B I]=sort(temp2(:,1));
        temp3=temp2(I,:);
        %     figure('units','normalized','outerposition',[0.5 0.5 0.4 0.5]),
        %     hist((temp3(:,2)-temp3(:,1))*5)
        %
        % vals2=zeros(length(files),200);
        % for ff=1:length(files)
        % load (files(ff).name)
        % vals2(ff,1:length(metadata.encoder.displacement(:,1)))=metadata.encoder.displacement(:,1);
        % end
        % figure
        % imagesc(vals2)
        % title('displacement')
        %
        vals3=zeros(length(files),200);
        for ff=1:length(files)
            load (files(ff).name)
            vals3(ff,1:length(metadata.eye.trace(1,:)))=metadata.eye.trace(1,:);
        end
        % figure%('units','normalized','outerposition',[0 0 1 1])
        % imagesc(vals3)
        % title('trace')
        %     figure,plot(vals3')


        % % v=VideoReader('Sudha_230118_S01_020.mp4');
        % % for ii=1:200
        % %     imagesc(read(v,ii))
        % %     title(ii)
        % %     pause
        % %     clf
        % % end
    end
end