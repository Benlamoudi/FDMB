clear all,clc;
load('FirstImpressionsV2.mat')
train = 1:6000;
valid = 6001:8000;
representation={'block','level'};
for num_lvl = 7
for winsize = 3
for F =1%:size(representation,2)
load(['Feature/LPQ_',num2str(representation{F}),'_FD_',num2str(num_lvl),'_128_25_1_',num2str(winsize),'_1_1_Grey_1.mat'])
features = FTRS;clear FTRS;
for i=1:numel(data)
    extraversion.ground_truth(i) = data(i).extraversion;
    extraversion.estimated(i) = 0;
    neuroticism.ground_truth(i) = data(i).neuroticism;
    neuroticism.estimated(i) = 0;
    agreeableness.ground_truth(i) = data(i).agreeableness;
    agreeableness.estimated(i) = 0;
    conscientiousness.ground_truth(i) = data(i).conscientiousness;
    conscientiousness.estimated(i) = 0;
    openness.ground_truth(i) = data(i).openness;
    openness.estimated(i) = 0;
    interview.ground_truth(i) = data(i).interview;
    interview.estimated(i) = 0;
end

SVR.extraversion = fitrlinear(features(train,:),extraversion.ground_truth(train));
extraversion.estimated(valid) = predict(SVR.extraversion,features(valid,:));

SVR.neuroticism = fitrlinear(features(train,:),neuroticism.ground_truth(train));
neuroticism.estimated(valid) = predict(SVR.neuroticism,features(valid,:));

SVR.agreeableness = fitrlinear(features(train,:),agreeableness.ground_truth(train));
agreeableness.estimated(valid) = predict(SVR.agreeableness,features(valid,:));

SVR.conscientiousness = fitrlinear(features(train,:),conscientiousness.ground_truth(train));
conscientiousness.estimated(valid) = predict(SVR.conscientiousness,features(valid,:));

SVR.openness = fitrlinear(features(train,:),openness.ground_truth(train));
openness.estimated(valid) = predict(SVR.openness,features(valid,:));

SVR.interview = fitrlinear(features(train,:),interview.ground_truth(train));
interview.estimated(valid) = predict(SVR.interview,features(valid,:));

j = 1;
for i=valid(1):valid(end)
    pred_i(j)= interview.estimated(i);
    pred_a(j) = agreeableness.estimated(i);
    pred_c(j) = conscientiousness.estimated(i);
    pred_e(j) = extraversion.estimated(i);
    pred_n(j) = neuroticism.estimated(i);
    pred_o(j) = openness.estimated(i);
    j = j + 1;
end
name = sprintf('results/LPQ_%s_FD_%d_128_25_1_%d_1_1_Grey_1',representation{F},num_lvl,winsize);
save(sprintf('%s.mat',name),'pred_i','pred_a','pred_c','pred_e','pred_n','pred_o','-v7.3');
clear features;
fprintf('%s \n',name);
end
end
end