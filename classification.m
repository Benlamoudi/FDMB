clear all,clc;
load('FirstImpressionsV2.mat')
train = 1:6000;
valid = 6001:8000;
representation={'block','level'};
for num_lvl = 7%1:10
for winsize = 3%[3 7 9]
for F =1%:size(representation,2);
for pas = 1
load(['Feature/LPQ_',num2str(representation{F}),'_FD_',num2str(num_lvl),'_128_',num2str(pas),'_1_',num2str(winsize),'_1_1_Grey_1.mat'])
FTRS_TR = FTRS(train,:);

FTRS_VL = FTRS(valid,:);


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

%SVR.extraversion = fitrlinear(features(train,:),extraversion.ground_truth(train));
SVR.extraversion = fitrsvm(FTRS_TR,extraversion.ground_truth(train),'KernelFunction','gaussian','KernelScale','auto','Standardize',true);
extraversion.estimated(valid) = predict(SVR.extraversion,FTRS_VL);

%SVR.neuroticism = fitrlinear(features(train,:),neuroticism.ground_truth(train));
SVR.neuroticism = fitrsvm(FTRS_TR,neuroticism.ground_truth(train),'KernelFunction','gaussian','KernelScale','auto','Standardize',true);
neuroticism.estimated(valid) = predict(SVR.neuroticism,FTRS_VL);

%SVR.agreeableness = fitrlinear(features(train,:),agreeableness.ground_truth(train));
SVR.agreeableness = fitrsvm(FTRS_TR,agreeableness.ground_truth(train),'KernelFunction','gaussian','KernelScale','auto','Standardize',true);
agreeableness.estimated(valid) = predict(SVR.agreeableness,FTRS_VL);

%SVR.conscientiousness = fitrlinear(features(train,:),conscientiousness.ground_truth(train));
SVR.conscientiousness = fitrsvm(FTRS_TR,conscientiousness.ground_truth(train),'KernelFunction','gaussian','KernelScale','auto','Standardize',true);
conscientiousness.estimated(valid) = predict(SVR.conscientiousness,FTRS_VL);

%SVR.openness = fitrlinear(features(train,:),openness.ground_truth(train));
SVR.openness = fitrsvm(FTRS_TR,openness.ground_truth(train),'KernelFunction','gaussian','KernelScale','auto','Standardize',true);
openness.estimated(valid) = predict(SVR.openness,FTRS_VL);

%SVR.interview = fitrlinear(features(train,:),interview.ground_truth(train));
SVR.interview = fitrsvm(FTRS_TR,interview.ground_truth(train),'KernelFunction','gaussian','KernelScale','auto','Standardize',true);
interview.estimated(valid) = predict(SVR.interview,FTRS_VL);

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
name = sprintf('results/RBF_LPQ_%s_FD_%d_128_%d_1_%d_1_1_Grey_1',representation{F},num_lvl,pas,winsize);
save(sprintf('%s.mat',name),'pred_i','pred_a','pred_c','pred_e','pred_n','pred_o');
clear features;
fprintf('%s \n',name);
end
end
end
end