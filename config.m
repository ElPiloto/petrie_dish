
global args;
args = {};
global FEMALE;
FEMALE = 1;
global MALE;
MALE = 2;

args.num_people = 50;
args.num_conversations = 500;
args.num_simulations = 1000;
args.rng_seed = 102387; % may or may not be my birthday, deal with it

% format: list the item's we're selecting over e.g. X
% list prob_X as the probability of choosing item X
args.genders = [FEMALE MALE];
args.prob_gender = [0.2 0.8];

args.percent_sexist_remarks_by_gender = {[0 20 40 60 80 100], [0 20 40 60 80 100]};
args.prob_percent_sexist_remarks_by_gender = {[50 10 10 10 10 10], [50 10 10 10 10 10]};

args.conversation_sizes = [2 3 4 5 6 7 8];
args.prob_conversation_sizes = [30 20 10 10 10 10 10];


