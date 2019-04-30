switch ALGOSRC
    case "RS"
        %Reset dynamic fields in SH struct
        noo.RandomSearch.init_random_search;
        %Run Random search
        noo.RandomSearch.run_random_search;
    case "HC"
        %Reset dynamic fields in SH struct
        noo.HillClimbing.init_hill_climbing;
        %Run Hill Climbing search
        noo.HillClimbing.run_hill_climbing;
    case "SA"
    otherwise
        error("Specify the Search Algo in ALGOSRC")
end

%Save the results into MCTS struct 
%(needed? yes, to maintain separed MCTS and the underlying search algo)
MCTS.rolloutBestRob = SH.bestRobustness;
MCTS.rolloutBestTrace = SH.bestTrace;
MCTS.rolloutNumSimTraces = SH.numSimulatedTraces;