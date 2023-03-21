function trials=processTrialsWithEncoder(folder,varargin)
% TRIALS=processConditioningTrials(FOLDER,CALIB,{MAXFRAMES})
% Return trials structure containing eyelid data and trial parameters for all trials in a session
% Specify either filename of trial to use for calibration or "calib" structure containing pre-calculated scale and offset.
% Optionally, specify threshold for binary image and maximum number of video frames per trial to use for extracting eyelid trace
% 
% 
% if length(varargin) > 0
% 	thresh=varargin{1};
% end
% 
% % Error checking
% if isstruct(calib)
% 	if ~isfield(calib,'scale') || ~isfield(calib,'offset')
% 		error('You must specify a valid calibration structure or file from which the structure can be computed')
% 	end
% elseif exist(calib,'file')
% 	[data,metadata]=loadCompressed(calib);
% 	if ~exist('thresh')
% 		thresh=metadata.cam.thresh;
% 	end
% 	[y,t]=vid2eyetrace(data,metadata,thresh,5);
% 	calib=getcalib(y,40,50);
% else
% 	error('You must specify a valid calibration structure or file from which the structure can be computed')
% end

% By now we should have a valid calib structure to use for calibrating all files

if ~exist(folder,'dir')
	error('The directory you specified (%s) does not exist',folder);
end

% Get our directory listing, assuming the only AVI files containined in the directory are the trials
% Later we will sort out those that aren't type='conditioning' based on metadata
% fnames=getFullFileNames(folder,dir(fullfile(folder,'*.avi')));
fnames=getFullFileNames(folder,dir(fullfile(folder,'*.mp4')));

% Only keep the files that match the pattern MOUSEID_DATE_SXX or MOUSEID_DATE_TXX, skipping for instance trials from Camera 2
%matches = regexp(fnames,'[A-Z][A-Z]?\d\d\d_\d\d\d\d\d\d_[tS]\d\d[a-z]?_\d\d\d','start','once');
matches_eye_1 = regexp(fnames,'[A-Z][A-Z]?\d\d\d_\d\d\d\d\d\d_[tS]\d\d[a-z]?_\d\d\d[t.]','start','once');
matches_eye_2 = regexp(fnames,'[A-Z][A-Z]?\d\d\d_\d\d\d\d\d\d_[tS]\d\d[a-z]?_\d\d\d_eye_2','start','once');


fnames_eye_1 = fnames(cellfun(@(a) ~isempty(a), matches_eye_1));
fnames_eye_2 = fnames(cellfun(@(a) ~isempty(a), matches_eye_2));

% Preallocate variables so we can use parfor loop to process the files
eyelidpos_1=cell(length(fnames_eye_1),1);	% We have to use a cell array because trials may have different lengths
eyelidpos_2=cell(length(fnames_eye_2),1);	% We have to use a cell array because trials may have different lengths
tm=cell(length(fnames_eye_1),1);			% Same for time

c_isi=NaN(length(fnames_eye_1),1);
c_csintensity=NaN(length(fnames_eye_1),1);
c_csnum=NaN(length(fnames_eye_1),1);
c_csdur=NaN(length(fnames_eye_1),1);
c_usnum=NaN(length(fnames_eye_1),1);
c_usdur=NaN(length(fnames_eye_1),1);
c_csperiod=NaN(length(fnames_eye_1),1);
c_us_trigger=NaN(length(fnames_eye_1),1);

c_isi_eye_2=NaN(length(fnames_eye_1),1);
c_usnum_eye_2=NaN(length(fnames_eye_1),1);
c_usdur_eye_2=NaN(length(fnames_eye_1),1);

l_delay=NaN(length(fnames_eye_1),1);
l_dur=NaN(length(fnames_eye_1),1);
l_amp=NaN(length(fnames_eye_1),1);

mouse=[];

% session_of_day=NaN(length(fnames_eye_1),1);
session_of_day={};

timestamp=NaN((length(fnames_eye_1)-1),1);

trialnum=zeros(length(fnames_eye_1),1);
ttype=cell(length(fnames_eye_1),1);

numframes=zeros(length(fnames_eye_1),1);


parfor i=1:length(fnames_eye_1)
   
