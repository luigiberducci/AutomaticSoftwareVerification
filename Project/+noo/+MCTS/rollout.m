%Reset dynamic fields in HC struct
noo.HillClimbing.init_hill_climbing;

%Run Hill Climbing search
noo.HillClimbing.run_hill_climbing;

%Save the results into MCTS struct 
%(needed? yes, to maintain separed MCTS and the underlying search algo)
MCTS.rolloutBestRob = HC.bestRobustness;
MCTS.rolloutBestTrace = HC.bestTrace;
MCTS.rolloutNumSimTraces = HC.numSimulatedTraces;