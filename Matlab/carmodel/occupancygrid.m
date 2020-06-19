image = imread('map.png');
grayimage = rgb2gray(image);
bwimage = im2bw(image,0.5);
bwimage = ~bwimage;

grid = binaryOccupancyMap(bwimage);
% map = binaryOccupancyMap(600,600,1);
% setOccupancy(map, [200 200], ones(40,1))
% setOccupancy(map, [200 200], ones(1,60))
% setOccupancy(map, [260 200], ones(40,1))
% setOccupancy(map, [200 240], ones(1,60))
% 200 200 260 230; 
% 200 240 240 200
% 
% 350 380 410 410; 
% 200 240 240 200
show(grid)
validator = validatorOccupancyMap;
validator.Map = grid;
planner = plannerHybridAStar(validator,'MinTurningRadius',60,'MotionPrimitiveLength',10);
startPose = [100 50 pi/2]; % [meters, meters, radians]
goalPose = [100 200 pi/2];
refpath = plan(planner,startPose,goalPose);
show(planner)

