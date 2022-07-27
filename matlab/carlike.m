
function[] = carlike(outfilename)

%
%generates motion primitives and saves them into file
%
%

%defines
UNICYCLE_MPRIM_16DEGS = 1;

if UNICYCLE_MPRIM_16DEGS == 1
    resolution = 0.025;
    numberofangles = 16; %preferably a power of 2, definitely multiple of 8
    numberofprimsperangle = 9; 

    %multipliers (multiplier is used as costmult*cost)
    forwardcostmult = 1;
    backwardcostmult = 2;
    forwardandturncostmult = 3; 
    %note, what is shown x,y,theta *changes* (that is, dx,dy,dtheta and not absolute numbers)

    %--------------------0 degreees-------------------------------------
    basemprimendpts0_c = zeros(numberofprimsperangle, 4); 
    % Forward
    basemprimendpts0_c(1,:)  = [ 1  0  0  forwardcostmult];
    basemprimendpts0_c(2,:)  = [ 5  0  0  forwardcostmult];
    % Backward
    basemprimendpts0_c(3,:)  = [-1  0  0  backwardcostmult];    
    %1/16 theta change
    basemprimendpts0_c(4,:)  = [5   2  2  forwardandturncostmult];
    % basemprimendpts0_c(5,:)  = [5  -2 -2  forwardandturncostmult];
    basemprimendpts0_c(5,:)  = [4   3  1  forwardandturncostmult];
    basemprimendpts0_c(6,:)  = [4  -3 -1  forwardandturncostmult];
    %1/16 theta change going backward
    basemprimendpts0_c(7,:)  = [-4 -3  1  backwardcostmult];
    basemprimendpts0_c(8,:)  = [-4  3 -1  backwardcostmult];
    % basemprimendpts0_c(10,:) = [-5  2 -2  backwardcostmult];
    basemprimendpts0_c(9,:) = [-5 -2  2  backwardcostmult];
    
    %-------------------45 degrees-------------------------------
    basemprimendpts45_c = zeros(numberofprimsperangle, 4); 
    % Forward 
    basemprimendpts45_c(1,:) = [1 1 0 forwardcostmult];
    basemprimendpts45_c(2,:) = [4 4 0 forwardcostmult];
    %Backward
    basemprimendpts45_c(3,:) = [-1 -1 0 backwardcostmult];    
    %1/16 theta change
    basemprimendpts45_c(4,:) = [2 5 2 forwardandturncostmult];
    %  basemprimendpts45_c(5,:) = [5 2 -2 forwardandturncostmult];    
    basemprimendpts45_c(5,:) = [1 5 1 forwardandturncostmult];
    basemprimendpts45_c(6,:) = [5 1 -1 forwardandturncostmult];
    %1/16 theta change going back
    basemprimendpts45_c(7,:) = [-1 -5 1 backwardcostmult];
    basemprimendpts45_c(8,:) = [-5 -1 -1 backwardcostmult];    
    basemprimendpts45_c(9,:) = [-2 -5 2 backwardcostmult];
   % basemprimendpts45_c(11,:) = [-5 -2 -2 backwardcostmult];    
    
    %-------------------22.5 degrees----------------------------------
   %22.5 degrees
    basemprimendpts22p5_c = zeros(numberofprimsperangle, 4); 
    %0 theta change     
    basemprimendpts22p5_c(1,:) = [2 1 0 forwardcostmult];
    basemprimendpts22p5_c(2,:) = [6 3 0 forwardcostmult];    
    basemprimendpts22p5_c(3,:) = [-2 -1 0 backwardcostmult];     
    %1/16 theta change
    basemprimendpts22p5_c(4,:) = [5 4 2 forwardandturncostmult];
   %  basemprimendpts22p5_c(5,:) = [6 1 -2 forwardandturncostmult];    
    basemprimendpts22p5_c(5,:) = [6 -1 -1 forwardandturncostmult];
    basemprimendpts22p5_c(6,:) = [4 4 1 forwardandturncostmult]; 
    %1/16 theta change going back
    basemprimendpts22p5_c(7,:) = [-5 -4 2 backwardcostmult];
    %  basemprimendpts22p5_c(9,:) = [-7 -1 -2 backwardcostmult];    
    basemprimendpts22p5_c(8,:) = [-6 1 -1 backwardcostmult];
    basemprimendpts22p5_c(9,:) = [-4 -4 1 backwardcostmult];

    
