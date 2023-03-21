clear
arduinoObj = serialport("COM4",9600);
configureTerminator(arduinoObj,"CR/LF");
flush(arduinoObj);
arduinoObj.UserData = struct("Data",[],"Count",1);

readMicData(arduinoObj)

function readMicData(src,~)

data = fscanf(src);

src.UserData.Data(end+1) = str2double(data);

src.UserData.Count = src.UserData.Count + 1;

% If 1001 data points have been collected from the Arduino, switch off the
% callbacks and plot the data.
if src.UserData.Count > 1001
    fopen(src);
    plot(src.UserData.Data(1:end));
end
end

% function callbackSerial(ser,~)
% global time;
% val = fscanf(ser);
% numval = str2double(val);
% time(16) = numval;
% time(1)=[];
% disp(time);
% plot(time);
% end









% clear all
% clc
% delete(instrfindall); % it is a good practice that we call this
% 
% % here we define the main communication parameters
% arduino=serialport('COM4',9600);    
% 
% % Comments: We create a serial communication object on port COM4
% % in your case, the Ardunio microcontroller might not be on COM4, to
% % double check, go to the Arduino editor, and on click on "Tools". Under the "Tools" menu, there
% % is a "Port" menu, and there the number of the communication port should
% % be displayed
% 
% % Define some other parameter, check the MATLAB help for more details 
% InputBufferSize = 8;
% Timeout = 0.1;
% set(arduino , 'InputBufferSize', InputBufferSize);
% set(arduino , 'Timeout', Timeout);
% configureTerminator(arduino,  "CR");
% % Now, we are ready to go:
% 
% fopen(arduino); % initiate arduino communication
% pause(0.5)
% 
% fprintf(arduino,'234>') %send the control sequence, '0'- direction, '599'- number of steps, '>'- end marker
% 
% 
% % Let us see did Arduino microcontroller receive the sequence (only the number of steps)
% y=fscanf(arduino,'%f')
% %sss=fgets(arduino)
% % Close the communication port
% fclose(arduino);