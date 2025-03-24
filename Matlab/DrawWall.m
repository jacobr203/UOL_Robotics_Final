
%don't want to call this while we run the app
gridData = gridData;
gridData(326:464,264) = 0.999000012874603;
gridData(294:465,256:263) = 0.500026345252991;
gridData(175:230,347) = 0.999000012874603;
gridData(175:230,348:349) = 0.00100000004749745;

imagesc(gridData);  
gridData2 = gridData(170:470,260:415);
imagesc(gridData2);  




[counts1, edges] = histcounts(bla(:), 'Normalization', 'probability');
[counts2, ~] = histcounts(map2(:), 'Normalization', 'probability');
similarity_score = 1 - sum(abs(counts1 - counts2)); % Closer to 1 is more similar