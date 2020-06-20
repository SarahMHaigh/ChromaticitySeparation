% to analyse EEG data from migraine study using EEGLAB
% SSVEP_migraine, SSAEP_migraine, ColourDiffERP
% Delays from trig onset to start of stim = 300ms AEP,100ms VEP, 95ms
% ColourDiff

% clear all

eeglab

path = [pwd '/Migraine/'];
eegpath = [pwd '/MATLAB/'];

P = {'M1' 'M2' 'M3' 'M4' 'M5' 'M6' 'M7' 'M8' 'M9' 'M10' 'M11' 'M12' 'M13' 'M14' 'M15' 'M16' 'M17' 'M18'...  
    'C1' 'C2' 'C3' 'C4' 'C5' 'C6' 'C7' 'C8' 'C9' 'C10' 'C11' 'C12' 'C13' 'C14' 'C15' 'C16' 'C17' 'C18' 'C19' 'C20' 'C21'}; %'C14_1' 'C14_2' 

[~, szP] = size(P);

mods = {'ColourDiff'};
[~, szMods] = size(mods);

check = ones(length(P),length(mods));
check(5,3) = 0;
check(13,2) = 0;
check(30,1:3) = 0;

for j = 1:szP
    for i = 1:szMods
        if check(j,i) == 1
            pathup = [path P{j} '/' mods{i} '/'];
            EEG = pop_biosig([pathup P{j} '_' mods{i} '.bdf'], 'ref',[129 130] ,'refoptions',{'keepref' 'off'});
            EEG.setname=[P(j) '_' mods(i)];
            EEG = pop_eegchanoperator( EEG, {  'ch142 = ch129 - ch130 label hEOG',  'ch143 = ch132 - ch131 label vEOG'} , 'ErrorMsg', 'popup', 'Warning','on' );
            EEG = pop_select( EEG,'nochannel',{'LO1' 'LO2' 'IO1' 'SO1' 'IO2' 'GSR1' 'GSR2' 'Erg1' 'Erg2' 'Resp' 'Plet' 'Temp'});
            EEG = eeg_checkset( EEG );
            EEG = pop_eegfiltnew(EEG, 0.1,100,16896,0,[],1);
            EEG = eeg_checkset( EEG );
            pop_eegplot( EEG, 1, 1, 1);
            EEG=pop_chanedit(EEG, 'lookup',[pwd '/HD_EEG_elec_locations.elp']);
            EEG = eeg_checkset( EEG );
            EEG = pop_saveset( EEG, 'filename',[P{j} '_' mods{i} '_filt.set'],'filepath',pathup);
        end
    end
end

for j = 1:szP
    for i = 1:szMods
        pathup = [path P{j} '/' mods{i} '/'];
        EEG = pop_loadset('filename',[P{j} '_' mods{i} '_filt3.set'],'filepath',pathup);
        EEG = pop_saveset( EEG, 'filename',[P{j} '_' mods{i} '_int3.set'],'filepath',pathup);
    end
end
        
for j = 1:szP
    for i = 1:szMods
        if check(j,i) == 1
            pathup = [path P{j} '/' mods{i} '/'];
            EEG = pop_loadset('filename',[P{j} '_' mods{i} '_int.set'],'filepath',pathup);
            EEG = eeg_checkset( EEG );
            EEG = pop_runica(EEG, 'extended',1,'interupt','on');
            EEG = eeg_checkset( EEG );
            EEG = pop_saveset( EEG, 'filename',[P{j} '_' mods{i} '_postica.set'],'filepath',pathup);
            EEG = eeg_checkset( EEG );
            EEG = pop_loadset('filename',[P{j} '_' mods{i} '_postica.set'],'filepath',pathup);
            EEG = eeg_checkset( EEG );
            pop_eegplot( EEG, 0, 1, 1);
        end
    end
end

