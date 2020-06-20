clear all;
AssertOpenGL;
Screen('Preference', 'SkipSyncTests', 1);  

ID = 'MM';
block = 4; 
path = [pwd '/Stimuli/'];

% start the log file for reporting
logFID = fopen([ID '_log.txt'],'at+');
% open a file as log file for everything (APPEND DATA)

% external noise steps
stepslog = 0:.05:.95;

[windowPr, rect] = Screen('OpenWindow',0,127.5,[0,0,1920/2,1080/2]); %% When debugged, change this to [windowPr, rect] = Screen('OpenWindow',0,127.5,[]); 
white = WhiteIndex(windowPr);
black = BlackIndex(windowPr);
grey = (white+black)/2;
[xCenter, yCenter] = RectCenter(rect);
textsize=40;
Font='Arial'; Screen('TextSize',windowPr,textsize); Screen('TextFont',windowPr,Font); Screen('TextColor',windowPr,black);
greyRect = Screen('MakeTexture', windowPr, grey);
width = rect(RectRight) - rect(RectLeft);
height = rect(RectBottom)-rect(RectTop);

% fixation cross coords
H=width/2; 
H1=width/2-20;
H2=width/2+20;
V=height/2;
V1=height/2-20;
V2=height/2+20;
penWidth=2;

Screen('DrawTexture',windowPr,greyRect);
DrawFormattedText(windowPr, 'Please wait', 'center', (rect(4)/8)*3);
Screen('Flip', windowPr);

backGrat = {'Same', 'Orth'};

for f = 1:7
    Same{f} = imread([path backGrat{1} num2str(f) '.png']);
    Orth{f} = imread([path backGrat{2} num2str(f) '.png']); 
end
chrom = repmat(1:7,1,20);
chrom = [repmat(chrom(1),1,20) repmat(chrom(2),1,20) repmat(chrom(3),1,20) repmat(chrom(4),1,20)...
    repmat(chrom(5),1,20) repmat(chrom(6),1,20) repmat(chrom(7),1,20)];
stepslog = repmat(stepslog,1,7);
comp = [chrom' stepslog'];

randcomp = randperm(length(comp));

SameB = imread([path 'SameB.png']);
OrthB = imread([path 'OrthB.png']);

stepsrand = stepslog(randperm(length(stepslog)));
chromrand = chrom(randperm(length(chrom)));

ord = repmat(1:2,1,70);
randord = ord(randperm(length(ord)));

%% Start presentation

Screen('DrawTexture',windowPr,greyRect);
DrawFormattedText(windowPr, 'Two images will be presented, one after the other', 'center', (rect(4)/8)*2);
DrawFormattedText(windowPr, 'When prompted indicate whether the first or the second image contained stripes within the circle', 'center', (rect(4)/8)*3);
DrawFormattedText(windowPr, 'Press the spacebar to continue', 'center', (rect(4)/8)*4);
Screen('Flip', windowPr); 
WaitSecs(.1);
KbWait;

response = [];

for back = 1:length(backGrat)

