function [m,rm,p,rp,BetterComportement,mb,rmb,pb,rpb] = classify(x)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
input=encode([x,0]);
% COmportement 0
comportementinit=zeros(1,5);
comportementinit(1)=input(14,1);% study time
comportementinit(2)=input(16,1);% schoolsup
comportementinit(3)=input(26,1);% goout
comportementinit(4)=input(27,1);% dalc
comportementinit(5)=input(28,1);% walc
% calculating init predictions and hsi0
[hsiInit,m,rm,p,rp] = classifyAComportement(comportementinit,comportementinit,input);

% BBO 
GenerationLimit = 2; % generation count limit 
PopulationSize = 7; % population size
ProblemDimension = 5; % number of variables in each solution (i.e., problem dimension)
MutationProbability = 0.04; % mutation probability per solution per independent variable
NumberOfElites = 4; % how many of the best solutions to keep from one generation to the next

MinStudy=1;
MaxStudy=4;
MinSchoolSup=0;
MaxSchoolSup=1;
MinGoOut=1;
MaxGoOut=5;
MinAlc=1;
MaxAlc=5;
rng(round(sum(100*clock))); % initialize the random number generator
x = zeros(PopulationSize, ProblemDimension); % allocate memory for the population

for index = 1 : PopulationSize % randomly initialize the population
    x(index,1) = randi([MinStudy MaxStudy]); 
    x(index,2) = randi([MinSchoolSup MaxSchoolSup]); 
    x(index,3) = randi([MinGoOut MaxGoOut]); 
    x(index,4) = randi([MinAlc MaxAlc]);
    x(index,5) = randi([MinAlc MaxAlc]);
end

HSI =calculateHSI(x,comportementinit,input);
[x, HSI] = PopulationSort(x, HSI);
BestsHSI = zeros(GenerationLimit, 1);
BestsHSI(1) = HSI(1);
z = zeros(PopulationSize, ProblemDimension);
mu = (PopulationSize + 1 - (1:PopulationSize)) / (PopulationSize + 1); 
lambda = 1 - mu;
for Generation = 1 : GenerationLimit
    % Save the best solutions and costs in the elite arrays
    EliteSolutions = x(1 : NumberOfElites, :);
    EliteCosts = HSI(1 : NumberOfElites);

    % Use migration rates to decide how much information to share between solutions
    for k = 1 : PopulationSize
        % Probabilistic migration to the k-th solution
        for j = 1 : ProblemDimension

            if rand < lambda(k) % Should we immigrate?
                % Yes - Pick a solution from which to emigrate (roulette wheel selection)
                RandomNum = rand * sum(mu);
                Select = mu(1);
                SelectIndex = 1;
                while (RandomNum > Select) && (SelectIndex < PopulationSize)
                    SelectIndex = SelectIndex + 1;
                    Select = Select + mu(SelectIndex);
                end
                z(k, j) = x(SelectIndex, j); % this is the migration step
            else
                z(k, j) = x(k, j); % no migration for this independent variable
            end

        end
    end

    % Mutation
    for k = 1 : PopulationSize
        for ParameterIndex = 1 : ProblemDimension
            if rand < MutationProbability
                
                switch ParameterIndex
                    case 1
                        z(k,1) = randi([MinStudy MaxStudy]); 
                    case 2
                        z(k,2) = randi([MinSchoolSup MaxSchoolSup]); 
                    case 3
                        z(k,3) = randi([MinGoOut MaxGoOut]);
                    case 4
                        z(k,4) = randi([MinAlc MaxAlc]);
                    case 5
                        z(k,5) = randi([MinAlc MaxAlc]);
                  
                end
                 
            end
        end
    end

    x = z; % replace the solutions with their new migrated and mutated versions
    HSI = calculateHSI(x,comportementinit,input); % calculate HSI
    [x, HSI] = PopulationSort(x, HSI); % sort the population and costs from best to worst

    for k = 1 : NumberOfElites % replace the worst individuals with the previous generation's elites
        x(PopulationSize-k+1, :) = EliteSolutions(k, :);
        HSI(PopulationSize-k+1) = EliteCosts(k);
    end

    [x, HSI] = PopulationSort(x, HSI); % sort the population and costs from best to worst
    BestsHSI(Generation+1) = HSI(1);
    
end
BetterComportement=x(1, :);
[hsiee,mb,rmb,pb,rpb]=classifyAComportement(BetterComportement,comportementinit,input);
return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [min,rmin,pin,rpin] = classifyAnInput(in)
matnet=struct2cell(load('net221013.mat','bestnet'));
matnet=matnet{1};
y=matnet(in);
for i=1:6
  y(i,1)=y(i,1)/sum(y(:,1));
end
[rmin,min]=max(y(:,1));
pornet=struct2cell(load('net221073.mat','bestnet'));
pornet=pornet{1};
z=pornet(in);
for i=1:6
  z(i,1)=z(i,1)/sum(z(:,1));
end
[rpin,pin]=max(z(:,1));
return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [hsi,mc,rmc,pc,rpc] = classifyAComportement(comportement,comportementinit,input)
in=input;
in(14,1)=comportement(1);% study time
in(16,1)=comportement(2);% schoolsup
in(26,1)=comportement(3);% goout
in(27,1)=comportement(4);% dalc
in(28,1)=comportement(5);% walc
[mc,rmc,pc,rpc]=classifyAnInput(in);

X=[comportement;comportementinit];
d = pdist(X,'euclidean');
hsi=((6-mc)*rmc)+((6-pc)*rpc);
hsi=hsi/d;
return
%%%%%
function [HSI]= calculateHSI(comportements,comportementinit,input)
HSI = zeros(size(comportements, 1), 1);
for PopulationIndex = 1 : length(comportements)
    HSI(PopulationIndex) = 0;
    [hsi,mc,rmc,pc,rpc]=classifyAComportement(comportements(PopulationIndex,:),comportementinit,input);
    HSI(PopulationIndex)=hsi;
end
return

function [x,HSI] = PopulationSort(x, HSI)
% Sort the population and costs from best to worst
[HSI, indices] = sort(HSI, 'descend');
x = x(indices, :);
return
