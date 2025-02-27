
clear
Q = importdata('240813 - Key Novel Dataset - 9 - removed pilot entries.xlsx');

%%

% how many items

D.nItems = size(Q.data,1);

% create a data structure for all the data

% date / time of item creation
D.tItem = datetime(Q.data(:,1),'ConvertFrom', 'excel');

% title
D.title = Q.textdata(2:end,6);

% author 1
D.author1 = Q.textdata(2:end,7);

% author 1 gender
D.gender1 = Q.textdata(2:end,8);
% these fields are currently not used, but are prepared for future analysis

% author 2
D.author2 = Q.textdata(2:end,9);

% author 2 gender
D.gender2 = Q.textdata(2:end,10);
% these fields are currently not used, but are prepared for future analysis

% publication year
D.pubYear = Q.data(:,11);

% # of pages
D.nPages = Q.data(:,15);

% conventional-experimental
D.convVSexp = Q.data(:,23);

% sub-division of novel
subDiv = Q.textdata(2:end,24);
uniqSubDiv = unique(subDiv);

v = cell2mat(cellfun(@(x)find(strcmp(uniqSubDiv,x)),subDiv,'UniformOutput',false));

D.isDivSect = zeros(D.nItems,1);
D.isDivChap = zeros(D.nItems,1);

D.isDivSect(v==5) = NaN;
D.isDivChap(v==5) = NaN;

D.isDivSect(v==2 | v==3) = 1;
D.isDivChap(v==3 | v==4) = 1;

% division length (ambiguous if hierarchical!!!!)
lDiv = Q.textdata(2:end,25);
uniqLDiv = unique(lDiv);

v = cell2mat(cellfun(@(x)find(strcmp(uniqLDiv,x)),lDiv,'UniformOutput',false));

D.lenDiv = zeros(D.nItems,1);
D.lenDiv(v==1 | v==2 | v==8) = NaN;
D.lenDiv(v==3) = 4;
D.lenDiv(v==4) = 5;
D.lenDiv(v==5) = 3;
D.lenDiv(v==6) = 2;
D.lenDiv(v==7) = 1;

%% narration style (diegetic / non-diegetic / mixed narration)
D.narratType = NaN(D.nItems,1);
uNar = unique(Q.textdata(2:end,31));

v = cell2mat(cellfun(@(x)find(strcmp(uNar,x)),Q.textdata(2:end,31), ...
    'UniformOutput',false));

D.narratType(v==2) = 1; % diegetic
D.narratType(v==3) = 0; % non-diegetic
D.narratType(v==4) = 2; % mixed

% narrator reliability
D.narratRel = NaN(D.nItems,1);
uRel = unique(Q.textdata(2:end,37));

v = cell2mat(cellfun(@(x)find(strcmp(uRel,x)),Q.textdata(2:end,37), ...
    'UniformOutput',false));

D.narratRel(v==3) = 0; % non-reliable
D.narratRel(v==4 | v==5) = 1; % reliable
D.narratRel(v==6) = 0.5; % hard to determine

%% character number (main and secondary)

% key: NaN - unknown or murky answer
% 1-9: WYSIWYG...
% 10: several / few / etc.
% 100: many, huge number / etc.

% this table is generated from manually going over the unique(Q.textdata(2:end,39))
% to be taken with a grain of salt

load charNumKey

uCharNum = unique(Q.textdata(2:end,39));

v = cell2mat(cellfun(@(x)find(strcmp(uCharNum,x)),Q.textdata(2:end,39), ...
    'UniformOutput',false));

D.nCharMain = charNumKey(v,1);
D.nCharSec  = charNumKey(v,2);

%% nestled story

D.isNest = NaN(D.nItems,1);
uNest = unique(Q.textdata(2:end,44));

v = cell2mat(cellfun(@(x)find(strcmp(uNest,x)),Q.textdata(2:end,44), ...
    'UniformOutput',false));

D.isNest(v==1) = 1;
D.isNest(v==2) = 0;
D.isNest(v==3) = 0.5; % or NaN???

