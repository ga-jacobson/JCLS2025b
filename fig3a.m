
%%

clear
close all hidden

load ambivalenceMatrix

load allData250203

%% find unique titles and analyse only those with >=3 questionnaires

U.uTitle = unique(D.title);
U.nTitle = numel(U.uTitle);
U.bookInd = cellfun(@(x)find(strcmp(D.title,x)),U.uTitle,'UniformOutput',false);
U.nPerTitle = cellfun(@(x)sum(strcmp(D.title,x)),U.uTitle);

U.pubYear = arrayfun(@(k)min(D.pubYear(U.bookInd{k})),1:U.nTitle);

U.minPerTitle = 3;

pTit = find(U.nPerTitle >= U.minPerTitle); % indices to good TITLES; still not indices to good READINGS

U.nGoodTitles = numel(pTit);

pRead = cellfun(@(x)find(strcmp(D.title,x)),U.uTitle(pTit),'UniformOutput',false);
nReads = cellfun(@(x)numel(x),pRead);
nTot = sum(nReads); % number of readings of books with >= 3 readings

%% global statistics of ambivalence

ambPerRead = sum(squeeze(sum(ambMat,2)),2);

muAmbGlob = mean(ambPerRead);
sdAmbGlob = std(ambPerRead);

%% real statistics of ambivalence per title

for k = 1:U.nGoodTitles

    muAmb(k) = mean(ambPerRead(pRead{k}));
    sdAmb(k) = std(ambPerRead(pRead{k}));

end


%% permutation test statistics of ambivalence per title

nBoot = 10000;

pVec = cell2mat(pRead);
ambLim = ambPerRead(pVec);

ind0 = [1 cumsum(nReads(1:end-1)')+1];
ind1 = cumsum(nReads)';

bootMatMu = zeros(nBoot,U.nGoodTitles);
bootMatSd = zeros(nBoot,U.nGoodTitles);

for k = 1:nBoot

    permAmb = ambLim(randperm(nTot));

    myA = arrayfun(@(k)permAmb(ind0(k):ind1(k)),1:U.nGoodTitles,'UniformOutput',false);

    bootMatMu(k,:) = cellfun(@(x)mean(x),myA);  % the real-data statistic (the mean, across all titles, of the STD of ambivalence of each title across its readers)
    bootMatSd(k,:) = cellfun(@(x)std(x),myA); % the permutation test statistics (the mean, across all permuted 'titles', of the STD...)

end

%% sum permutation test statistics, compare to read data, plot and calculate p-value

statBoot = mean(bootMatSd,2);
statOrig = mean(sdAmb);

figure
set(gcf,'color','w','units','centimeters', ...
    'position',[1 1 12 10], ...
    'defaultaxesfontname','arial', ...
    'defaultaxesfontsize',16)


[nn,xx] = hist(statBoot,100);
nn = nn / sum(nn);
bar(xx,nn,'FaceColor','k','EdgeColor','k')

box off

hold on


set(gca,'TickDir','out')
set(gca,'Xlim',[1.1 1.6],'xtick',[1.1:0.1:1.6])
set(gca,'ylim',[0 0.035],'YTick',[0:0.01:0.04])

plot([1 1]*statOrig,get(gca,'ylim'),'r--','LineWidth',2)

xlabel('$<\widehat{\sigma}_{amb}>$', 'Interpreter', 'latex')
% xlabel('\sigma_{amb}','Interpreter','tex')
ylabel('Frequency')

pValue = sum(statBoot<=statOrig)/10000;
fprintf(['p=' num2str(pValue,2) '\n'])

