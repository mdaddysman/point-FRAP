%gauss.m
function y=gauss(x,t)
y=x(1)*exp(-(t-x(2)).^2/(x(3))^2);