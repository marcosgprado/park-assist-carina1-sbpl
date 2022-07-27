%
%
%
%generates motion primitives and saves them into file
%
%
%
%

%defines

    resolution = 0.05; % resolucao
    numberofangles = 16; % número de angulos
    numberofprimsperangle = 7; % numero de primitivas por angulo
    max = 0.5236;
%multipliers (mcostmult*cost)
    L =1.7;
     forwardcostmult = 1;
     backwardcostmult = 2;
     forwardandturncostmult = 3;
     %sidestepcostmult = 2;
     %turninplacecostmult = 20;
     %forwarddiagcostmult = 1; 

   

%$$$$$$$$$$$$$$$$$$$$$$$$$$    0 degreees   $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

    basemprimendpts0_c = zeros(numberofprimsperangle, 5); %(x,y,theta,curvature,costmult)
%0 theta change
    basemprimendpts0_c(1,:)  =  [  10   0   0   forwardcostmult  0];
    basemprimendpts0_c(2,:)  =  [  40   0   0   forwardcostmult  0];
    basemprimendpts0_c(3,:)  =  [ -10   0   0   backwardcostmult 0];    
%1/16 theta change
    basemprimendpts0_c(4,:)  =  [ 28  5    1   forwardandturncostmult  max];
    basemprimendpts0_c(5,:)  =  [ 28 -5   -1   forwardandturncostmult -max ];
%turn in placeturninplacecostmult
    basemprimendpts0_c(6,:)  =  [ 24  3  1   forwardandturncostmult   max/2];
    basemprimendpts0_c(7,:)  =  [ 24 -3  -1   forwardandturncostmult  -max/2];
%sideways maintaining the same heading
   % basemprimendpts0_c(8,:)  =  [  12 -2  -1   forwardandturncostmult  -max];
    %basemprimendpts0_c(9,:)  =  [  12 -2  -1   forwardandturncostmult  -max];
%1/16 theta change going backward
    %basemprimendpts0_c(6,:)  =  [-24  -4   1   backwardcostmult];
    %basemprimendpts0_c(7,:)  =  [-24   4  -1   backwardcostmult];
%forward diagonal
    %basemprimendpts0_c(12,:) =  [  8   1   0   forwarddiagcostmult];
    %basemprimendpts0_c(13,:) =  [  8  -1   0   forwarddiagcostmult];
    
    
