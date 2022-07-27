
function[] = carlike11(outfilename)


    resolution = 0.025;
    numberofangles = 16; 
    numberofprimsperangle = 11; 
    forwardcostmult = 1;
    backwardcostmult = 2;
    forwardandturncostmult = 3;   

    %________________________0 degreees___________________________________
    basemprimendpts0_c = zeros(numberofprimsperangle, 4);
    
    basemprimendpts0_c( 1 ,:)  = [ 1  0  0  forwardcostmult];
    basemprimendpts0_c( 2 ,:)  = [ 8  0  0  forwardcostmult];
    basemprimendpts0_c( 3 ,:)  = [ 7  2  1  forwardandturncostmult];
    basemprimendpts0_c( 4 ,:)  = [ 7 -2 -1  forwardandturncostmult];
    basemprimendpts0_c( 5 ,:)  = [ 5  3  2  forwardandturncostmult];
    basemprimendpts0_c( 6 ,:)  = [ 5 -3 -2  forwardandturncostmult];
    basemprimendpts0_c( 7 ,:)  = [-1  0  0  backwardcostmult];  
    basemprimendpts0_c( 8 ,:)  = [-7 -2  1  backwardcostmult];
    basemprimendpts0_c( 9 ,:)  = [-7  2 -1  backwardcostmult];
    basemprimendpts0_c( 10,:)  = [-5 -3  2  backwardcostmult];
    basemprimendpts0_c( 11,:)  = [-5  3 -2  backwardcostmult];
    
    %____________________________45 degrees_______________________________
    basemprimendpts45_c = zeros(numberofprimsperangle, 4); 
    
    basemprimendpts45_c( 1 ,:) = [ 1  1  0  forwardcostmult];
    basemprimendpts45_c( 2 ,:) = [ 6  6  0  forwardcostmult];
    basemprimendpts45_c( 3 ,:) = [ 4  7  1  forwardandturncostmult];
    basemprimendpts45_c( 4 ,:) = [ 7  4 -1  forwardandturncostmult];    
    basemprimendpts45_c( 5 ,:) = [ 2  8  2  forwardandturncostmult];
    basemprimendpts45_c( 6 ,:) = [ 8  2 -2  forwardandturncostmult];
    basemprimendpts45_c( 7 ,:) = [-1 -1  0  backwardcostmult];    
    basemprimendpts45_c( 8 ,:) = [-4 -7  1  backwardcostmult];
    basemprimendpts45_c( 9 ,:) = [-7 -4 -1  backwardcostmult];    
    basemprimendpts45_c( 10,:) = [-2 -8  2  backwardcostmult];
    basemprimendpts45_c( 11,:) = [-8 -2 -2  backwardcostmult];
    
    %________________________22.5 degrees_________________________________
    basemprimendpts22p5_c = zeros(numberofprimsperangle, 4);
    
    basemprimendpts22p5_c( 1 ,:) = [ 2  1  0 forwardcostmult];
    basemprimendpts22p5_c( 2 ,:) = [ 6  3  0 forwardcostmult];    
    basemprimendpts22p5_c( 3 ,:) = [ 4  4  1 forwardandturncostmult];
    basemprimendpts22p5_c( 4 ,:) = [ 7  1 -1 forwardandturncostmult];    
    basemprimendpts22p5_c( 5 ,:) = [ 2  5  2 forwardandturncostmult];
    basemprimendpts22p5_c( 6 ,:) = [ 8 -1 -2 forwardandturncostmult];
    basemprimendpts22p5_c( 7 ,:) = [-2 -1  0 backwardcostmult];
    basemprimendpts22p5_c( 8 ,:) = [-4 -4  1 backwardcostmult];
    basemprimendpts22p5_c( 9 ,:) = [-7 -1 -1 backwardcostmult];
    basemprimendpts22p5_c( 10,:) = [-2 -5  2 backwardcostmult];
    basemprimendpts22p5_c( 11,:) = [-8  1 -2 backwardcostmult];    
    
    
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
        currentangle = (angleind-1)*2*pi/numberofangles;
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
        elseif (rem(currentangle_36000int-7875, 9000) == 0)
            basemprimendpts_c = basemprimendpts33p75_c(primind,:);
            
            basemprimendpts_c(1) = basemprimendpts33p75_c(primind, 2); %reverse x and y
            basemprimendpts_c(2) = basemprimendpts33p75_c(primind, 1);
            basemprimendpts_c(3) = -basemprimendpts33p75_c(primind, 3); %reverse the angle as well
            angle = currentangle - 78.75*pi/180;
            fprintf(1, '78p75\n');
            
        elseif (rem(currentangle_36000int-6750, 9000) == 0)
            basemprimendpts_c = basemprimendpts22p5_c(primind,:);
            basemprimendpts_c(1) = basemprimendpts22p5_c(primind, 2); %reverse x and y
            basemprimendpts_c(2) = basemprimendpts22p5_c(primind, 1);
            basemprimendpts_c(3) = -basemprimendpts22p5_c(primind, 3); %reverse the angle as well
            angle = currentangle - 67.5*pi/180;
            fprintf(1, '67p5\n');            
        elseif (rem(currentangle_36000int-5625, 9000) == 0)
            basemprimendpts_c = basemprimendpts11p25_c(primind,:);
            basemprimendpts_c(1) = basemprimendpts11p25_c(primind, 2); %reverse x and y
            basemprimendpts_c(2) = basemprimendpts11p25_c(primind, 1);
            basemprimendpts_c(3) = -basemprimendpts11p25_c(primind, 3); %reverse the angle as well
            angle = currentangle - 56.25*pi/180;
            fprintf(1, '56p25\n');
        elseif (rem(currentangle_36000int-3375, 9000) == 0)
            basemprimendpts_c = basemprimendpts33p75_c(primind,:);
            angle = currentangle - 33.75*pi/180;
            fprintf(1, '33p75\n');
        elseif (rem(currentangle_36000int-2250, 9000) == 0)
            basemprimendpts_c = basemprimendpts22p5_c(primind,:);
            angle = currentangle - 22.5*pi/180;
            fprintf(1, '22p5\n');
        elseif (rem(currentangle_36000int-1125, 9000) == 0)
            basemprimendpts_c = basemprimendpts11p25_c(primind,:);
            angle = currentangle - 11.25*pi/180;
            fprintf(1, '11p25\n');
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
        numofsamples = 10;
        intermcells_m = zeros(numofsamples,3);
        
            startpt = [0 0 currentangle];
            endpt = [endpose_c(1)*resolution endpose_c(2)*resolution ...
                rem(angleind - 1 + baseendpose_c(3), numberofangles)*2*pi/numberofangles];
            intermcells_m = zeros(numofsamples,3);
            if ((endx_c == 0 & endy_c == 0) | baseendpose_c(3) == 0) %turn in place or move forward            
                for iind = 1:numofsamples
                    intermcells_m(iind,:) = [startpt(1) + (endpt(1) - startpt(1))*(iind-1)/(numofsamples-1) ...
                                            startpt(2) + (endpt(2) - startpt(2))*(iind-1)/(numofsamples-1) ...
                                            rem(startpt(3) + (endpt(3) - startpt(3))*(iind-1)/(numofsamples-1), 2*pi)];
                end;            
            else % move forward or backward
                R = [cos(startpt(3)) sin(endpt(3)) - sin(startpt(3));
                    sin(startpt(3)) -(cos(endpt(3)) - cos(startpt(3)))];
                
                
                S = pinv(R)*[endpt(1) - startpt(1); endpt(2) - startpt(2)];
                l = S(1); 
                tvoverrv = S(2);
                rv = (baseendpose_c(3)*2*pi/numberofangles + l/tvoverrv);
                tv = tvoverrv*rv;
                         
                if ((l < 0 & tv > 0) | (l > 0 & tv < 0))
                    fprintf(1, 'WARNING: l = %d < 0 -> bad action start/end points\n', l);
                    l = 0;
                end;
               
                for iind = 1:numofsamples                                        
                    dt = (iind-1)/(numofsamples-1);
                                        
                   
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
       
    
        %write out
        fprintf(fout, 'endpose_c: %d %d %d\n', endpose_c(1), endpose_c(2), endpose_c(3));
        fprintf(fout, 'additionalactioncostmult: %d\n', additionalactioncostmult);
        fprintf(fout, 'intermediateposes: %d\n', size(intermcells_m,1));
        for interind = 1:size(intermcells_m, 1)
            fprintf(fout, '%.4f %.4f %.4f\n', intermcells_m(interind,1), intermcells_m(interind,2), intermcells_m(interind,3));
        end;
       % hold on;
        plot(intermcells_m(:,1), intermcells_m(:,2)); 
        axis([-10 10 -10 10]);
        text(intermcells_m(numofsamples,1), intermcells_m(numofsamples,2), int2str(endpose_c(3)));
        hold on;
        
    end;
   % hold;
    grid;
    pause;
end;
        
fclose('all');
