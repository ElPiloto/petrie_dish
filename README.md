# petrie_dish
a simulation for investigating the petrie multiplier

#### Code uses the same assumptions here:
http://www.davidchart.com/2013/10/20/the-petrie-multiplier/
##### Minor differences
- I believe that person does not sample gender or sexist probabilities, whereas I do
- My code aggregates results over mutliple simulations
- has support for different levels of sexism on a per-gender basis, although default is to have them equal

#### usage
- change simulation parameters in `config.m`
- `run_conversations.m` actually runs simulations
