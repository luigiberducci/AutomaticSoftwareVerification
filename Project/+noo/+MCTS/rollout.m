%Reset dynamic fields in SH struct
noo.RandomSearch.init_random_search;

%Run Hill Climbing search
noo.RandomSearch.run_random_search;

%Save the results into MCTS struct 
%(needed? yes, to maintain separed MCTS and the underlying search algo)
MCTS.rolloutBestRob = SH.bestRobustness;
MCTS.rolloutBestTrace = SH.bestTrace;
MCTS.rolloutNumSimTraces = SH.numSimulatedTraces;