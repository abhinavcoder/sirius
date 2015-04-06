%%
%%the function is used to calculate the servo motor angles from desired
%%position(x,y) for the dog gait. the origin for each leg is the joint
%%from the dynamixel digital servo with y pointing upwards and x pointing
%%towards from the body.
%%^      ^
%%|      |
%%o->  <-o

%%the variable load is used to denote the feasibility of the solution. If
%%the value of load is 1, then the solution doen't exist or cannot ne
%%implemented because of hardware limitations
%%

function [theta,load] = inversekinematics(x,y,phi)
load = 0;
l1 = 33;
l2 = 60;
l3 = 74;

theta = zeros(1,3);
x1 = x -l3*cosd(phi);
y1 = y - l3*sind(phi);

c = (x1^2 + y1^2 - l1^2 - l2^2)/(2*l1*l2);
if(c>1 || c<-1)
    load = 1;
    return;
end
s1 = sqrt(1-c^2);
s2 = -s1;
theta = zeros(1,3);

if(atan2d(s1,c)>-90 && atan2d(s1,c)<0)
    theta(2) = atan2d(s1,c);
elseif(atan2d(s2,c)>-90 && atan2d(s2,c)<0)
    theta(2) = atan2d(s2,c);
else
    theta(2) = 0;
    load = 1;
end

k1= l1+l2*cosd(theta(2));
k2 = l2*sind(theta(2));

theta(1) = atan2d(y1,x1)-atan2d(k2,k1);
temp = theta(1)+180;
if(temp<-60 || temp>240)
    load = 1;
end

theta(3) = phi-theta(1)-theta(2);
if(theta(3)<-90 || theta(3)>0)
    load = 1;
end

end