
clear
close all hidden

load MultipleReadings250203
Q = importdata('240813 - Key Novel Dataset - 9 - removed pilot entries.xlsx');


%% title and author fields

% all titles / authors are filled! No ambivalence!

%% ambivalence types

A.ambType{1} = 'it is unknown';
A.ambType{2} = 'empty field';
A.ambType{3} = 'hard to define';
A.ambType{4} = 'impossible to answer';
A.ambType{5} = 'term unknown';
A.ambType{6} = 'rejection of question';
A.ambType{7} = 'do not remember accurately';
A.ambType{8} = 'I do not know + answer';
A.ambType{9} = 'I do not know';
A.ambType{10} = 'unsure/doubt';

%% item types

A.itemType{1} = 'free text';
A.itemType{2} = 'free number';
A.itemType{3} = 'scale 1-5';
A.itemType{4} = 'list';
A.itemType{5} = 'binary/hard to define';
A.itemType{6} = 'binary';
A.itemType{7} = 'ternary';


%%

% structure of A.ambMat: questionnaire (1030) x item x type of ambivalence


%% author gender

% 2: "unknown" (free addition of reader, not a given option!)

A.field{1} = 'auth gender';
A.fieldType(1) = 1; % 

uG = unique(D.gender1);
A.ambMat(:,1,1) = cellfun(@(x)strcmp(x,uG{2}),D.gender1);

%% publication year

A.field{2} = 'pub. year';
A.fieldType(2) = 2; % 

A.ambMat(:,2,2) = isnan(D.pubYear);

%% number of pages

A.field{3} = '# of pages';
A.fieldType(3) = 2; % 

A.ambMat(:,3,2) = isnan(D.nPages);

%% 4 of 9 scaled items in the questionnaire (self-explanatory)

A.field(4:7) = {'conv.-exp.','gaps','reg.','intert.'};
A.fieldType(4:7) = 3;
A.ambMat(:,4:7,2) = isnan([D.convVSexp D.gaps D.register D.interTxt]);

%% type of novel subdivisions (chapters, sections, both...)

% one ambivalent response exists:
% 5: "hard to define"
% [probably no one left it completely empty]

A.field{8} = 'struct.';
A.fieldType(8) = 4;

uSub= unique(Q.textdata(2:end,24));
A.ambMat(:,8,3) = cellfun(@(x)strcmp(x,uSub{5}),Q.textdata(2:end,24));