%  %$$$$$$$$$$$$$$$$$$$$$$$$$    26.6 degreees   $$$$$$$$$$$$$$$$$$$$$$$$$$$$
% 
%     basemprimendpts26p6_c = zeros(numberofprimsperangle, 5);
%     %angles are positive counterclockwise
%     %0 theta change
%     basemprimendpts26p6_c(1,:)  =  [  2   1   0   forwardcostmult 0];
%     basemprimendpts26p6_c(2,:)  =  [  6   3   0   forwardcostmult 0];
%     basemprimendpts26p6_c(3,:)  =  [ -2   -1   0   backwardcostmult 0];    
% %1/16 theta change
%     basemprimendpts26p6_c(4,:)  =  [ 23   14   1   forwardandturncostmult  max];
%     basemprimendpts26p6_c(5,:)  =  [ 26   8   -1   forwardandturncostmult -max];
% %turn in place
%     basemprimendpts26p6_c(6,:)  =  [  20   16   2   forwardandturncostmult max/2];
%     basemprimendpts26p6_c(7,:)  =  [  26   4  -2   forwardandturncostmult  -max/2];
% %sideways maintaining the same heading
%     %basemprimendpts26p6_c(8,:)  =  [  0   1   0   sidestepcostmult];
%     %basemprimendpts26p6_c(9,:)  =  [  0  -1   0   sidestepcostmult];
% %1/16 theta change going backward
%     %basemprimendpts26p6_c(6,:)  =  [-24  -4   1   backwardcostmult];
%     %basemprimendpts26p6_c(7,:)  =  [-24   4  -1   backwardcostmult];
% %forward diagonal
%     %basemprimendpts26p6_c(12,:) =  [  8   1   0   forwarddiagcostmult];
%     %basemprimendpts26p6_c(13,:) =  [  8  -1   0   forwarddiagcostmult];    
%     
%     
% %$$$$$$$$$$$$$$$$$$$$$$$$$$$    45 degreees   $$$$$$$$$$$$$$$$$$$$$$$$$$$$$
%     basemprimendpts45_c = zeros(numberofprimsperangle, 5); % (x,y,theta,curvature,costmult) 
% %0 theta change
%     basemprimendpts45_c(1,:)  =  [  1   1   0   forwardcostmult 0 ];
%     basemprimendpts45_c(2,:)  =  [  6   6   0   forwardcostmult 0];
%     basemprimendpts45_c(3,:)  =  [ -1  -1   0   backwardcostmult 0];    
% %1/16 theta change
%     basemprimendpts45_c(4,:)  =  [ 28   18   -2  forwardandturncostmult -max];
%     basemprimendpts45_c(5,:)  =  [ 18  28    2   forwardandturncostmult max];
% %turn in place
%     basemprimendpts45_c(6,:)  =  [  16   18   1   forwardandturncostmult max/2];
%     basemprimendpts45_c(7,:)  =  [  18   16  -1   forwardandturncostmult -max/2];
% %sideways maintaining the same heading
%     %basemprimendpts0_c(8,:)  =  [  0   1   0   sidestepcostmult];
%     %basemprimendpts0_c(9,:)  =  [  0  -1   0   sidestepcostmult];
% %1/16 theta change going backward
%     %basemprimendpts0_c(6,:)  =  [-24  -4   1   backwardcostmult];
%     %basemprimendpts0_c(7,:)  =  [-24   4  -1   backwardcostmult];
% %forward diagonal
%     %basemprimendpts0_c(12,:) =  [  8   1   0   forwarddiagcostmult];
%     %basemprimendpts0_c(13,:) =  [  8  -1   0   forwarddiagcostmult];
% 
%     
%     %$$$$$$$$$$$$$$$$$$$$$$$$$    67.5 degreees   $$$$$$$$$$$$$$$$$$$$$$$$$$$$
% 
%     basemprimendpts67p5_c = zeros(numberofprimsperangle, 5);
%     %angles are positive counterclockwise
%     %0 theta change
%     basemprimendpts67p5_c(1,:)  =  [  1   2   0   forwardcostmult 0];
%     basemprimendpts67p5_c(2,:)  =  [  3   6   0   forwardcostmult 0];
%     basemprimendpts67p5_c(3,:)  =  [ -1   -2   0   backwardcostmult 0];    
% %1/16 theta change
%     basemprimendpts67p5_c(4,:)  =  [ 14   23   -1   forwardandturncostmult  -max];
%     basemprimendpts67p5_c(5,:)  =  [ 8   26    1   forwardandturncostmult max];
% %turn in place
%     basemprimendpts67p5_c(6,:)  =  [  16   20  -2   forwardandturncostmult -max/2];
%     basemprimendpts67p5_c(7,:)  =  [  4   26   2   forwardandturncostmult  max/2];
% %sideways maintaining the same heading
%     %basemprimendpts26p6_c(8,:)  =  [  0   1   0   sidestepcostmult];
%     %basemprimendpts26p6_c(9,:)  =  [  0  -1   0   sidestepcostmult];
% %1/16 theta change going backward
%     %basemprimendpts26p6_c(6,:)  =  [-24  -4   1   backwardcostmult];
%     %basemprimendpts26p6_c(7,:)  =  [-24   4  -1   backwardcostmult];
% %forward diagonal
%     %basemprimendpts26p6_c(12,:) =  [  8   1   0   forwarddiagcostmult];
%     %basemprimendpts26p6_c(13,:) =  [  8  -1   0   forwarddiagcostmult];    
%     
%    
% %$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      
    
fout = fopen('teste.mprim', 'w');
%write the header
fprintf(fout, 'resolution_m: %f\n', resolution);
fprintf(fout, 'numberofangles: %d\n', numberofangles);
fprintf(fout, 'totalnumberofprimitives: %d\n', numberofprimsperangle*numberofangles);



%iterate over angles
for angleind = 1:numberofangles  % 16 angulos
    % interacoes com os ângulos 
    
    figure(1);
    hold off;

    text(0, 0, int2str(angleind));
    
    %iterate over primitives    
    for primind = 1:numberofprimsperangle
        fprintf(fout, 'primID: %d\n', primind-1);
        fprintf(fout, 'startangle_c: %d\n', angleind-1);

        
        %current angle
        currentangle = (angleind-1)*2*pi/numberofangles;
        currentangle_36000int = round((angleind-1)*36000/numberofangles);
        angle=currentangle;
        
%         %compute which template to use
%         if (rem(currentangle_36000int, 9000) == 0) % resto da divisao inteira
             basemprimendpts_c = basemprimendpts0_c(primind,:);    