else
    fprintf(1, 'ERROR: undefined mprims type\n');
    return;    
end;
    
 %------------------------------------------------------------------------  
fout = fopen(outfilename, 'w');


%write the header
fprintf(fout, 'resolution_m: %f\n', resolution);
fprintf(fout, 'numberofangles: %d\n', numberofangles);
fprintf(fout, 'totalnumberofprimitives: %d\n', numberofprimsperangle*numberofangles);

%iterate over angles
for angleind = 1:numberofangles
    
    figure(1);
    hold off;

    text(0, 0, int2str(angleind));
    
    %iterate over primitives    
    for primind = 1:numberofprimsperangle
        fprintf(fout, 'primID: %d\n', primind-1);
        fprintf(fout, 'startangle_c: %d\n', angleind-1);

        %current angle
        currentangle = (angleind-1)*2*pi/numberofangles; % Angulo atual
        currentangle_36000int = round((angleind-1)*36000/numberofangles);
        
        %compute which template to use
        if (rem(currentangle_36000int, 9000) == 0)
            basemprimendpts_c = basemprimendpts0_c(primind,:);    
            angle = currentangle;
            fprintf(1, '90\n');
        elseif (rem(currentangle_36000int, 4500) == 0)
            basemprimendpts_c = basemprimendpts45_c(primind,:);
            angle = currentangle - 45*pi/180;
            fprintf(1, '45\n');
       
        elseif (rem(currentangle_36000int-6750, 9000) == 0)
            basemprimendpts_c = basemprimendpts22p5_c(primind,:);
            basemprimendpts_c(1) = basemprimendpts22p5_c(primind, 2); %reverse x and y
            basemprimendpts_c(2) = basemprimendpts22p5_c(primind, 1);
            basemprimendpts_c(3) = -basemprimendpts22p5_c(primind, 3); %reverse the angle as well
            fprintf(1, '%d %d %d onto %d %d %d\n', basemprimendpts22p5_c(1), basemprimendpts22p5_c(2), basemprimendpts22p5_c(3), ...
            basemprimendpts_c(1), basemprimendpts_c(2), basemprimendpts_c(3));
            angle = currentangle - 67.5*pi/180;
            fprintf(1, '67p5\n');            
        
        
        elseif (rem(currentangle_36000int-2250, 9000) == 0)
            basemprimendpts_c = basemprimendpts22p5_c(primind,:);
            angle = currentangle - 22.5*pi/180;
            fprintf(1, '22p5\n');
        
        else
            fprintf(1, 'ERROR: invalid angular resolution. angle = %d\n', currentangle_36000int);
            return;
        end;
        
        %now figure out what action will be        
        baseendpose_c = basemprimendpts_c(1:3);
        additionalactioncostmult = basemprimendpts_c(4);        
        endx_c = round(baseendpose_c(1)*cos(angle) - baseendpose_c(2)*sin(angle));        
        endy_c = round(baseendpose_c(1)*sin(angle) + baseendpose_c(2)*cos(angle));
        endtheta_c = rem(angleind - 1 + baseendpose_c(3), numberofangles);
        endpose_c = [endx_c endy_c endtheta_c];
        
        fprintf(1, 'rotation angle=%f\n', angle*180/pi);
        
        if baseendpose_c(2) == 0 & baseendpose_c(3) == 0
            %fprintf(1, 'endpose=%d %d %d\n', endpose_c(1), endpose_c(2), endpose_c(3));
        end;
        
        %generate intermediate poses (remember they are w.r.t 0,0 (and not
        %centers of the cells)
        numofsamples = 10;
        intermcells_m = zeros(numofsamples,3);
        if UNICYCLE_MPRIM_16DEGS == 1
            startpt = [0 0 currentangle];
            endpt = [endpose_c(1)*resolution endpose_c(2)*resolution ...
                rem(angleind - 1 + baseendpose_c(3), numberofangles)*2*pi/numberofangles];
            intermcells_m = zeros(numofsamples,3);
            if ( baseendpose_c(3) == 0) % move forward            
                for iind = 1:numofsamples
                    intermcells_m(iind,:) = [startpt(1) + (endpt(1) - startpt(1))*(iind-1)/(numofsamples-1) ...
                                            startpt(2) + (endpt(2) - startpt(2))*(iind-1)/(numofsamples-1) ...
                                            rem(startpt(3) + (endpt(3) - startpt(3))*(iind-1)/(numofsamples-1), 2*pi)];
                end;            
            else %unicycle-based move forward or backward
                R = [cos(startpt(3)) sin(endpt(3)) - sin(startpt(3));
                    sin(startpt(3)) -(cos(endpt(3)) - cos(startpt(3)))];
                S = pinv(R)*[endpt(1) - startpt(1); endpt(2) - startpt(2)];
                l = S(1); 
                tvoverrv = S(2);
%                 rv = (baseendpose_c(3)*2*pi/numberofangles + l/tvoverrv);
%                 tv = tvoverrv*rv;
%                          
                
                %compute rv
                rv = baseendpose_c(3)*2*pi/numberofangles;
                %compute tv
                tvx = (endpt(1) - startpt(1))*rv/(sin(endpt(3)) - sin(startpt(3)))
                tvy = -(endpt(2) - startpt(2))*rv/(cos(endpt(3)) - cos(startpt(3)))
                tv = (tvx + tvy)/2.0; 
                
                if ((l < 0 & tv > 0) | (l > 0 & tv < 0))
                    fprintf(1, 'WARNING: l = %d < 0 -> bad action start/end points\n', l);
                    l = 0;
                end;
                
                %generate samples
                for iind = 1:numofsamples                                        
                    dt = (iind-1)/(numofsamples-1);
                                        
                    %dtheta = rv*dt + startpt(3);
                    %intermcells_m(iind,:) = [startpt(1) + tv/rv*(sin(dtheta) - sin(startpt(3))) ...
                    %                        startpt(2) - tv/rv*(cos(dtheta) - cos(startpt(3))) ...
                    %                        dtheta];
                    
                    if(abs(dt*tv) < abs(l))
                        intermcells_m(iind,:) = [startpt(1) + dt*tv*cos(startpt(3)) ...
                                                 startpt(2) + dt*tv*sin(startpt(3)) ...
                                                 startpt(3)];
                    else
                        dtheta = rv*(dt - l/tv) + startpt(3);
                        intermcells_m(iind,:) = [startpt(1) + l*cos(startpt(3)) + tvoverrv*(sin(dtheta) - sin(startpt(3))) ...
                                                 startpt(2) + l*sin(startpt(3)) - tvoverrv*(cos(dtheta) - cos(startpt(3))) ...
                                                 dtheta];
                    end;
                end; 
                %correct
                errorxy = [endpt(1) - intermcells_m(numofsamples,1) ... 
                           endpt(2) - intermcells_m(numofsamples,2)];
                fprintf(1, 'l=%f errx=%f erry=%f\n', l, errorxy(1), errorxy(2));
                interpfactor = [0:1/(numofsamples-1):1];
                intermcells_m(:,1) = intermcells_m(:,1) + errorxy(1)*interpfactor';
                intermcells_m(:,2) = intermcells_m(:,2) + errorxy(2)*interpfactor';
            end;                                        
        end;
    
        %write out
        fprintf(fout, 'endpose_c: %d %d %d\n', endpose_c(1), endpose_c(2), endpose_c(3));
        fprintf(fout, 'additionalactioncostmult: %d\n', additionalactioncostmult);
        fprintf(fout, 'intermediateposes: %d\n', size(intermcells_m,1));
        for interind = 1:size(intermcells_m, 1)
            fprintf(fout, '%.4f %.4f %.4f\n', intermcells_m(interind,1), intermcells_m(interind,2), intermcells_m(interind,3));
        end;
        %hold on
        plot(intermcells_m(:,1), intermcells_m(:,2)); 
        axis([-1 1 -1 1]); 
        text(intermcells_m(numofsamples,1), intermcells_m(numofsamples,2), int2str(endpose_c(3)));
        hold on;
        
    end;
    grid;
    pause;
end;
        
fclose('all');