for b = 1:block
             
        Screen('DrawLine', windowPr ,[0 0 0], H1, V, H2, V, penWidth);
        Screen('DrawLine', windowPr ,[0 0 0], H, V1, H, V2, penWidth);
        Screen('Flip', windowPr);
        WaitSecs(0.5);

            for s = 1:length(randcomp)
                if back == 1
                    if randord(s)==1
                    
                    salt = imnoise(Same{comp(randcomp(s),1)}, 'salt & pepper', comp(randcomp(s),2));                
                    grating = Screen('MakeTexture', windowPr, salt);
                    Screen('FillRect',windowPr, grey);
                    Screen('DrawTextures', windowPr, grating);
                    Screen('DrawLine', windowPr ,[0 0 0], H1, V, H2, V, penWidth);
                    Screen('DrawLine', windowPr ,[0 0 0], H, V1, H, V2, penWidth);
                    Screen('Flip', windowPr);
                    WaitSecs(1);
                    clearvars salt grating
                
                    Screen('FillRect',windowPr, grey);
                    Screen('DrawLine', windowPr ,[0 0 0], H1, V, H2, V, penWidth);
                    Screen('DrawLine', windowPr ,[0 0 0], H, V1, H, V2, penWidth);
                    Screen('Flip', windowPr);
                    WaitSecs(1);
                    
                    salt = imnoise(SameB, 'salt & pepper', comp(randcomp(s),2));                
                    grating = Screen('MakeTexture', windowPr, salt);
                    Screen('FillRect',windowPr, grey);
                    Screen('DrawTextures', windowPr, grating);
                    Screen('DrawLine', windowPr ,[0 0 0], H1, V, H2, V, penWidth);
                    Screen('DrawLine', windowPr ,[0 0 0], H, V1, H, V2, penWidth);
                    Screen('Flip', windowPr);
                    WaitSecs(1);
                    clearvars salt grating

                    Screen('FillRect',windowPr, grey);
                    Screen('DrawLine', windowPr ,[0 0 0], H1, V, H2, V, penWidth);
                    Screen('DrawLine', windowPr ,[0 0 0], H, V1, H, V2, penWidth);
                    Screen('Flip', windowPr);
                    WaitSecs(1);                    
                    
                elseif randord(s)==2
                    salt = imnoise(SameB, 'salt & pepper', comp(randcomp(s),2));                
                    grating = Screen('MakeTexture', windowPr, salt);
                    Screen('FillRect',windowPr, grey);
                    Screen('DrawTextures', windowPr, grating);
                    Screen('DrawLine', windowPr ,[0 0 0], H1, V, H2, V, penWidth);
                    Screen('DrawLine', windowPr ,[0 0 0], H, V1, H, V2, penWidth);
                    Screen('Flip', windowPr);
                    WaitSecs(1);
                    clearvars salt grating

                    Screen('FillRect',windowPr, grey);
                    Screen('DrawLine', windowPr ,[0 0 0], H1, V, H2, V, penWidth);
                    Screen('DrawLine', windowPr ,[0 0 0], H, V1, H, V2, penWidth);
                    Screen('Flip', windowPr);
                    WaitSecs(1); 

                    salt = imnoise(Same{comp(randcomp(s),1)}, 'salt & pepper', comp(randcomp(s),2));
                    grating = Screen('MakeTexture', windowPr, salt);
                    Screen('FillRect',windowPr, grey);
                    Screen('DrawTextures', windowPr, grating);
                    Screen('DrawLine', windowPr ,[0 0 0], H1, V, H2, V, penWidth);
                    Screen('DrawLine', windowPr ,[0 0 0], H, V1, H, V2, penWidth);
                    Screen('Flip', windowPr);
                    WaitSecs(1);
                    clearvars salt grating
                
                    Screen('FillRect',windowPr, grey);
                    Screen('DrawLine', windowPr ,[0 0 0], H1, V, H2, V, penWidth);
                    Screen('DrawLine', windowPr ,[0 0 0], H, V1, H, V2, penWidth);
                    Screen('Flip', windowPr);
                    WaitSecs(1);
                    end
                elseif back == 2
                if randord(s)==1
                    
                    salt = imnoise(Orth{comp(randcomp(s),1)}, 'salt & pepper', comp(randcomp(s),2));                
                    grating = Screen('MakeTexture', windowPr, salt);
                    Screen('FillRect',windowPr, grey);
                    Screen('DrawTextures', windowPr, grating);
                    Screen('DrawLine', windowPr ,[0 0 0], H1, V, H2, V, penWidth);
                    Screen('DrawLine', windowPr ,[0 0 0], H, V1, H, V2, penWidth);
                    Screen('Flip', windowPr);
                    WaitSecs(1);
                    clearvars salt grating
                
                    Screen('FillRect',windowPr, grey);
                    Screen('DrawLine', windowPr ,[0 0 0], H1, V, H2, V, penWidth);
                    Screen('DrawLine', windowPr ,[0 0 0], H, V1, H, V2, penWidth);
                    Screen('Flip', windowPr);
                    WaitSecs(1);
                    
                    salt = imnoise(OrthB, 'salt & pepper', comp(randcomp(s),2));                
                    grating = Screen('MakeTexture', windowPr, salt);
                    Screen('FillRect',windowPr, grey);
                    Screen('DrawTextures', windowPr, grating);
                    Screen('DrawLine', windowPr ,[0 0 0], H1, V, H2, V, penWidth);
                    Screen('DrawLine', windowPr ,[0 0 0], H, V1, H, V2, penWidth);
                    Screen('Flip', windowPr);
                    WaitSecs(1);
                    clearvars salt grating

                    Screen('FillRect',windowPr, grey);
                    Screen('DrawLine', windowPr ,[0 0 0], H1, V, H2, V, penWidth);
                    Screen('DrawLine', windowPr ,[0 0 0], H, V1, H, V2, penWidth);
                    Screen('Flip', windowPr);
                    WaitSecs(1);                    
                    
                elseif randord(s)==2
                    salt = imnoise(OrthB, 'salt & pepper', comp(randcomp(s),2));                
                    grating = Screen('MakeTexture', windowPr, salt);
                    Screen('FillRect',windowPr, grey);
                    Screen('DrawTextures', windowPr, grating);
                    Screen('DrawLine', windowPr ,[0 0 0], H1, V, H2, V, penWidth);
                    Screen('DrawLine', windowPr ,[0 0 0], H, V1, H, V2, penWidth);
                    Screen('Flip', windowPr);
                    WaitSecs(1);
                    clearvars salt grating

                    Screen('FillRect',windowPr, grey);
                    Screen('DrawLine', windowPr ,[0 0 0], H1, V, H2, V, penWidth);
                    Screen('DrawLine', windowPr ,[0 0 0], H, V1, H, V2, penWidth);
                    Screen('Flip', windowPr);
                    WaitSecs(1); 

                    salt = imnoise(Orth{comp(randcomp(s),1)}, 'salt & pepper', comp(randcomp(s),2));
                    grating = Screen('MakeTexture', windowPr, salt);
                    Screen('FillRect',windowPr, grey);
                    Screen('DrawTextures', windowPr, grating);
                    Screen('DrawLine', windowPr ,[0 0 0], H1, V, H2, V, penWidth);
                    Screen('DrawLine', windowPr ,[0 0 0], H, V1, H, V2, penWidth);
                    Screen('Flip', windowPr);
                    WaitSecs(1);
                    clearvars salt grating
                
                    Screen('FillRect',windowPr, grey);
                    Screen('DrawLine', windowPr ,[0 0 0], H1, V, H2, V, penWidth);
                    Screen('DrawLine', windowPr ,[0 0 0], H, V1, H, V2, penWidth);
                    Screen('Flip', windowPr);
                    WaitSecs(1);
                end
                end
                
                Screen('DrawTexture',windowPr,greyRect);
                DrawFormattedText(windowPr, 'Did the first or the second circle contain a striped pattern?', 'center', (rect(4)/8)*2);
                DrawFormattedText(windowPr, 'Press "a" for the first; "s" for the second', 'center', (rect(4)/8)*3);
                Screen('Flip', windowPr); 
                WaitSecs(.1);
                KbWait;
                
                [keyIsDown, secs, keyCode, deltaSecs] = KbCheck;
                naming = sort(KbName(keyCode));
                if naming == 'a'
                    choice = 1;
                elseif naming == 's'
                    choice = 2;
                elseif naming == 'c'
                    Screen('CloseAll');
                    fclose(logFID);  
                else choice = NaN;
                end
                
                clearvars keyIsDown secs keyCode deltaSecs naming
        
                sz = size(response);  
                if back == 1 %Same
                    response(1,sz(2)+1) = 1;
                    background = 1;
                elseif back == 2 %Orth
                    response(1,sz(2)+1) = 2;
                    background = 2;
                end
                response(2,sz(2)+1) = comp(randcomp(s),1);
                response(3,sz(2)+1) = comp(randcomp(s),2);
                response(4,sz(2)+1) = choice;
                if randord(s) == 1 && choice == 1
                    response(5,sz(2)+1) = 1;
                    correct = 1;
                elseif randord(s) == 2 && choice == 2
                    response(5,sz(2)+1) = 1;
                    correct = 1;
                else response(5,sz(2)+1) = 0;
                    correct = 0;
                end
                
                % print to logfile:
                fprintf(logFID,['%d\t%d\t%d\t%d\t%d\t\n']', background, comp(randcomp(s),1), comp(randcomp(s),2), choice, correct);   
            end
    
    if b<block
        Screen('DrawTexture',windowPr,greyRect);
        DrawFormattedText(windowPr, 'Take a break', 'center', (rect(4)/8)*3);
        DrawFormattedText(windowPr, 'Press spacebar to continue', 'center', (rect(4)/8)*4);
        Screen('Flip', windowPr); 
        WaitSecs(.1);
        KbWait;
    end
    
end
end

Screen('DrawTexture',windowPr,greyRect);
DrawFormattedText(windowPr, 'Finished!', 'center', (rect(4)/8)*3);
DrawFormattedText(windowPr, 'Thank you', 'center', (rect(4)/8)*4);
Screen('Flip', windowPr); 
WaitSecs(2);

Screen('CloseAll')
fclose(logFID); 
xlswrite([ID '_EqivThresh.xlsx'], response);