%for i=1:length(fnames_eye_1)    
    if ~exist(fnames_eye_1{i},'file') %%check to make sure the mp4 file is there
        disp(sprintf('Problem with file %s', fnames_eye_1{i}))
    else
        [p,basename,ext]=fileparts(fnames_eye_1{i});  
        name=fnames_eye_1{i};
        
        mta=sprintf('%s_meta.mat',name(1:end-4));
        if ~exist(mta,'file') %%check to make sure the metadata file is there
            disp(sprintf('Problem with file %s', mta))
        else
            
            try
                [data,metadata,encoder]=loadCompressedWithEncoder(fnames_eye_1{i});
            catch ME
                [data,metadata]=loadCompressedWithEncoder(fnames_eye_1{i});
            end
                
            calib = struct;
            calib.scale = metadata.cam.calib_scale;
            calib.offset = metadata.cam.calib_offset;
            thresh = metadata.cam.thresh;
            [eyelidpos_1{i},tm{i}]=vid2eyetrace(data,metadata,thresh,5,calib);
%             displace{i}= metadata.encoder.displacement;
%             encodtime{i}= metadata.encoder.time;
%             enccounts{i}= metadata.encoder.counts;
            
            %     session_of_day(i)=metadata.TDTblockname(end);
            if isfield(metadata.stim.c,'cs_addreps')
                c_isi(i)=metadata.stim.c.isi+metadata.stim.c.cs_addreps*metadata.stim.c.cs_period;
            else
                c_isi(i)=metadata.stim.c.isi;
            end
            if isfield(metadata.stim.c ,'isi_eye_2')            
                if isfield(metadata.stim.c,'cs_addreps')
                    c_isi_eye_2(i)=metadata.stim.c.isi_eye_2+metadata.stim.c.cs_addreps*metadata.stim.c.cs_period;
                else
                    c_isi_eye_2(i)=metadata.stim.c.isi_eye_2;
                end
            end
            
            
            session_of_day{i}=metadata.TDTblockname(end-2:end);
            c_csintensity(i)=metadata.stim.c.tonecs_intensity;
            c_csnum(i)=metadata.stim.c.csnum;
            c_csdur(i)=metadata.stim.c.csdur;
            if isfield(metadata.stim.c,'cs_period') %%if there is cs_period values, use them
                c_csperiod(i)=metadata.stim.c.cs_period;
            elseif isfield(metadata.stim.c,'csperiod') %%if there is cs_period values, use them
                c_csperiod(i)=metadata.stim.c.csperiod;
            elseif metadata.stim.c.isi>1200 %%if not, the 1200 isi pulls out the first omission 135ms period animals
                c_csperiod(i)=135;
            else
                c_csperiod(i)=metadata.stim.c.csdur; %%else use the csduration (delay trials)
            end
            if isfield(metadata.stim.c,'usnum')
                c_usnum(i)=metadata.stim.c.usnum;
            else
                c_usnum(i)=3;
            end
            
            if isfield(metadata.stim.c,'usnum_eye_2')
                c_usnum_eye_2(i)=metadata.stim.c.usnum_eye_2;
            else
                c_usnum_eye_2(i)=2;
            end
            
            mouse=metadata.mouse;
            
            %%FRANCISCO: variable that indicates if the US has been
            %%triggered or suppresed.
	     
            
            if isfield(metadata,'US_trigger')
               c_us_trigger(i)=metadata.US_trigger;
            elseif isfield(metadata, 'trial_control') && isfield(metadata.trial_control,'first_eye_US_trigger')
               c_us_trigger(i)=metadata.trial_control.first_eye_US_trigger;
            else
               c_us_trigger(i)=1;
            end
            
            try
                displace{i}= encoder.displacement;
                encodtime{i}= encoder.time;
                enccounts{i}= encoder.counts;
            catch ME
                displace{i}= metadata.encoder.displacement;
                encodtime{i}= metadata.encoder.time;
                enccounts{i}= metadata.encoder.counts;
            end
            c_usdur(i)=metadata.stim.c.usdur;
            if isfield(metadata.stim.c ,'usdur_eye_2')            
                c_usdur_eye_2(i)=metadata.stim.c.usdur_eye_2;
            end
            trialnum(i)=metadata.cam.trialnum;
            ttype{i}=metadata.stim.type;
            numframes(i)=length(eyelidpos_1{i});
            
            if strcmp(metadata.stim.type,'Conditioning');
                timestamp(i) = metadata.ts(1)+metadata.ts(2);
            end
            
            l_delay(i)=metadata.stim.l.delay;
            l_dur(i)=metadata.stim.l.dur;
            l_amp(i)=metadata.stim.l.amp;
            stim(i)=metadata.stim;
            camtime(i)=metadata.cam;
            fprintf('Processed file %s\n',basename)
            
        end
    end
end



