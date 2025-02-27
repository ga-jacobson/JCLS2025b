
clear
close all hidden

% for now, this uses nReaders >= 3; if necessary, 
% update parameters in .m file limitNReadings.m
load allData250203

%%

% 1. analyse these for all readings 

% 1: conventional-experimental
M = D.convVSexp;
% 3: gaps
M = [M D.gaps];
% 6: register (low-high)
% ensure only NaNs after henSpeak==true are considered!!!
p = find(isnan(D.register) & D.hebSpeak);
myReg = zeros(size(D.register));
myReg(p) = NaN;
nIsHebSpoken = sum(D.hebSpeak==1);
M = [M myReg];
% 7: intertextuality
M = [M D.interTxt];

columnStr = {'conv.-exp.','gaps','register (l-h)','intertext.'};

%% FIGURE 1A: questions unanswered / could not answer, sorted by # NaN


nNanAns = sum(isnan(M));
probNaN = nNanAns./[D.nItems D.nItems nIsHebSpoken D.nItems];

figure

set(gcf,'color','w','units','centimeters', ...
    'position',[1 1 12 10], ...
    'defaultaxesfontname','arial', ...
    'defaultaxesfontsize',12)

[v,o] = sort(nNanAns);
bar(probNaN(o)*100,'FaceColor','k','EdgeColor','k')

probNaN = nNanAns/D.nItems;

set(gca,'xtick',1:size(M,2),'XTickLabel',columnStr(o), ...
    'XTickLabelRotation',45)

box off
set(gca,'TickDir','out','LineWidth',1.5)

% title('Unanswered scaled items')
ylabel('% of readings')

%% FIGURE 1B: compute probability of having k unanswered questions using marginals and compare to read data

nScale = numel(probNaN);

allOrders = perms(1:nScale);

binSubSet = dec2bin(0:(2^nScale-1),nScale);

Q = arrayfun(@(k)sscanf(binSubSet(k,:),repmat('%1d',1,4))', ...
    1:size(binSubSet,1),'UniformOutput',false);
Q = cell2mat(Q');

for k = 0:nScale
        
    pRow = find(sum(Q')==k);
    
    probEachCase = arrayfun(@(m)prod([probNaN(Q(m,:)==1) ...
        1-probNaN(Q(m,:)==0)]), ...
        pRow);
    
    probNofNan(k+1) = sum(probEachCase);
    
end

figure

set(gcf,'color','w','units','centimeters', ...
    'position',[1 1 12 10], ...
    'defaultaxesfontname','arial', ...
    'defaultaxesfontsize',12)

nNanPerReader = sum(isnan(M'));

xN = 0:4;
nn = hist(nNanPerReader,xN);
pExp = nn/D.nItems;

plot(xN(1:5),pExp(1:5),'-o','linewidth',1.5)
hold on

plot(xN(1:5),probNofNan(1:5),'-o','linewidth',1.5)

box off
set(gca,'YScale','log')


xlabel('# of unanswered questions')
ylabel('Probability')

% title('Unanswered questions across readings')

box off
set(gca,'TickDir','out')
set(gca,'LineWidth',1.5)

h = legend({'Data','Analyt. fit'},'Location','southwest');



%% FIGURE 1C: number of unanswered items as a function of "ease to characterise"

xN = 0:3; % all scores of 4 were for readings with "ease of char."==NaN

p = arrayfun(@(k)find(D.easeChar==k),1:5,'UniformOutput',false);

unansMat = cellfun(@(x)sum(isnan(M(x,:)')),p,'UniformOutput',false);
nPerScore = arrayfun(@(x)numel(x{1}),p);
nnMat = cellfun(@(x)hist(x,xN),unansMat,'UniformOutput',false);

unansPerScore = cell2mat(nnMat');
pUnans = unansPerScore'./nPerScore

% mean unanswered per questionnaire

meanBlankPerQuest = sum(unansPerScore(:,2:end)'.*(1:3)')./nPerScore;

figure

set(gcf,'color','w','units','centimeters', ...
    'position',[1 1 12 10], ...
    'defaultaxesfontname','arial', ...
    'defaultaxesfontsize',12)

bar(1:5,meanBlankPerQuest,'FaceColor','k','EdgeColor','k')

set(gca,'xtick',1:5,'XTickLabel',{'1:Easy','2','3','4','5:Difficult'})

box off
set(gca,'TickDir','out')
set(gca,'LineWidth',1.5)

xlabel('Ease of characterisation')
ylabel('Number of unanswered questions')

% title({'Mean unanswered questions per reading', ...
%     'as function of ease of characterisation'})
