%% Initialize/Reset MCTS struct
% Pre:  `Sim`struct must exist
% Post: `MCTS` struct exist and is initialized with root node

% Build the tree structure
MCTS.availID = 1;   
root = MCNode(MCTS.availID, 0, [-1 -1], [-1 -1], 0); %The root is the only node with parent 0 and depth 0
MCTS.nodes = [root];        %Nodes collection
MCTS.currentNodeID = 0;     %Initially, I am placed in the (only) root node
MCTS.availID = MCTS.availID + 1; %Increment next availablplote node identifier

%It is the max robustness in the whole tree (used in UCB computation)
MCTS.maxRobustness = -Inf;  

% Rollout result variables
MCTS.rolloutBestRob = Inf;  
MCTS.rolloutBestTrace = zeros(Sim.NUMCTRLPOINTS, Sim.NUMINPUTSIGNALS);