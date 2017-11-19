classdef displayer < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        wPtr
        width
        height
        xCen
        yCen
        screenID
        row
        col
        decideTime
        displayerOn
    end
    
    properties (Constant)
        WHITE = [255 255 255];
        YELLOW = [255 255 0];
        GREEN = [0 255 0];
        RED = [255 0 0];
        GREY = [100 100 100];
        DIMYELLOW = [100 100 0];
        yGrid = [23 29 35 41 47 53 59 65 71 77];
        xGrid = [20 35 50 65 80];
    end
    
    methods
        
        %===== Constructor =====%
        function obj = displayer(screid,displayerOn)
            obj.screenID = screid;
            obj.decideTime = 10;
            obj.displayerOn = displayerOn;
        end
        
        %===== Open Close Screen =====%
        function openScreen(obj)
            if ~obj.displayerOn return; end
            
            [obj.wPtr, screenRect]=Screen('OpenWindow',obj.screenID, 0,[],32,2);
            [obj.width, obj.height] = Screen('WindowSize', obj.wPtr);
            obj.xCen = obj.width/2;
            obj.yCen = obj.height/2;
            for i = 1:10
                obj.row(i) = -(i-6)*obj.height/10;
            end
            
            for i = 1:5
                obj.col(i) = (i-3)*obj.width/6;
            end
        end
        
        function closeScreen(obj)
            if ~obj.displayerOn return; end
            Screen('CloseAll');
        end
        
        %===== Display =====%
        
        function writeMessage(obj,line1,line2)
            if ~obj.displayerOn return; end
            obj.write(line1,2,3,'white',30);
            obj.write(line2,2,5,'white',30);
            Screen('Flip',obj.wPtr);
        end
                
        function blackScreen(obj)
            if ~obj.displayerOn return; end
            Screen('Flip',obj.wPtr);
        end
        
        function fixation(obj,fixationTime)
            if ~obj.displayerOn return; end
            l = 10;
            
            %delay
            Screen('Flip',obj.wPtr);
            WaitSecs(.5);
            
            %fixation square
            Screen('FillRect', obj.wPtr, obj.WHITE, [obj.xCen-l,obj.yCen-l,obj.xCen+l,obj.yCen+l]);
            Screen('Flip',obj.wPtr);
            WaitSecs(fixationTime);
            
            %delay
            Screen('Flip',obj.wPtr);
            WaitSecs(.5);
        end
        
        function delay(obj,time)
            if ~obj.displayerOn return; end
            Screen('Flip',obj.wPtr);
            WaitSecs(time);
        end

        function decideScreen(obj,state,myRes,data,timer,confirmed)
            if ~obj.displayerOn return; end
            
            %--------------------------------------
            %1  timer here?
            %2  Your    Guess   Real 
            %3  Choice  Sum     Sum
            %4  1               
            %5  2       2       2
            %6  3       3       3
            %7          4       4
            %8          5       5
            %9          6       6
            %10 Your Score:   
            %--------------------------------------
            
            
            %1 Your Choice
            obj.write('Your',1,2,'white',30);
            obj.write('Choice',1,3,'white',30);
            obj.write('1',1,4,'white',30);
            obj.write('2',1,5,'white',30);
            obj.write('3',1,6,'white',30);
            if(strcmp(state,'choose'))
                obj.drawTimer(timer,1,1);
                if(~confirmed)
                    if(myRes.choice ~= 0) obj.write(num2str(myRes.choice),1,myRes.choice+3,'yellow',30); end
                end
                
                if(confirmed)
                    if(myRes.choice ~= 0) obj.write(num2str(myRes.choice),1,myRes.choice+3,'red',30); end
                end            
            end
            
            if(strcmp(state,'guessSum') || strcmp(state,'showResult'))
                if(myRes.choice ~= 0) obj.write(num2str(myRes.choice),1,myRes.choice+3,'red',30); end          
            end
            
            %1 Guess Sum
            obj.write('Guess',2,2,'white',30);
            obj.write('Sum',2,3,'white',30);
            if(strcmp(state,'guessSum'))
                obj.drawTimer(timer,2,1);
                obj.write('2',2,5,'white',30);
                obj.write('3',2,6,'white',30);
                obj.write('4',2,7,'white',30);
                obj.write('5',2,8,'white',30);
                obj.write('6',2,9,'white',30);
                if(confirmed)
                    if(myRes.guess ~= 0) obj.write(num2str(myRes.guess),2,myRes.guess+3,'red',30); end
                end
                
                if(~confirmed)
                    if(myRes.guess ~= 0) obj.write(num2str(myRes.guess),2,myRes.guess+3,'yellow',30); end
                end
            end

            
            if(strcmp(state,'showResult'))
                obj.write('2',2,5,'white',30);
                obj.write('3',2,6,'white',30);
                obj.write('4',2,7,'white',30);
                obj.write('5',2,8,'white',30);
                obj.write('6',2,9,'white',30);
                if(myRes.guess ~= 0) obj.write(num2str(myRes.guess),2,myRes.guess+3,'red',30); end
            end
            
            %Real Sum, Opp guess, Opp choice
            obj.write('Real',3,2,'white',30);
            obj.write('Sum',3,3,'white',30);
            
            %Opp guess sum
            obj.write('Opp',4,2,'white',30);
            obj.write('Guess',4,3,'white',30);
            
            %Opp choice
            obj.write('Opp',5,2,'white',30);
            obj.write('Choice',5,3,'white',30);
            
            if(strcmp(state,'showResult'))
                %real sum
                obj.write('2',3,5,'white',30);
                obj.write('3',3,6,'white',30);
                obj.write('4',3,7,'white',30);
                obj.write('5',3,8,'white',30);
                obj.write('6',3,9,'white',30);
                
                %opp Guess
                obj.write('2',4,5,'white',30);
                obj.write('3',4,6,'white',30);
                obj.write('4',4,7,'white',30);
                obj.write('5',4,8,'white',30);
                obj.write('6',4,9,'white',30);
                
                %opp Choice
                obj.write('1',5,4,'white',30);
                obj.write('2',5,5,'white',30);
                obj.write('3',5,6,'white',30);
                
                if(data.realSum ~= 0) obj.write(num2str(data.realSum),3,data.realSum+3,'red',30); end
                if(data.oppGuess ~= 0) obj.write(num2str(data.oppGuess),4,data.oppGuess+3,'red',30); end
                if(data.oppChoice ~= 0) obj.write(num2str(data.oppChoice),5,data.oppChoice+3,'red',30); end
                
                %your Score
                obj.write('Your Score:',1,10,'white',30);
                obj.write(num2str(data.yourScore),2,10,'white',30);
                obj.write('Opp Score:',4,10,'white',30);
                obj.write(num2str(data.oppScore),5,10,'white',30);
                
                if(strcmp(data.winner,'WIN')) obj.write('WIN',3,10,'red',30); end
                if(strcmp(data.winner,'LOSE')) obj.write('LOSE',3,10,'green',30); end
                if(strcmp(data.winner,'DRAW')) obj.write('DRAW',3,10,'white',30); end
                
            end
            
            
