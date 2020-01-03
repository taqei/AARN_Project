function [bests]=bbo(input,target)
% Biogeography-based optimization (BBO) to minimize a continuous function
% This program was tested with MATLAB R2012b
% Source du script : https://en.wikipedia.org/wiki/Biogeography-based_optimization

GenerationLimit = 2; % generation count limit 
PopulationSize = 5; % population size
ProblemDimension = 7; % number of variables in each solution (i.e., problem dimension)
MutationProbability = 0.04; % mutation probability per solution per independent variable
NumberOfElites = 4; % how many of the best solutions to keep from one generation to the next






% lower bound / upper bound of each element
MinFctActiv=1;
MaxFctActiv=2;
MinFctTrans=1;
MaxFctTrans=3;
MinNbCouche=1;
MaxNbCouche=4;
MinNeurones=1;
MaxNeurones=170;
% Initialize the population
rng(round(sum(100*clock))); % initialize the random number generator
x = zeros(PopulationSize, ProblemDimension); % allocate memory for the population
for index = 1 : PopulationSize % randomly initialize the population
    x(index,1) = randi([MinFctActiv MaxFctActiv]); % fonction d'activation {1,2,3} ["trainrp" "trainscg" "trainlm"]
    x(index,2) = randi([MinFctTrans MaxFctTrans]); % fonction de transfert {1,2,3} ["logsig" "tansig" "purelin"]
    x(index,3) = randi([MinNbCouche MaxNbCouche]); % Nombre de couches {1,2,3,4}
    x(index,4:7) = randi([MinNeurones MaxNeurones],1,4); % Nombre de couches {1,2,3,4}
end
HSI = TrainSol(x,input,target); % compute the cost of each individual  
[x, HSI] = PopulationSort(x, HSI); % sort the population from best to worst

BestsHSI = zeros(GenerationLimit, 1); % allocate memory
BestsHSI(1) = HSI(1); % save the best cost at each generation in the BestsHSI array
disp(['Generation 0 max Hsi = ', num2str(BestsHSI(1))]);
z = zeros(PopulationSize, ProblemDimension); % allocate memory for the temporary population

% Compute migration rates, assuming the population is sorted from most fit to least fit
mu = (PopulationSize + 1 - (1:PopulationSize)) / (PopulationSize + 1); % emigration rate
lambda = 1 - mu; % immigration rate

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
                        z(k,1) = randi([MinFctActiv MaxFctActiv]);
                    case 2
                        z(k,2) = randi([MinFctTrans MaxFctTrans]);
                    case 3
                        z(k,3) = randi([MinNbCouche MaxNbCouche]);
                    case 4
                        z(k,4) = randi([MinNeurones MaxNeurones]);
                    case 5
                        z(k,5) = randi([MinNeurones MaxNeurones]);
                    case 6
                        z(k,6) = randi([MinNeurones MaxNeurones]);
                    case 7
                        z(k,7) = randi([MinNeurones MaxNeurones]);
                end
                 
            end
        end
    end

    x = z; % replace the solutions with their new migrated and mutated versions
    HSI = TrainSol(x,input,target); % calculate HSI
    [x, HSI] = PopulationSort(x, HSI); % sort the population and costs from best to worst

    for k = 1 : NumberOfElites % replace the worst individuals with the previous generation's elites
        x(PopulationSize-k+1, :) = EliteSolutions(k, :);
        HSI(PopulationSize-k+1) = EliteCosts(k);
    end

    [x, HSI] = PopulationSort(x, HSI); % sort the population and costs from best to worst
    BestsHSI(Generation+1) = HSI(1);
    disp(['Generation ', num2str(Generation), ' max HSI = ', num2str(BestsHSI(Generation+1))])
end

% Wrap it up by displaying the best solution and by plotting the results
disp(['Best solution found = ', num2str(x(1, :))])
bests=[x(:,:),HSI(:)];


plot(0:GenerationLimit, BestsHSI);
xlabel('Generation')
ylabel('Best HSI')
return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [x,HSI] = PopulationSort(x, HSI)
% Sort the population and costs from best to worst
[HSI, indices] = sort(HSI, 'descend');
x = x(indices, :);
return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [HSI] = TrainSol(x,input,target)
% Compute the Rosenbrock function value of each element in x
NumberOfDimensions = size(x, 2);
HSI = zeros(size(x, 1), 1); % allocate memory for the Cost array
for PopulationIndex = 1 : 5
    HSI(PopulationIndex) = 0;
    [ne,t,h]=trainASol(x(PopulationIndex,:),input,target,3,'mattests');
    HSI(PopulationIndex)=h;
end
return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
