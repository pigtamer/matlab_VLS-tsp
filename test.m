%%
clear all, clc, close all

tic

load 'test-data.mat'
global ROUTE
global cityCell
global COST
global topFlag

cityCell={};
ROUTE = [];
COST = 0;
topFlag=1;
NUM_TYPES = 10;

% % Uniform
% nSizeIn = 10000;
% swarm = 100*rand(nSizeIn, 2);

% Gaussian
scale = 20; pm = 40; genrd = 20;
swarm = genData(genrd, scale, pm);


swarm = [swarm, (1:length(swarm))']; % this is the original ids

% from downloaded fatum
swarm = ja9847;

% viewSwarm(swarm(:, 1), swarm(:, 2), lbl)

layer = swarm;
tmpCenters = zeros(length(layer), 1);
% calc a list centers of all the subsets, for linprog of current
% layer
if iscell(layer)
    for k = 1:numel(layer)
        tmpCenters(k) = [mean(layer{k}(:, 1:2)), layer{k}(:, 3)]; % layer{k} must be col vector
    end
else % input data, as a single vector
    tmpCenters = layer;
end
[nxtIdx, Centr] = kmeans(tmpCenters(:, 1:2), NUM_TYPES, 'Distance','sqeuclidean',...
            'Replicates',10,'Options',statset('Display','final'));

%%
logicImp(swarm, NUM_TYPES,100);

toc
%%
figure(221)


route = [];
for i =1:length(cityCell)
    route=[route;cityCell{i}];
end

MarkSwarm(route(:, 1:2), Centr, nxtIdx, 'k', 'v', 8)
% scatter(route(:, 1), route(:, 2))
hold on;
plot(route(:, 1), route(:, 2))
title("Lowest level of cells")

% figure(222)
% MarkSwarm(route(:, 1:2), Centr, nxtIdx, 'k', 'v', 8)
% % scatter(route(:, 1), route(:, 2))
% hold on;
% plot(route(:, 1), route(:, 2))

%%
COST = 0;
for k = 1:rows(route) - 1
    COST = COST + sqrt(sum((route(k+1, 1:2) - route(k, 1:2)) .^2));
end

% % the struct data is to be made by hand.
% err = COST - swarm.opt.length / swarm.opt.length;