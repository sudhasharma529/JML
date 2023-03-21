function myboxplot(case1,case2)
figure
xval=[];

for kk=1:length(case1)
    xval=[xval;'1'];
end

for kk=1:length(case2)
    xval=[xval;'2'];
end
alltbp=[case1;case2];
boxplot(alltbp,xval)
hold on
s=swarmchart(ones(length(case1),1),case1,'.b');
s.XJitterWidth = 0.2;
s=swarmchart(2.*ones(length(case2),1),case2,'.r');
s.XJitterWidth = 0.2;
plot_pval(case1,case2)