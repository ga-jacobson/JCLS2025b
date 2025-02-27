
clear
close all hidden

load allData250203

U.uTitle = unique(D.title);
U.nTitle = numel(U.uTitle);
U.bookInd = cellfun(@(x)find(strcmp(D.title,x)),U.uTitle,'UniformOutput',false);
U.nPerTitle = cellfun(@(x)sum(strcmp(D.title,x)),U.uTitle);

U.pubYear = arrayfun(@(k)min(D.pubYear(U.bookInd{k})),1:U.nTitle);

U.minPerTitle = 3;

pTit = find(U.nPerTitle >= U.minPerTitle); % indices to good TITLES; still not indices to good READINGS

U.nGoodTitles = numel(pTit);

pRead = cellfun(@(x)find(strcmp(D.title,x)),U.uTitle(pTit),'UniformOutput',false);

% structure type 1: structure for each BOOK with >= minPerTitle readings!!!

for k = 1:U.nGoodTitles
    
    % book data
    X(k).title = D.title{pRead{k}(1)};
    X(k).author = D.author1{pRead{k}(1)}; % no books with > 2 readings with 2 authors
    X(k).nReads = numel(pRead{k});
    X(k).gender = D.gender1{pRead{k}(1)};
    X(k).pubYear = D.pubYear(pRead{k});
    X(k).nPages = D.nPages(pRead{k});    
    
    % book quantitative
    X(k).convVSexp = D.convVSexp(pRead{k});
    X(k).isDivSect = D.isDivSect(pRead{k});
    X(k).isDivChap = D.isDivChap(pRead{k});
    X(k).lenDiv = D.lenDiv(pRead{k});
    X(k).narratRel = D.narratRel(pRead{k});
    X(k).narratType = D.narratType(pRead{k});
    X(k).nCharMain = D.nCharMain(pRead{k});
    X(k).nCharSec = D.nCharSec(pRead{k});
    X(k).isNest = D.isNest(pRead{k});
    X(k).whereExp = D.whereExp(pRead{k});
    X(k).pace = D.pace(pRead{k});
    X(k).gaps = D.gaps(pRead{k});
    X(k).nEvt = D.nEvt(pRead{k});
    X(k).surp = D.surp(pRead{k});
    X(k).open = D.open(pRead{k});
    X(k).hebSpeak = D.hebSpeak(pRead{k});
    X(k).register = D.register(pRead{k});
    X(k).isMixedReg = D.isMixedReg(pRead{k});
    X(k).whichLang = D.whichLang(pRead{k});
    X(k).interTxt = D.interTxt(pRead{k});
    X(k).howReadable = D.howReadable(pRead{k});
    X(k).chronScore = D.chronScore(pRead{k});
    X(k).geoID = D.geoAnalysis.ID(pRead{k});
    X(k).israRole = D.israRole(pRead{k});
    X(k).loveTheme = D.loveTheme(pRead{k});
    X(k).warTheme = D.warTheme(pRead{k});
    X(k).import = D.import(pRead{k});
    X(k).easeChar = D.easeChar(pRead{k});
    X(k).tense = D.tense(pRead{k});
    X(k).ambigTense = D.ambigTense(pRead{k});
    X(k).mixedTense = D.mixedTense(pRead{k});  
    
end

save MultipleReadings250203 X U D

