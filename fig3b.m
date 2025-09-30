
%% Initialise and import data

clear
close all hidden

load ambivalenceMatrix

load allData250203

load anonID

%%

% identify unique readers

idInd = arrayfun(@(k)find(ID==k),1:nID,'UniformOutput',false);
nPerID = cellfun(@(x)numel(x),idInd); % # of titles read by each unique ID

minPerTitle = 3; % We only analyse readers with >= 3 titles

pID = find(nPerID >= minPerTitle); % indices to good TITLES; still not indices to good READINGS

nGoodID = numel(pID); % # of readers with >= 3 titles

pRead = arrayfun(@(k)find(ID==k),pID,'UniformOutput',false);
nReads = cellfun(@(x)numel(x),pRead);
nTot = sum(nReads); % number of questionnaires of ID's with >= 3 readings

%% global statistics of ambivalence

ambPerRead = sum(squeeze(sum(ambMat,2)),2);

muAmbGlob = mean(ambPerRead); % global mean ambivalence
sdAmbGlob = std(ambPerRead); % global STD of ambivalence

%% real statistics of ambivalence per ID

for k = 1:nGoodID

    muAmb(k) = mean(ambPerRead(pRead{k}));
    sdAmb(k) = std(ambPerRead(pRead{k}));

end


%% permutation test statistics of ambivalence per title

nBoot = 10000;

pVec = cell2mat(pRead);
ambLim = ambPerRead(pVec);

ind0 = [1 cumsum(nReads(1:end-1))+1];
ind1 = cumsum(nReads)';

bootMatMu = zeros(nBoot,nGoodID);
bootMatSd = zeros(nBoot,nGoodID);

for k = 1:nBoot

    permAmb = ambLim(randperm(nTot));

    myA = arrayfun(@(k)permAmb(ind0(k):ind1(k)),1:nGoodID,'UniformOutput',false);

    bootMatMu(k,:) = cellfun(@(x)mean(x),myA);
    bootMatSd(k,:) = cellfun(@(x)std(x),myA);

end

%% calculating p-value for mean sdAmb: where is it within the permutation test statistics?

statOrig = mean(sdAmb); % the real-data statistic (the mean, across all readers, of the STD of ambivalence of each reader across their titles)
statBoot = mean(bootMatSd,2); % the permutation test statistics (the mean, across all permuted 'readers', of the STD...)

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
set(gca,'Xlim',[0.9 1.4],'xtick',[0.9:0.1:1.4])
set(gca,'ylim',[0 0.035],'YTick',[0:0.01:0.04])

plot([1 1]*statOrig,get(gca,'ylim'),'r--','LineWidth',2)

xlabel('$<\widehat{\sigma}_{amb}>$', 'Interpreter', 'latex')
% xlabel('\sigma_{amb}','Interpreter','tex')
ylabel('Frequency')

pValue = sum(statBoot<=statOrig)/10000;
fprintf(['p=' num2str(pValue,2) '\n'])

