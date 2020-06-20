clearvars;

% Screen('Preference', 'SkipSyncTests', 0);

ID='temp'; % change
HideCursor;

[windowPr,rect] = Screen('OpenWindow',0,0,[]);%0 0 1920/2,1080/2]); % to debug
width=rect(RectRight)-rect(RectLeft);
height=rect(RectBottom)-rect(RectTop);

white = WhiteIndex(windowPr);
black = BlackIndex(windowPr);
gray = 97; 
[xCenter, yCenter] = RectCenter(rect);

% fixation cross coords
H=width/2; 
H1=width/2-(width/2/70);
H2=width/2+(width/2/70);
V=height/2;
V1=height/2-(width/2/70);
V2=height/2+(width/2/70);
penWidth=2;
textsize=40;
Font='Arial'; Screen('TextSize',windowPr,textsize); Screen('TextFont',windowPr,Font); Screen('TextColor',windowPr,black);

quiz = repmat([1 0 0 0 0 0 0 1 0 0 0 0 0 0],1,6);
block = 2;
   
trial = length(quiz);

% load images
path = [pwd '\ColoursShort\'];

%%% set up triggering
object = io64; % 64-bit location handle for parallel interface object
status = io64(object); % all good if status = 0
address = hex2dec('CFF8'); % presentation computer parport address

CDcol = repmat(1:12,1,7);
select = 1:12;

randselect = select(randperm(length(select)));

for f = 1:4
    turq{f} = (imread([path 'Slide0' num2str(f) '.tiff']));
    purp{f} = (imread([path 'Slide0' num2str(f+4) '.tiff']));
    yell{f} = (imread([path 'Slide0' num2str(f+8) '.tiff']));
end
flick = 10;
fTime = .2;

Screen('FillRect',windowPr, gray);
DrawFormattedText(windowPr, 'Please focus on central cross', 'center', (rect(4)/8)*2);
DrawFormattedText(windowPr, 'When prompted, rate how uncomfortable the stripes are to look at', 'center', (rect(4)/8)*3);
DrawFormattedText(windowPr, 'Use the number pad on the right of the keyboard', 'center', (rect(4)/8)*4);
DrawFormattedText(windowPr, 'Press any key to continue', 'center', (rect(4)/8)*5);
Screen('Flip', windowPr);
WaitSecs(.1);
KbWait;

Screen('DrawLine', windowPr ,[0 0 0], H1, V, H2, V, penWidth);
Screen('DrawLine', windowPr ,[0 0 0], H, V1, H, V2, penWidth);
Screen('Flip', windowPr);
WaitSecs(.5);

count = 0;
dis = 0;
choice = [];

start = GetSecs;

io64(object, address, 30);
WaitSecs(.05);
io64(object, address, 0);
   
for k = 1:block
    
    randCDcol = CDcol(randperm(length(CDcol)));
    randquiz = quiz(randperm(length(quiz)));
    
    startT = GetSecs;

for j = 1:trial
    
    if randquiz(j) == 0
        count = count+1;
        
        t = randCDcol(count);
        
        if t < 5
            grating = turq{randCDcol(count)};
        elseif t > 4 && t < 9
            grating = purp{randCDcol(count)-4};
        elseif t > 8
            grating = yell{randCDcol(count)-8};
        end
        
        grating = imresize(grating,1.5);

        for i = 1:flick
            io64(object, address, t);
            WaitSecs(.05);
            io64(object, address, 0);
            rad = Screen('MakeTexture', windowPr, grating);
            Screen('DrawTextures', windowPr, rad);
            Screen('DrawLine', windowPr ,[0 0 0], H1, V, H2, V, penWidth);
            Screen('DrawLine', windowPr ,[0 0 0], H, V1, H, V2, penWidth);
            Screen('Flip', windowPr);
            WaitSecs(fTime);

            Screen('FillRect',windowPr, gray);
            Screen('DrawLine', windowPr ,[0 0 0], H1, V, H2, V, penWidth);
            Screen('DrawLine', windowPr ,[0 0 0], H, V1, H, V2, penWidth);
            Screen('Flip', windowPr);
            WaitSecs(fTime);
        end
        
        sz = size(choice);
        choice(1,sz(2)+1) = 0;
        choice(2,sz(2)+1) = randCDcol(count);

    elseif randquiz(j) == 1
        
        dis = dis+1;
        
        t = randselect(dis);
        
        if t < 5
            grating = turq{randselect(dis)};
        elseif t > 4 && t < 9
            grating = purp{randselect(dis)-4};
        elseif t > 8
            grating = yell{randselect(dis)-8};
        end
        
        grating = imresize(grating,1.5);
        
        io64(object, address, 20+t);
        WaitSecs(.05);
        io64(object, address, 0);
        
        rad = Screen('MakeTexture', windowPr, grating);
        Screen('DrawTextures', windowPr, rad);
        Screen('DrawLine', windowPr ,[0 0 0], H1, V, H2, V, penWidth);
        Screen('DrawLine', windowPr ,[0 0 0], H, V1, H, V2, penWidth);
        DrawFormattedText(windowPr, 'How uncomfortable do you find this pattern?', 'center', (rect(4)/8)*7);
        DrawFormattedText(windowPr, '1=comfortable; 9=uncomfortable', 'center', rect(4)/8*7.5);
        Screen('Flip', windowPr);
        KbWait;
        
        io64(object, address, 13);
        WaitSecs(.05);
        io64(object, address, 0);
        
        sz = size(choice);
        choice(1,sz(2)+1) = 1;
        choice(2,sz(2)+1) = randselect(dis);
        
        [keyIsDown, secs, keyCode, deltaSecs] = KbCheck;
        naming = sort(KbName(keyCode));
        if isnumeric(str2num(naming))
            if length(str2num(naming))==1
                choice(3,sz(2)+1) = str2num(naming);
            end
        else choice(3,sz(2)+1) = NaN;
        end
        
        clearvars keyIsDown secs keyCode deltaSecs naming
        
    end
    

Screen('FillRect',windowPr, gray);
Screen('DrawLine', windowPr ,[0 0 0], H1, V, H2, V, penWidth);
Screen('DrawLine', windowPr ,[0 0 0], H, V1, H, V2, penWidth);
Screen('Flip', windowPr);
WaitSecs(2+(rand/2));

if j == trial/2
    DrawFormattedText(windowPr, 'Please take a break', 'center', (rect(4)/8)*3);
    DrawFormattedText(windowPr, 'Press any key to continue', 'center', (rect(4)/8)*4);
    Screen('Flip', windowPr);
    KbWait;
    clearvars pressed firstPress secs0
    clear KbWait
end

end

count = 0;
dis = 0;

if k < block
    DrawFormattedText(windowPr, 'Please take a break', 'center', (rect(4)/8)*3);
    DrawFormattedText(windowPr, 'Press any key to continue', 'center', (rect(4)/8)*4);
    Screen('Flip', windowPr);
    KbWait;
    clearvars pressed firstPress secs0
    clear KbWait
end

end

finish = GetSecs-start;

DrawFormattedText(windowPr, 'You have finished', 'center', (rect(4)/8)*3);
DrawFormattedText(windowPr, 'Please find the experimenter', 'center', (rect(4)/8)*4);
Screen('Flip', windowPr);
WaitSecs(2);

xlswrite([path ID 'ColourDiffERP.xlsx'], choice);
% dlmread([path ID '_ColourDiffERP.txt'], choice);

Screen('CloseAll');
