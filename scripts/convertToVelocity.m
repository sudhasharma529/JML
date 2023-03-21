function VelocityVector=convertToVelocity(trace)
frameDuration=0.005;
VelocityVector=NaN(1,length(trace)-1);
for i=1:length(trace)-1
    VelocityVector(i)=( trace(i+1)-trace(i) ) / frameDuration;
end