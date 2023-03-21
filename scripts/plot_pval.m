function plot_pval(case1,case2)

[h,p]=ranksum(case1,case2);

if h<0.05 && h>0.01
    text(1.5,0.2,'*','FontSize',20)
elseif h< 0.01 && h>0.001
    text(1.5,0.2,'**','FontSize',20)
elseif h< 0.001
    text(1.5,0.2,'***','FontSize',20)
end