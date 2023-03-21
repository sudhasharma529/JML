function [db]=VoltoDB(x,y,volval)
x_interp=round(interp(x,50));
y_interp=round(interp(y,50));
cc=y_interp(x_interp==volval);
db=cc(1);
end