%                 data.yourChoice = obj.result{trial,2};
%                 data.yourGuess  = obj.result{trial,3};
%                 data.oppChoice  = obj.result{trial,4};
%                 data.oppGuess   = obj.result{trial,5};
%                 data.realSum    = obj.result{trial,6};
%                 data.winner     = obj.result{trial,9};
%                 data.yourScore  = obj.result{trial,10};
%                 data.oppScore   = obj.result{trial,11};
            
            Screen('Flip',obj.wPtr);
        end
        
        function write(obj,text,x,y,c,size)
            if strcmp(c,'white') color = obj.WHITE; end
            if strcmp(c,'red') color = obj.RED; end
            if strcmp(c,'green') color = obj.GREEN; end
            if strcmp(c,'yellow') color = obj.YELLOW; end

            Screen('TextSize', obj.wPtr,size);
            Screen('DrawText',obj.wPtr,char(text), ceil(obj.xGrid(x)*obj.width/100), ceil(obj.yGrid(y)*obj.height/100), color);
            
        end
        
        function drawTimer(obj,t,xPosi,yPosi)
            w = 5;
            h = 20;
            margin = 13;
            x = ceil(obj.xGrid(xPosi)*obj.width/100);
            y = ceil(obj.yGrid(yPosi)*obj.height/100);
            for i = 1:t
                Screen('FillRect', obj.wPtr, obj.YELLOW, [x,y,x+w,y+h]);
                x = x+margin;
            end

        end
        
        function showResult(obj,result)
            obj.write('[ Fianl Result ]',38,3,'white',30);
            
            obj.write('Your Cash',30,4,'white',30);
            obj.write(num2str(result.myCash),50,4,'white',30);
            obj.write('Opponent Cash',30,5,'white',30);
            obj.write(num2str(result.oppCash),50,5,'white',30);
            
            if (result.myCash > result.oppCash)
                obj.write('YOU WIN',40,6,'red',30);
                fprintf('[RESULT] you win\n');
            end
            if (result.myCash == result.oppCash)
                obj.write('DRAW ',40,6,'white',30);
                fprintf('[RESULT] draw\n');
            end
            if (result.myCash < result.oppCash)
                obj.write('YOU LOSE',40,6,'green',30);
                fprintf('[RESULT] you lose\n');
            end
            Screen('Flip',obj.wPtr);
        end
        
    end
    
end