%% exposition

uExp = unique(Q.textdata(2:end,45));

v = cell2mat(cellfun(@(x)find(strcmp(uExp,x)),Q.textdata(2:end,45), ...
    'UniformOutput',false));

D.whereExp(v==1) = 0; % no exposition
D.whereExp(v==2 | v==6) = NaN; % not familiar with term / hard to define
D.whereExp(v==3) = 3; % delayed exposition
D.whereExp(v==4) = 2; % spread out exposition
D.whereExp(v==5) = 1; % early exposition

%% pace
D.pace = Q.data(:,46);

%% gaps
D.gaps = Q.data(:,47);

%% number of main events

% key: NaN - unknown or murky answer
% 1-2: WYSIWYG...
% 10: several / few / etc.
% 100: many, huge number / etc.

% this table is generated from manually going over the unique(Q.textdata(2:end,48))
% to be taken with a grain of salt

load evtNumKey

uEvtNum = unique(Q.textdata(2:end,48));

v = cell2mat(cellfun(@(x)find(strcmp(uEvtNum,x)),Q.textdata(2:end,48), ...
    'UniformOutput',false));

D.nEvt = evtNumKey(v,1);

%% surprise
D.surp = Q.data(:,49);

%% open-close ending
D.open = Q.data(:,51);

%% was Hebrew spoken
uHebSpeak = unique(Q.textdata(2:end,52));

v = cell2mat(cellfun(@(x)find(strcmp(uHebSpeak,x)),Q.textdata(2:end,52), ...
    'UniformOutput',false));

D.hebSpeak = zeros(D.nItems,1);
D.hebSpeak(v==1) = 1;

%% register (1 low, 5 high)
D.register = Q.data(:,53);

p = find(isnan(D.register) & D.hebSpeak);
D.register = zeros(size(D.register));
D.register(p) = NaN;


%% mixed register

% "hard to define": NaN
% empty field: NaN        (consider separating???)

uMixed = unique(Q.textdata(2:end,54));

v = cell2mat(cellfun(@(x)find(strcmp(uMixed,x)),Q.textdata(2:end,54), ...
    'UniformOutput',false));

D.isMixedReg = NaN(D.nItems,1);
D.isMixedReg(v==2) = 1;
D.isMixedReg(v==3) = 0;

%% what languages were used (use the binary version!)

load languagesUsed

uLang = unique(Q.textdata(2:end,55));

v = cell2mat(cellfun(@(x)find(strcmp(uLang,x)),Q.textdata(2:end,55), ...
    'UniformOutput',false));

D.langStr = langStr;
D.langVec = cell2mat(arrayfun(@(k)langMatBin(k,:),v, ...
    'UniformOutput',false));
D.whichLang = arrayfun(@(k)find(D.langVec(k,:)),1:D.nItems, ...
    'UniformOutput',false);

%% intertextuality
D.interTxt = Q.data(:,56);

%% how readable
D.howReadable = Q.data(:,59);

%% time-span

uET = unique(Q.textdata(2:end,61));

tChron = [4 4 2 8 6 7 NaN 3 5 1]';

v = cell2mat(cellfun(@(x)find(strcmp(uET,x)),Q.textdata(2:end,61), ...
    'UniformOutput',false));

