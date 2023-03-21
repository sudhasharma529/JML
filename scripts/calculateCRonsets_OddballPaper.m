function Onsets=calculateCRonsets_OddballPaper(Traces,ISIs,...
    Time2FrameFunction,Frame2TimeFunction,...
    WindowSec)

checkErrors=0;

Time2Frame=@(x) Time2FrameFunction(x);
Frame2Time=@(x) Frame2TimeFunction(x);

Velocity_Duration_Sec=0.015;
Velocity_Duration=Time2Frame(Velocity_Duration_Sec);

Window=Time2Frame(WindowSec);

if ~(size(Traces,1)==length(ISIs))
    error('Trace ISI mismatch')
end

Amplitude_Threshold=0.1; %minimum position difference (FEC) a false start must achieve to count
VelocityThreshold=0.5; %%velocity threshold (Full Closures per Second)

Duration_Threshold=Time2Frame(0.025); %how many frames of velocity+ frames are necessary to declare a start to a CR?

numTrials=length(ISIs); %number of trials
Onsets=zeros(numTrials,round((WindowSec+(2*Velocity_Duration_Sec))/0.005)); %matrix for distribution of onsets
for i=1:numTrials
%     if i==131
%        break
%     end
    %% Setup for Onset Detection
    currentISI=ISIs(i); %ISI for the current trial
    currentISI=currentISI+200; %add pretrial 200ms
    currentTrace=Traces(i,:); %eyelid trace for the current trial

    UStime=Time2Frame(currentISI/1e3); %Frame of the US
    OnsetWindow=(UStime-Window+1-Velocity_Duration):(UStime+Velocity_Duration); %Frame window to look for onsets

    WindowTrace=currentTrace(OnsetWindow); %Eyelid trace to look for onsets

    %% Onset Detection
    %Convert the eyelid trace to a velocity vector
    VelocityVector=convertToVelocity(WindowTrace);

    %Record a 1 or a 0 if a frame exceeds the velocity threshold
    Velocity_Boolean=VelocityFilter(VelocityVector,VelocityThreshold,...
        Velocity_Duration);

    %Record a 1 or a 0 if the duration of velocity passing frames exceeds
    %the duration threshold
    [VelOn_Boolean,VelOff_Boolean]=FindVelocityOnsets(Velocity_Boolean,Duration_Threshold);

    %Final filter to ensure the movement is large enough
    BeginningFrames=AmplitudeFilter(VelOn_Boolean,VelOff_Boolean,...
        Amplitude_Threshold,Velocity_Duration,WindowTrace);


    %% Final Output

    for j=1:length(BeginningFrames)
        RealTime=Frame2Time(BeginningFrames(j));
        ClosestFrame=round(RealTime/0.005);
        Onsets(i,ClosestFrame)=1;
    end


    %% Check errors
    if checkErrors==1
        if ~isempty(BeginningFrames)
            [~,ax]=setupFig();
            axis(ax,[1,length(WindowTrace),-0.1,1.1])
            plot(WindowTrace)
            lastStim=length(WindowTrace)-Velocity_Duration-Time2Frame(0.535);
            plot(ax,[lastStim,lastStim],[-0.1,1.1],'-g')
            for j=1:length(VelOn_Boolean)
                if Velocity_Boolean(j)==1
                    plot(ax,j+1,WindowTrace(j+1),'m*')
                end
                if VelOn_Boolean(j)==1
                    plot(ax,j,WindowTrace(j),'r+')
                elseif VelOff_Boolean(j)==1
                    plot(ax,j,WindowTrace(j),'b+')
                end
            end
            for j=1:length(BeginningFrames)
                plot(ax,[BeginningFrames(j)+1,BeginningFrames(j)+1],[-0.1 1.1],'-k')
            end
        end
    end
   
end


function VelocityVector=convertToVelocity(trace)
frameDuration=0.005;
VelocityVector=NaN(1,length(trace)-1);
for i=1:length(trace)-1
    VelocityVector(i)=( trace(i+1)-trace(i) ) / frameDuration;
end

function Velocity_Boolean=VelocityFilter(VelocityVector,VelocityThreshold,...
    Velocity_Duration)
maxSlope=100; %this velocity is not seen with natural movements, only with flash artefacts
totalFrames=length(VelocityVector);
Velocity_Boolean=zeros(1,totalFrames); %%matrix that records all frames that pass the criteria (default set to 0)
VelocityVector=fliplr(VelocityVector); %work through the trace backwards (works to push analysis all the way up to but not including the UR
for j=1:totalFrames-Velocity_Duration
    if (nanmean(VelocityVector(j:(j+Velocity_Duration-1))) >= VelocityThreshold)... %if the mean of the current plus the next (duration-1) velocity frames are greater than the threshold...
            && isempty(find(VelocityVector(j:(j+Velocity_Duration-1))>maxSlope)) %max slope gets rid of flash artefacts
        Velocity_Boolean(j)=1; %then record the frame as passing
    end
end
Velocity_Boolean=fliplr(Velocity_Boolean); %flip it back to forwards

function [VelOn_Boolean,VelOff_Boolean]=FindVelocityOnsets(Velocity_Boolean,...
    Duration_Threshold)

numFrames=length(Velocity_Boolean);
VelOn_Boolean=zeros(1,numFrames);
VelOff_Boolean=zeros(1,numFrames);
withinFS=0; %marker for noting that a FS is in progress

for j=1:numFrames-Duration_Threshold
    if withinFS==0 %if not already in an FS
        if nansum(Velocity_Boolean(j:(j+Duration_Threshold-1))) == Duration_Threshold%% if the current and next 9 frames pass the algorithm (sum will always be less than duration if any do not pass)
            VelOn_Boolean(j)=1;%%records the frame number for the beginning of the false start
            withinFS=1; %%indicate a FS has started
        end
    elseif withinFS==1 %if the current frame is already within an FS
        if (j+Duration_Threshold)>=numFrames || ...
                ismember(1,Velocity_Boolean(j:(j+Duration_Threshold-1))) == 0
            VelOff_Boolean(j)=1; %Record end of onset
            withinFS=0; %indicate end of FS
        end
    end
end


function BeginningFrames=AmplitudeFilter(VelOn_Boolean,VelOff_Boolean,...
    Amplitude_Threshold,Velocity_Duration,WindowTrace)
numFrames=length(VelOn_Boolean);
Begs=find(VelOn_Boolean==1);
Ends=find(VelOff_Boolean==1);
if (length(Begs)-1)==length(Ends)
    Ends=[Ends,length(WindowTrace)];
end
BeginningFrames=[];
count=0;
for i=1:length(Begs)
    Beg=Begs(i)-Velocity_Duration;
    if Beg<1
        Beg=1;
    end
    En=Ends(i)+Velocity_Duration;
    if En>numFrames
        En=numFrames;
    end
    Win=WindowTrace(Beg:En);
    Amplitude=max(Win)-min(Win);
    if Amplitude>=Amplitude_Threshold
        count=count+1;
        BeginningFrames(count)=Begs(i);
    end
end











