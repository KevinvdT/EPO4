function [newxcoor,newycoor,newdir] = next_coordinate(xcoor, ycoor, dir,time_step,v,phi)
    
    T = [cos(dir),-sin(dir),v*cos(phi)*time_step;
         sin(dir), cos(dir),v*sin(phi)*time_step;
         0 0 1];
    newcoordinate = T*[xcoor;ycoor;1];
    newxcoor=newcoordinate(1);
    newycoor=newcoordinate(2);
    xd=newxcoor-xcoor;
    yd=newycoor-ycoor;
    r = 0.945;
    newdir = Tangent(newxcoor,newycoor,xd,yd,phi,r);
end