D.chronScore = tChron(v');

%%

% geography

geoResp = strip(Q.textdata(2:end,64));
uGeo = unique(Q.textdata(2:end,64));
geoItems = cellfun(@(x)split(x,','),uGeo,'UniformOutput',false);
uGeoItems = unique(strip(cellflat(geoItems)));

load geoData

% rows 1-6 of geoHier are binary, and indicate whether any of the 63
% entities is (in order) (1) continent; (2) sub-continental entity; (3)
% country; (4) region; (5) city; (6) entity smaller than city
D.geoAnalysis.uniqueHier = geoHier(1:6,:);

D.geoAnalysis.isUndefined = geoHier(7,:); % e.g. not mentioned in name
D.geoAnalysis.isHistorical = geoHier(8,:); % e.g. Babylonian empire
D.geoAnalysis.isUnrealistic = geoHier(9,:); % e.g. fictional island

D.geoAnalysis.entities = geoEntity;

for k = 1:D.nItems
    
    s = strip(split(geoResp{k},',')); % each item's multiple geo locations as a cell array
    
    % the result is a cell array, whose elements are vectors, whose
    % elements are the indices of other D.geoAnalysis data referring to
    % this item.
    D.geoAnalysis.ID{k} = find(cell2mat(cellfun(@(x)any(strcmp(s,x)), ...
        uGeoItems,'UniformOutput',false)));
    
end

%% Israel's place in the novel (none / marginal / central)

uIsra = unique(Q.textdata(2:end,66));
israCode = [NaN 0 1 0.5]; % empty / doesn't appear / central / marginal

D.israRole = israCode(cell2mat(cellfun(@(x)find(strcmp(uIsra,x)),Q.textdata(2:end,66), ...
    'UniformOutput',false)));

%% the place of love in the novel

uLove = unique(Q.textdata(2:end,69));
D.loveTheme = zeros(D.nItems,1);
D.loveTheme(find(strcmp(uLove{2},Q.textdata(2:end,69)))) = 1;
D.loveTheme(find(strcmp(uLove{3},Q.textdata(2:end,69)))) = 0.5;

%% the place of war in the novel: central (1), marginal (0.5), none (0); NaN
% for not answering

uWar = unique(Q.textdata(2:end,72));
D.warTheme = zeros(D.nItems,1);
D.warTheme(find(strcmp(uWar{2},Q.textdata(2:end,72)))) = 1;
D.warTheme(find(strcmp(uWar{3},Q.textdata(2:end,72)))) = 0.5;

%% general iportance of novel
% redo!!!! There was a comma bug imported from the questionnaires

impResp = strip(Q.textdata(2:end,76));
uImp = unique(Q.textdata(2:end,76));
impItems = cellfun(@(x)split(x,','),uImp,'UniformOutput',false);
uImpItems = unique(strip(cellflat(impItems)));

load importData

% Key:
% 1: unknown
% 2: groundbreaking
% 3: epigonic / lacks novelty
% 4: research import
% 5: canonical
% 6: marginal
% 7: received attention (readers / research)
% 8: worthy of reassessment
% 9: no importance
% 10: academically over-estimated

for k = 1:D.nItems
    
    s = strip(split(impResp{k},',')); % each item's multiple geo locations as a cell array
    
    p = find(cell2mat(cellfun(@(x)any(strcmp(s,x)), ...
        uImpItems,'UniformOutput',false)));
    [u,v] = find(impMat(:,p));
    D.import{k} = u;
    
end

%% how easy was it to characterise the novel using this questionnaire

D.easeChar = Q.data(:,78);

% grammatical tense

uTense = unique(Q.textdata(2:end,80));

% 1: empty
% 2: present
% 3: mixed
% 4: past
% 5: future
% 6: hard to define

D.tense = nan(D.nItems,1);
D.tense(find(strcmp(Q.textdata(2:end,80),uTense{2}))) = 0; % present
D.tense(find(strcmp(Q.textdata(2:end,80),uTense{4}))) = -1; % past
D.tense(find(strcmp(Q.textdata(2:end,80),uTense{5}))) = 1; % future
D.ambigTense = zeros(D.nItems,1);
D.ambigTense(find(strcmp(Q.textdata(2:end,80),uTense{6}))) = 1;
D.mixedTense = zeros(D.nItems,1);
D.mixedTense(find(strcmp(Q.textdata(2:end,80),uTense{3}))) = 1;






%%

% not included but super interesting
% ==================================
% D.genre = Q.textdata(2:end,22); % requires pre-processing!!!
% D.incQuote = Q.textdata(2:end,26); % weird field, is both binary y/n and
% content-inclusive. Lots to do here, may relate to other facets of the
% novel. % requires pre-processing!!!
% text 32: narrator type (for diegetic only?)
% text 33/34/35: narrator characteristics (multiple, comma sep. per answer, long
% list) - requires much pre-processing!
% text 36: narrator knowledge - lots of pre-processing, free text
% text 38: free indirect speech
% text 43: number of plot lines (free text, too many options)
% text 57: influences
% text 58: referal to other texts
% text 60: why is the novel readable / non-readable
% text 62: historical time period/s
% text 63: space type in which story takes place (road / room / ...)
% text 65: specific place names!!!
% text 67: themes (too many!!!)
% text 68: historical events (very subjective!!!)
% text 77: why is novel important


% not included in the meantime, not so interesting
% ================================================
% D.email = Q.textdata(2:end,2);
% D.readerName = Q.textdata(2:end,3);
% D.readerChar = Q.textdata(2:end,4); % each item may contain multiple, comma delimited answers
% D.format = Q.textdata(2:end,5);
% D.publisher = Q.textdata(2:end,12); % requires pre-processing!!!
% D.isSeries(find(strcmp(Q.textdata(2:end,13),'כן')),1) = 1;
% D.isSeries(find(strcmp(Q.textdata(2:end,13),'לא')),1) = 0;
% D.isSeries(find(strcmp(Q.textdata(2:end,13),'אינני יודע.ת')),1) = NaN;
% D.editor = Q.textdata(2:end,14); % requires pre-processing!!!
% D.isDebut(find(strcmp(Q.textdata(2:end,16),'כן')),1) = 1;
% D.isDebut(find(strcmp(Q.textdata(2:end,16),'לא')),1) = 0;
% D.isDebut(find(strcmp(Q.textdata(2:end,16),'אינני יודע.ת')),1) = NaN;
% D.isLast(find(strcmp(Q.textdata(2:end,17),'כן')),1) = 1;
% D.isLast(find(strcmp(Q.textdata(2:end,17),'לא')),1) = 0;
% D.isLast(find(strcmp(Q.textdata(2:end,17),'אינני יודע.ת')),1) = NaN;
% D.isLast(find(strcmp(Q.textdata(2:end,17),'המחבר.ת חי.ה')),1) = -1; % still alive, can't determine if it's the last one
% D.critResponse = Q.textdata(2:end,18);
% D.isPrize(find(strcmp(Q.textdata(2:end,16),'כן')),1) = 1;
% D.isPrize(find(strcmp(Q.textdata(2:end,16),'לא')),1) = 0;
% D.isPrize(find(strcmp(Q.textdata(2:end,16),'אינני יודע.ת') | ...
%     strcmp(Q.textdata(2:end,16),'לא יודע.ת')),1) = NaN;
% D.whichILPrize = Q.textdata(2:end,20); % requires pre-processing!!!
% D.whichIntPrize = Q.textdata(2:end,21); % requires pre-processing!!!
% D.isNonText = NaN(D.nItems,1);
% D.isNonText(find(strcmp(Q.textdata(2:end,27),'כן'))) = 1;
% D.isNonText(find(strcmp(Q.textdata(2:end,27),'לא'))) = 0;
% D.useVarFont = NaN(D.nItems,1);
% uFont = unique(Q.textdata(2:end,28));
% v = cell2mat(cellfun(@(x)find(strcmp(uFont,x)),Q.textdata(2:end,28), ...
%     'UniformOutput',false));
% D.useVarFont(v==2) = 1;
% D.useVarFont(v==3) = 0;
% text 29: diacritics (multiple choice)
% text 30: page division
% text 40: anthopomorphism
% text 41: characteristics of main characters: super complex free text...
% text 42: communication between characters (medium): complex free text
% text 50: properties of fill-in text (free text)
% text 70: type of love relationship
% text 71: inter-generational relationships
% text 73: which war (too many answers!!)
% text 74,75: cause of death (if there is)
% text 79: additional comments
% 







save allData250203 D