parfor i=1:length(fnames_eye_2)
%for i=1:length(fnames_eye_2)    
    if ~exist(fnames_eye_2{i},'file') %%check to make sure the mp4 file is there
        disp(sprintf('Problem with file %s', fnames_eye_2{i}))
    else
        [p,basename,ext]=fileparts(fnames_eye_2{i});  
        name=fnames_eye_2{i};
        
        mta=sprintf('%s_meta.mat',name(1:end-10));
        if ~exist(mta,'file') %%check to make sure the metadata file is there
            disp(sprintf('Problem with file %s', mta))
        else
            
            try
                [data_eye_2,metadata,encoder]=loadCompressedWithEncoder_eye_2(fnames_eye_2{i});
            catch ME
                [data_eye_2,metadata]=loadCompressedWithEncoder_eye_2(fnames_eye_2{i});
            end
            
             
            calib = struct;
            calib.scale = metadata.cam_eye_2.calib_scale;
            calib.offset = metadata.cam_eye_2.calib_offset;
            thresh = metadata.cam_eye_2.thresh;
            [eyelidpos_2{i},tm{i}]=vid2eyetrace_eye_2(data_eye_2,metadata,thresh,5,calib);

        end
    end
end
            

disp('Done reading data')

% matlabpool close

if length(varargin) > 1
	MAXFRAMES=varargin{2};
else
	MAXFRAMES=max(numframes);
end

% Now that we know how long each trial is turn the cell arrays into matrices

traces_eye_1=NaN(length(fnames_eye_1),MAXFRAMES);
traces_eye_2=NaN(length(fnames_eye_2),MAXFRAMES);
times=NaN(length(fnames_eye_1),MAXFRAMES);%fnames_eye_1
displacement=NaN(length(fnames_eye_1),MAXFRAMES);
timesencoder=NaN(length(fnames_eye_1),MAXFRAMES);
countsencoder=NaN(length(fnames_eye_1),MAXFRAMES);

try
	for i=1:length(fnames_eye_1)
		trace=eyelidpos_1{i}; 
		t=tm{i}; 
        movement=displace{i};
        counterenc=enccounts{i};
        timeenc=encodtime{i};
		en=length(trace); 
        em=length(movement);
		if en > MAXFRAMES
			en=MAXFRAMES; 
		end 
		traces_eye_1(i,1:en)=trace(1:en); 
		times(i,1:en)=t(1:en);
        displacement(i,1:em)=movement(1:em);
        timesencoder(i,1:em)=timeenc(1:em);
        countsencoder(i,1:em)=counterenc(1:em);
    end
    
    for i=1:length(fnames_eye_2)
		trace=eyelidpos_2{i}; 
%		t=tm{i}; 
%        movement=displace{i};
%        counterenc=enccounts{i};
%        timeenc=encodtime{i};
		en=length(trace); 
%        em=length(movement);
		if en > MAXFRAMES
			en=MAXFRAMES; 
		end 
		traces_eye_2(i,1:en)=trace(1:en); 
%		times(i,1:en)=t(1:en);
%        displacement(i,1:em)=movement(1:em);
%        timesencoder(i,1:em)=timeenc(1:em);
%        countsencoder(i,1:em)=counterenc(1:em);
	end
catch
    disp(i)
end

% sess_cell = regexp(fnames_eye_1,'_[sS](\d\d)_','tokens','once');
% session_of_day = cellfun(@str2double, sess_cell);

ITIactual=NaN((length(timestamp)-1),1);
for i=1:(length(timestamp)-1)
    ITIactual(i)=timestamp(i+1)-timestamp(i);

end
trials.displacement=displacement;
trials.encodertimes=timesencoder;
trials.encodercounter=countsencoder;

trials.mouseID = mouse;

trials.ITIs = [17.5000; ITIactual]; %places the average ITI (17.5s) for first ITI to align trace #s with the correct ITIs
trials.meanITI = nanmean(ITIactual);
trials.medianITI = nanmedian(ITIactual);

trials.eyelidpos_1=traces_eye_1;
if ~isempty(fnames_eye_2) 
    trials.eyelidpos_2=traces_eye_2;
    trials.c_isi_eye_2=c_isi_eye_2;
    trials.c_usnum_eye_2=c_usnum_eye_2;
    trials.c_usdur_eye_2=c_usdur_eye_2;
end
trials.tm=times;
trials.fnames_eye_1=fnames_eye_1;
trials.fnames_eye_2=fnames_eye_2;

trials.c_isi=c_isi;
trials.c_csnum=c_csnum;
trials.c_csdur=c_csdur;
trials.c_csperiod=c_csperiod;
trials.c_usnum=c_usnum;
trials.c_usdur=c_usdur;
trials.c_csinten=c_csintensity;

trials.c_us_trigger=c_us_trigger;
               
trials.trialnum=trialnum;
trials.type=ttype;
trials.session_of_day=session_of_day';

trials.l_delay=l_delay;
trials.l_dur=l_dur;
trials.l_amp=l_amp;
trials.stim=stim;
trials.camtime=camtime;