%             angle = currentangle;
%             %fprintf(1, '90\n');
%         elseif (rem(currentangle_36000int, 4500) == 0)
%             basemprimendpts_c = basemprimendpts45_c(primind,:);
%             angle = currentangle - 45*pi/180;
%            % fprintf(1, '45\n');
%         elseif (rem(currentangle_36000int-6750, 9000) == 0)
%             basemprimendpts_c    =  basemprimendpts67p5_c(primind, :);
%             %basemprimendpts_c(1) =  basemprimendpts26p6_c(primind, 2); %reverse x and y
%             %basemprimendpts_c(2) =  basemprimendpts26p6_c(primind, 1);
%             %basemprimendpts_c(3) = -basemprimendpts26p6_c(primind, 3); %reverse the angle as well
%             angle = currentangle - 67.5*pi/180;
%            % fprintf(1, '67p5\n');                    
%         elseif (rem(currentangle_36000int-2250, 9000) == 0)
%             basemprimendpts_c = basemprimendpts26p6_c(primind,:);
%             angle = currentangle - 22.5*pi/180;
%            % fprintf(1, '22p5\n');
%         
%         else
%             fprintf(1, 'ERROR: invalid angular resolution. angle = %d\n', currentangle_36000int);
%             return;
%         end;
         
        %now figure out what action will be        
        baseendpose_c = basemprimendpts_c(1:3);
        steer = basemprimendpts_c(5);
        additionalactioncostmult = basemprimendpts_c(4);        
        endx_c = round(baseendpose_c(1)*cos(angle) - baseendpose_c(2)*sin(angle));        
        endy_c = round(baseendpose_c(1)*sin(angle) + baseendpose_c(2)*cos(angle));
        endtheta_c = rem(angleind - 1 + baseendpose_c(3), numberofangles);
        endpose_c = [endx_c endy_c endtheta_c];
        
        fprintf(1, 'rotation angle=%f\n', angle*180/pi);
        if baseendpose_c(2) == 0 && baseendpose_c(3) == 0   
        end;
        
        %generate intermediate poses
        numofsamples = 50;
        intermcells_m = zeros(numofsamples,3);
        
        startpt = [ 0  0  currentangle 0];
        endpt   = [endpose_c(1)*resolution endpose_c(2)*resolution ...
                  rem(angleind - 1 + baseendpose_c(3), numberofangles)*2*pi/numberofangles steer];
              
        intermcells_m = zeros(numofsamples,3);
        
        if ( baseendpose_c(3) == 0) % move forward            
        
            for iind = 1:numofsamples
               
                    intermcells_m(iind,:) = [ startpt(1) + (endpt(1) - startpt(1))*(iind-1)/(numofsamples-1) ...
                                              startpt(2) + (endpt(2) - startpt(2))*(iind-1)/(numofsamples-1) ...
                                              rem(startpt(3) + (endpt(3) - startpt(3))*(iind-1)/(numofsamples-1), 2*pi)];
            end;            
        else  % carlike-based move forward or backward
                 R = [cos(startpt(3)) sin(endpt(3)) - sin(startpt(3));
                     sin(startpt(3)) -(cos(endpt(3)) - cos(startpt(3)))];
                S = pinv(R)*[endpt(1) - startpt(1)  ; endpt(2)- startpt(2) ];
                l = S(1);
                tvoverrv = S(2);
                rv = (baseendpose_c(3)*2*pi/numberofangles);
                tv = tvoverrv*rv;
                         
                if ((l < 0 & tv > 0) | (l > 0 & tv < 0))
                    fprintf(1, 'WARNING: l = %d < 0 -> bad action start/end points\n', l);
                   l = 0;
                end;
               
                for iind = 1:numofsamples     
                     dsteer = steer;
                    dt = (iind-1)/(numofsamples-1);
                           
                    
                        intermcells_m(iind,1) =  startpt(1) + dt*tv*cos(startpt(3) + dt*(tv/L)*tan(steer));
                        intermcells_m(iind,2) =  startpt(2) + dt*tv*sin(startpt(3) + dt*(tv/L)*tan(steer));
                        intermcells_m(iind,3) =  startpt(3) + dt*(tv/L)*tan(steer);
                  
                end; 
                %correct
                errorxy = [endpt(1) - intermcells_m(numofsamples,1) ... 
                           endpt(2) - intermcells_m(numofsamples,2) ...
                           endpt(3) - intermcells_m(numofsamples,3)];
               fprintf(1, 'l=%f errx=%f erry=%f\n errteta=%f\n', l, errorxy(1), errorxy(2) , errorxy(3));
                interpfactor = [0:1/(numofsamples-1):1];
                intermcells_m(:,1) = intermcells_m(:,1); %+ errorxy(1)*interpfactor';
                intermcells_m(:,2) = intermcells_m(:,2); %+ errorxy(2)*interpfactor';
                intermcells_m(:,3) = intermcells_m(:,3); %+ errorxy(3)*interpfactor';
            end;                                        
        
    
        %write out
        fprintf(fout, 'endpose_c: %d %d %d\n', endpose_c(1), endpose_c(2), endpose_c(3));
        fprintf(fout, 'additionalactioncostmult: %d\n', additionalactioncostmult);
        fprintf(fout, 'intermediateposes: %d\n', size(intermcells_m,1));
        for interind = 1:size(intermcells_m, 1)
           fprintf(fout, '%.4f %.4f %.4f\n', intermcells_m(interind,1), intermcells_m(interind,2), intermcells_m(interind,3));
        end;
         %[-1.275, -0.61], [-1.275, 0.61], [1.275, 0.61], [1.7, 0.0], [1.275, -0.61]]
        % Draw car
        %  xa = [ -1.275 -1.275 1.275  1.7  1.275 -1.275];
        %  ya = [ -0.61  0.61 0.61   0.0 -0.61 -0.61];
        %  xb = xa.*( cos(currentangle) - sin(currentangle))
        %  yb = ya.*(sin(currentangle) + cos(currentangle))
         % plot(xa,ya);
        hold on;
        plot(intermcells_m(:,1), intermcells_m(:,2));
       % axis([-3 3 -3 3]);
        text(intermcells_m(numofsamples,1), intermcells_m(numofsamples,2), int2str(endpose_c(3)));
        hold on;
        
    end;
    grid;
    pause;
end;
        
fclose('all');