%% length of subdivisions of novel (in # of pages)

% three ambivalent options exist:
% "hard to define"
% 2: No answer
% "can't count pages in the format in which I read the novel"

A.field{9} = 'subdiv. length';
A.fieldType(9) = 4;

uLDiv = unique(Q.textdata(2:end,25));

A.ambMat(:,9,2) = cellfun(@(x)strcmp(x,uLDiv{1}),Q.textdata(2:end,25));
A.ambMat(:,9,3) = cellfun(@(x)strcmp(x,uLDiv{8}),Q.textdata(2:end,25));
A.ambMat(:,9,4) = cellfun(@(x)strcmp(x,uLDiv{2}),Q.textdata(2:end,25));

%% diegetic narrator

A.field{10} = 'narrat.';
A.fieldType(10) = 7;

% ambivalent option: "don't know the term"

A.ambMat(:,10,5) = isnan(D.narratType);

%% narrator reliability

A.field{11} = 'reliab.';
A.fieldType(11) = 7;

% three ambivalent options exist:
% 6: "hard to define"
% 1: No answer
% 2: "not familiar with the term"

uRel = unique(Q.textdata(2:end,37));

A.ambMat(:,11,2) = cellfun(@(x)strcmp(x,uRel{1}),Q.textdata(2:end,37));
A.ambMat(:,11,3) = cellfun(@(x)strcmp(x,uRel{6}),Q.textdata(2:end,37));
A.ambMat(:,11,5) = cellfun(@(x)strcmp(x,uRel{2}),Q.textdata(2:end,37));

%% number of main characters

% 15: why it's not an accurate question
% 19: hard to answer

A.field{12} = '# char.';
A.fieldType(12) = 8;

uCharNum = unique(Q.textdata(2:end,39));

A.ambMat(:,12,3) = cellfun(@(x)strcmp(x,uCharNum{19}),Q.textdata(2:end,39));
A.ambMat(:,12,6) = cellfun(@(x)strcmp(x,uCharNum{15}),Q.textdata(2:end,39));

%% nested story

A.field{13} = 'nest';
A.fieldType(13) = 5;

uNest = unique(Q.textdata(2:end,44));

% 3: "hard to determine"

A.ambMat(:,13,3) = cellfun(@(x)strcmp(x,uNest{3}),Q.textdata(2:end,44));

%% exposition located in:

A.field{14} = 'exposit.';
A.fieldType(14) = 4;

% 2: don't know the term
% 6: hard to define

uExp = unique(Q.textdata(2:end,45));

A.ambMat(:,14,3) = cellfun(@(x)strcmp(x,uExp{6}),Q.textdata(2:end,45));
A.ambMat(:,14,5) = cellfun(@(x)strcmp(x,uExp{2}),Q.textdata(2:end,45));

%% number of events

% 1: *I* don't know
% 14: hard to define

A.field{15} = '# events';
A.fieldType(15) = 1;

uEvtNum = unique(Q.textdata(2:end,48));

A.ambMat(:,15,3) = cellfun(@(x)strcmp(x,uEvtNum{14}),Q.textdata(2:end,48));
A.ambMat(:,15,9) = cellfun(@(x)strcmp(x,uEvtNum{1}),Q.textdata(2:end,48));

%% mixed register

% 1: empty
% 4: hard to define

A.field{16} = 'mixed register';
A.fieldType(16) = 5;

uMixed = unique(Q.textdata(2:end,54));

A.ambMat(:,16,2) = cellfun(@(x)strcmp(x,uMixed{1}),Q.textdata(2:end,54));
A.ambMat(:,16,3) = cellfun(@(x)strcmp(x,uMixed{4}),Q.textdata(2:end,54));

%% languages

% 5: don't remember accurately

A.field{17} = 'languages';
A.fieldType(17) = 1;

uLang = unique(Q.textdata(2:end,55));

A.ambMat(:,17,7) = cellfun(@(x)strcmp(x,uLang{5}),Q.textdata(2:end,55));

%% geography

% 1: empty

A.field{18} = 'geography';
A.fieldType(18) = 1;

uGeo = unique(Q.textdata(2:end,64));

A.ambMat(:,18,2) = cellfun(@(x)strcmp(x,uGeo{1}),Q.textdata(2:end,64));

%% does Israel appear in novel

A.field{19} = 'Israel';
A.fieldType(19) = 7;

uIsra = unique(Q.textdata(2:end,66));

A.ambMat(:,19,2) = cellfun(@(x)strcmp(x,uIsra{1}),Q.textdata(2:end,66));

%% importance

A.field{20} = 'import.';
A.fieldType(20) = 4;


% 1: *I* don't know
% 3/14/20/26/29/61: contains answer + "don't know"!!!!

impResp = strip(Q.textdata(2:end,76));
uImp = unique(Q.textdata(2:end,76));
impItems = cellfun(@(x)split(x,','),uImp,'UniformOutput',false);
uImpItems = unique(strip(cellflat(impItems)));

% let's see which items in uImp contain uImpItems{1}!!!

p = find(cellfun(@(x)sum(regexp(x,uImpItems{1})~=0),uImp));

A.ambMat(:,20,9) = cellfun(@(x)strcmp(x,uImp{1}),Q.textdata(2:end,76));
A.ambMat(:,20,8) = cellfun(@(x)any(strcmp(x,uImp(p(2:end)))),Q.textdata(2:end,76));

%% tense

A.field{21} = 'tense';
A.fieldType(21) = 4;

% 1: empty
% 6: hard to define

uTense = unique(Q.textdata(2:end,80));

A.ambMat(:,21,2) = cellfun(@(x)strcmp(x,uTense{1}),Q.textdata(2:end,80));
A.ambMat(:,21,3) = cellfun(@(x)strcmp(x,uTense{6}),Q.textdata(2:end,80));

%% 

% FROM HERE ONWARDS, FIELDS THAT HAVEN'T BEEN ANALYSED!!!

%% Genre

A.field{22} = 'genre';
A.fieldType(22) = 8;

load defaultGenres % these are the answers provided in the questionnaire, but responders could also insert free text

genResp = strip(Q.textdata(2:end,22));
uGen = unique(Q.textdata(2:end,22));
genItems = cellfun(@(x)split(x,','),uGen,'UniformOutput',false);
uGenItems = unique(strip(cellflat(genItems)));

% now, let's create a binary vector indicating which elements in uGenItems
% are actually from the original answers provided

A.isGenInList = cell2mat(cellfun(@(x)any(strcmp(x,defGenres)),uGenItems,'UniformOutput',false));

% Problem: I can't know HOW MANY non-listed answers there were, since they
% may contain commas that cause them to be separated. Without resorting to
% manual marking or NLP methods, the best I can do is to measure THE LENGTH
% IN CHARACTERS of the non-listed answers!

for k = 1:D.nItems
    
    genAns = strip(split(genResp{k},','));
    nAns = numel(genAns);
    ansInd = cellfun(@(x)find(strcmp(x,uGenItems)),genAns);
    lenAns = cellfun(@(x)numel(x),genAns);
    lenNonListed = sum(lenAns(~A.isGenInList(ansInd)));
    nIsInList = sum(A.isGenInList(ansInd));
    A.genreList(1,k) = nIsInList; % how many listed genres
    A.genreList(2,k) = lenNonListed; % how many chars in non-listed
    
    A.ambMat(k,22,9) = any(ansInd==9); 
    A.ambMat(k,22,6) = (any(ansInd==12) | any(ansInd==31) | ...
        any(ansInd==50) | any(ansInd==51));
    A.ambMat(k,22,7) = (any(ansInd==17));

end

%% citations

A.field{23} = 'citations';
A.fieldType(23) = 8;

% 1: empty
% 9,49: can't remember
% 18: philosophical quotes I couldn't recognise
% 42: I don't know
% 74: Perhaps (doubt) ("perhaps canonical literature and art")

load defaultCitations

citResp = strip(Q.textdata(2:end,26));
uCit = unique(Q.textdata(2:end,26));
citItems = cellfun(@(x)split(x,','),uCit,'UniformOutput',false);
uCitItems = unique(strip(cellflat(citItems)));

A.isCitInList = cell2mat(cellfun(@(x)any(strcmp(x,defCit)),uCitItems, ...
    'UniformOutput',false));

for k = 1:D.nItems
    
    citAns = strip(split(citResp{k},','));
    nAns = numel(citAns);
    ansInd = cellfun(@(x)find(strcmp(x,uCitItems)),citAns);
    lenAns = cellfun(@(x)numel(x),citAns);
    lenNonListed = sum(lenAns(~A.isCitInList(ansInd)));
    nIsInList = sum(A.isCitInList(ansInd));
    A.citationList(1,k) = nIsInList; % how many listed genres
    A.citationList(2,k) = lenNonListed; % how many chars in non-listed
    
    A.ambMat(k,23,2) = (any(ansInd==1));
    A.ambMat(k,1,9) = any(ansInd==50);
    A.ambMat(k,23,7) = (any(ansInd==9) | any(ansInd==49));

end


%% FIGURE 2A: what types of ambivalence there are

S1 = squeeze(sum(A.ambMat,1));
S2 = squeeze(sum(S1,1));

figure
set(gcf,'color','w','units','centimeters', ...
    'position',[1 1 16 10], ...
    'defaultaxesfontname','arial', ...
    'defaultaxesfontsize',14)

[u,v] = sort(S2);

bar(S2(v),'FaceColor','k','EdgeColor','k')
set(gca,'xtick',1:numel(S2),'XTickLabel',A.ambType(v), ...
    'XTickLabelRotation',45)

box off
set(gca,'TickDir','out')
set(gca,'LineWidth',1.5)
set(gca,'xlim',[0.25 9.75])

ylabel('# of items')

%% FIGURE 2C: matrix of ambivalence / item

figure
set(gcf,'color','w','units','centimeters', ...
    'position',[1 1 24 12], ...
    'defaultaxesfontname','arial', ...
    'defaultaxesfontsize',12)

typeOrd = [4:7 2:3 9 12 1 10 11 13 16 19 8 14 20 21 15 18 22 17 23];

T1 = S1(typeOrd,:);

imagesc(log10(T1'))
set(gca,'ytick',1:numel(S2),'YTickLabel',A.ambType(1:numel(S2)), ...
    'YTickLabelRotation',45)

set(gca,'xtick',1:numel(A.field),'XTickLabel',A.field(typeOrd), ...
    'XTickLabelRotation',50)

myTicks = [1 2 5 10 20 50 100 200];

h = colorbar;
colormap jet

hh = h.Title;
set(hh,'String','# of responses')
set(hh,'Position',[50 115],'Rotation',90,...
    'HorizontalAlignment','center','FontWeight','bold')

set(h,'Ticks',log10(myTicks),'TickLabels', ...
    arrayfun(@(x)num2str(x),myTicks,'UniformOutput',false))

set(gca,'CLim',get(gca,'CLim').*[0 1]+[-0.3 0])

hold on;
[nRows, nCols] = size(S1);

for k = 1:nRows+1
    if any(k-0.5==[4.5 8.5 14.5 18.5])
        plot([k-0.5, k-0.5], [0.5, nCols+0.5], 'w', 'LineWidth', 2.5)
    else
        plot([k-0.5, k-0.5], [0.5, nCols+0.5], 'w', 'LineWidth', 1)
    end
end

for k = 1:nCols+1
    plot([0.5, nRows+0.5], [k-0.5, k-0.5], 'w', 'LineWidth', 1)
end

yy = 0.17;
z = text(2.5,yy,'scaled','HorizontalAlignment','center','FontWeight','bold');
z = text(6.5,yy,'numer','HorizontalAlignment','center','FontWeight','bold');
z = text(11.5,yy,'MC (2-3)','HorizontalAlignment','center','FontWeight','bold');
z = text(16.5,yy,'MC (>3)','HorizontalAlignment','center','FontWeight','bold');
z = text(21,yy,'MC+free','HorizontalAlignment','center','FontWeight','bold');





%% FIGURE 2B: distribution of # of uncertain/ambig. items per questionnaire

nAmbPerQuest = sum(squeeze(sum(A.ambMat,3)),2);
xx = min(nAmbPerQuest):max(nAmbPerQuest);
nn = hist(nAmbPerQuest,xx);

figure
set(gcf,'color','w','units','centimeters', ...
    'position',[1 1 12 10], ...
    'defaultaxesfontname','arial', ...
    'defaultaxesfontsize',14)

plot(xx,nn,'-ok','LineWidth',1.5)

box off
set(gca,'TickDir','out')
set(gca,'LineWidth',1.5)
% set(gca,'xlim',[0.25 9.75])

xlabel('# of uncertain/ambig. items')
ylabel('# of questionnaires')

%% Save the results!

save ambivalenceStruct A


