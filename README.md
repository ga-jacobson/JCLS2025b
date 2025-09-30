# JCLS2025a
data (EXCEL) and code (Matlab 2024b) for JCLS submission 


**Data**
**240813 - Key Novel Dataset - 9 - removed pilot entries.xlsx**
This file has been manually pre-processed to remove pilot questionnaires (that were incomplete) and fix other errors such as incorrect spelling of book names and authors. In addition, we manually added a pair of columns (author 2 and gender of author 2) to enable us to deal with books with two authors, in which it was impossible to identify either because they were combined.

**Data extraction code**
**extractTables2.m**
This code reads the excel file and generates the necessary data structure in variable D, then saved in the Matlab data file
**allData250203.mat**

**fig1_ambigScale.m**
Further analysis of scaled items and generation of figures 1A-C.

**fig2_modesOfAmbivalence.m**
Futher analysis of ambivalent items and generation of figures 2A-C.

**fig3a.m**
Analyses whether the identity of the book/title affects the degree of ambivalence reported by readers.

**fig3b.m**
Analyses whether the reader identity affects the degree of ambivalence reported across all questionnaires of that reader.

**Accessory code**

1. **directPoissonBinomial.m**
   A self-written function to calculate the Poisson-Binomial distribution.
   Input:   p - a vector of n elements containing the probability of success for each Bernoulli trial.
            k - the number of successful Bernoulli trials (irrespective of position).
   Output:  prob - the probability of achieving exactly k successful trials

2. **cellflat**
   A helper function to flatten nested cell arrays.
   Input:   celllist - a cell array to be flattened
            n - an optional input, limiting the number of flattened levels to n.
   Output:  out - a flattened cell array

**Accessory data structures**

These are used to analyse some of the questionnaire items, by providing a table that allows translation between answer and some number / vector that can be used for analysis. Most of them are irrelevant for the current manuscript, but are necessary for the code to run. Included are:

1. **charNumKey.mat**
   Used for transforming the verbal answers into a number of main characters (first column) and secondary characters (second columns). Numbers in the range 0-4 should be interpreted literally. 10 encodes "several" and variations thereof, and 100 encodes "many" and variations thereof.

2. **defaultCitations.mat**
   The item asking about sources cited in the novel has both multiple choices and an open field. This data structure contains the pre-set multiple choices.

3. **defaultGenres.mat**
   The item asking about genre types has both multiple choices and an open field. This data structure contains the pre-set multiple choices.

4. **evtNumKey.mat**
   Number of key events in novel. This item contains both pre-set multiple choice and free text, and has to be translated into numbers. As before, 10 denotes "several" and variations thereof, 100 denotes "many" and 
   variations thereof.

5. **geoData.mat**
   Contains a data structure generated manually with all the 63 geographical entities that are given as answers in the item about geographical locations mentioned in the novel. Contains two data structures:
   geoEntity - a 5x63 cell array, with each column providing the continent/region/country/city/entity corresponding to one possible answer. Region: e.g. SE Asia, W Europe, ... Entity: e.g. military base. If the answer 
   included only a continent, rows 2-5 will be empty. But if only a city was mentioned, the column will contain rows 1-4 and only row 5 will be empty.
   geoHier - a 9x63 binary matrix. Rows 1-5 indicate whether the entity corresponds to one of the above positions in the hierarchy. Rows 7-9 correspond to the following 3 categories: (7) undefined territory; (8) historic entity (e.g. Babylonian empire); (9) unrealistic entity (e.g. fictional island)

6. **importData.mat**
   Translates multiple choice answers about the impotrance of the novel into binary categories defined by us.

7. **languagesUsed.mat**
   Translates user free text answers into a code that can be analysed.

8. **anonID.mat**
   Contains the anonymised ID of the reader, encoded as a number.
 