for j = 1:szP
    for i = 1:szMods
        if check(j,i) == 1
            pathup = [path P{j} '/' mods{i} '/'];
            EEG = pop_loadset('filename',[P{j} '_' mods{i} '_postica_pruned.set'],'filepath',pathup);

            for n = 1:length(EEG.event)
                EEG.event(n).latency = EEG.event(n).latency+40; % gives +90 adjusted for trigger difference
            end
            
            EEG  = pop_creabasiceventlist( EEG , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99 }, 'BoundaryString', { 'boundary' }, 'Eventlist',...
                [pathup P{j} '_' mods{i} '_condsC.txt'] );
            EEG  = pop_binlister( EEG , 'BDF', [path mods{i} '_codes.txt'], 'ExportEL',...
                [pathup P{j} '_' mods{i} '_elistC.txt'], 'ImportEL', [pathup P{j} '_' mods{i} '_condsC.txt'],...
                'IndexEL',  1, 'SendEL2', 'EEG&Text', 'UpdateEEG', 'on', 'Voutput', 'EEG' );
            if strmatch('ColourDiff',mods{i})
                EEG = pop_epochbin( EEG , [-100.0  500.0],  'pre');
                EEG  = pop_artextval( EEG , 'Channel',  1:128, 'Flag',  1, 'Threshold', [ -200 200], 'Twindow',[ -100 500] );
            else
                EEG = pop_epochbin( EEG , [-300.0  3500.0],  'pre');
            end

            ERP = pop_averager( EEG , 'Criterion', 'good', 'ExcludeBoundary', 'on', 'SEM', 'on' );
            ERP = pop_savemyerp(ERP, 'erpname',...
                [P{j} '_' mods{i}], 'filename', [P{j} '_' mods{i} '_artC.erp'], 'filepath', pathup, 'Warning', 'off');
            ERP = pop_filterp( ERP,  1:128 , 'Cutoff', 30, 'Design', 'butter', 'Filter', 'lowpass', 'Order',  2 );
            ERP = pop_savemyerp(ERP, 'erpname',...
                [P{j} '_' mods{i}], 'filename', [P{j} '_' mods{i} '_artfiltC.erp'], 'filepath', pathup, 'Warning', 'off');
            ERP = pop_getFFTfromERP( ERP , 'NFFT',  1024, 'TaperWindow', 'on' );
            ERP = pop_savemyerp(ERP, 'erpname',...
                [P{j} '_' mods{i}], 'filename', [P{j} '_' mods{i} '_Freq.erp'], 'filepath', pathup, 'Warning', 'off');
        end
    end
end

% Create small CD average
ERP = pop_binoperator( ERP, {  'bin13=(b1+b5+b9)/3'});
% Create mid small CD average
ERP = pop_binoperator( ERP, {  'bin14=(b2+b6+b10)/3'});
% Create mid large CD average
ERP = pop_binoperator( ERP, {  'bin15=(b3+b7+b11)/3'});        
% Create large CD average
ERP = pop_binoperator( ERP, {  'bin16=(b4+b8+b12)/3'}); 
% Create average
ERP = pop_binoperator( ERP, {  'bin17=(b13+b14+b15+b16)/4'}); 

% Colour graphs ERPs            
ERP = pop_ploterps( ERP,  [13 16],  [3 11 25 36 52 81 84 88 97 100 113 116] , 'AutoYlim', 'off', 'Axsize', [ 0.05 0.08], 'BinNum', 'on', 'Blc', 'pre', 'Box', [ 3 4], 'ChLabel',...
 'on', 'FontSizeChan',  10, 'FontSizeLeg',  12, 'FontSizeTicks',  20, 'LegPos', 'bottom', 'Linespec', {'k-' , 'r-' , 'b-' , 'g-' }, 'LineWidth',...
  3, 'Maximize', 'on', 'Position', [ 57.75 11.6667 106.875 31.9444], 'Style', 'Classic', 'Tag', 'ERP_figure', 'Transparency',  0, 'xscale',...
 [ -100.0 500.0   -150 0:200:2000 ], 'YDir', 'normal', 'yscale', [ -10.0 6.0   -10:5:6 ] );

% Colour graphs Power            
ERP = pop_ploterps( ERP,  13:16,  [11 92 84 108] , 'AutoYlim', 'off', 'Axsize', [ 0.05 0.08], 'BinNum', 'on', 'Blc', 'pre', 'Box', [ 2 2], 'ChLabel',...
 'on', 'FontSizeChan',  10, 'FontSizeLeg',  12, 'FontSizeTicks',  20, 'LegPos', 'bottom', 'Linespec', {'k-' , 'r-' , 'b-' , 'g-' }, 'LineWidth',...
  3, 'Maximize', 'on', 'Position', [ 57.75 11.6667 106.875 31.9444], 'Style', 'Classic', 'Tag', 'ERP_figure', 'Transparency',  0, 'xscale',...
 [ 0.0 32.0   0:5:25 ], 'YDir', 'normal', 'yscale', [ -2.0 6.0   -2:2:6 ] );
