% initialization
config;

global args;
global MALE;
global FEMALE;

rng(args.rng_seed);
male_sexist_counts_across_sims = [];
female_sexist_counts_across_sims = [];
starting_sexist_probabilities_across_sims = [];
ending_sexist_probabilities_across_sims = [];

for simulation_idx = 1 : args.num_simulations

	% keep track of stats
	conversation_sizes = zeros(args.num_conversations,1);
	percent_female_in_conversation = zeros(args.num_conversations,1);
	sexist_remarks_encountered_per_person = zeros(args.num_people,1);

	% let's sample people
	people = randsample(args.genders, args.num_people, true, args.prob_gender);

	for person_idx = 1 : numel(people)
		person = people(person_idx);

		% sample how sexist each person will be
		percent_sexist_remarks_per_person( person_idx ) = ...
			randsample(args.percent_sexist_remarks_by_gender{person}, ...
			1, true, args.prob_percent_sexist_remarks_by_gender{person});
	end

	% let's store their starting sexist tendencies
	starting_sexist_probabilities_across_sims = [starting_sexist_probabilities_across_sims; percent_sexist_remarks_per_person'];

	for conversation_idx = 1 : args.num_conversations
		% sample conversation size
		conversation_size = randsample(args.conversation_sizes, 1, true, ...
			args.prob_conversation_sizes);

		% sample conversation members
		people_indices = randsample(args.num_people, conversation_size);

		male_indices = people_indices(find(people(people_indices) == MALE));
		female_indices = people_indices(find(people(people_indices) == FEMALE));

		% decide which genders can make sexist remarks given conversation makeup
		if numel(male_indices) > numel(female_indices) 
			can_make_sexist_remark( MALE ) = true;
			can_make_sexist_remark( FEMALE ) = false;
		elseif numel(female_indices) > numel(male_indices)
			can_make_sexist_remark( MALE ) = false;
			can_make_sexist_remark( FEMALE ) = true;
		elseif conversation_size == 2 % anyone can be sexist on a 1-on-1 (don't quote me on that)
			can_make_sexist_remark( MALE ) = true;
			can_make_sexist_remark( FEMALE ) = true;
		end

		% finally actually sample sexist remarks
		coin_flips = rand(1,conversation_size)*100;
		sexist_remarks = coin_flips <= percent_sexist_remarks_per_person(people_indices);

		% finally add sexist remark if "allowed"
		for person_in_conv_idx = 1 : conversation_size
			gender = people(people_indices(person_in_conv_idx));
			if sexist_remarks(person_in_conv_idx) && can_make_sexist_remark(gender)
				if gender == FEMALE 
					sexist_remarks_encountered_per_person(male_indices) = ...
					  sexist_remarks_encountered_per_person(male_indices)  + 1;
					% here we increase the likelihood that women will say more sexist things if they witnessed sexism
					percent_sexist_remarks_per_person(female_indices) = ...
						min(percent_sexist_remarks_per_person(female_indices) + args.increase_in_sexism_after_witnessing, 100);
				elseif gender == MALE 
					sexist_remarks_encountered_per_person(female_indices) = ... 
					  sexist_remarks_encountered_per_person(female_indices) + 1;
					% here we increase the likelihood that men will say more sexist things if they witnessed sexism
					percent_sexist_remarks_per_person(male_indices) = ...
						min(percent_sexist_remarks_per_person(male_indices) + args.increase_in_sexism_after_witnessing, 100);
				end
			end
		end

		% book-keeping
		conversation_sizes(conversation_idx) = conversation_size;
		percent_female_in_conversation(conversation_idx) = numel(female_indices)/conversation_size;
	end

	% add stats 
	male_sexist_counts_across_sims = [male_sexist_counts_across_sims; sexist_remarks_encountered_per_person(find(people == MALE))];
	female_sexist_counts_across_sims = [female_sexist_counts_across_sims; sexist_remarks_encountered_per_person(find(people == FEMALE))];
	% see what their sexist probabilities ended up as
	ending_sexist_probabilities_across_sims = [ending_sexist_probabilities_across_sims; percent_sexist_remarks_per_person'];
end

figure(1);
subplot(2,1,1);
hist(female_sexist_counts_across_sims);
xlabel('Num sexist encounters faced');
title(sprintf('Females facing sexism over %d simulations', args.num_simulations));

subplot(2,1,2);
hist(male_sexist_counts_across_sims);
xlabel('Num sexist encounters faced');
title(sprintf('Males facing sexism over %d simulations', args.num_simulations));
% we only want to show the increase in sexism_percentages if they're actually
% changing, duuuuuuuh
if args.increase_in_sexism_after_witnessing > 0
	figure(2);
	subplot(2,1,1);
	hist(starting_sexist_probabilities_across_sims);
	xlabel('Percent of sexist remarks');
	title('Start of simulation');
	subplot(2,1,2);
	hist(ending_sexist_probabilities_across_sims);
	xlabel('Percent of sexist remarks');
	title('End of simulation');
end

