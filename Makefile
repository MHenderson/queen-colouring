src_dir:=~/workspace/graphs-collection/src/Colouring/Trick
generate_seeds:=./generate_seeds
simulation:=./simulation2
get_colours:=get_colours.sed
output:=output.txt
approx:=chromatic_approx.txt
seeds:=seeds.txt

problem_file:=$(src_dir)/queen16_16.col
result_file=$(addsuffix .res, $(problem_file))
iterations:=10000
type:=random
ordering:=lbfsd

chromatic_approx.txt: $(output)
	sort -n $< | head -n 1 > $@

output.txt: $(get_colours) $(result_file)
	sed -n -f $< $(result_file) > $@

$(result_file): $(problem_file) $(seeds)
	$(simulation) $(seeds) $(type) $(ordering) $<

$(seeds):
	$(generate_seeds) $(iterations) > $(seeds)

clean:
	rm -f $(approx)
	rm -f $(output)
	rm -f $(result_file)
	rm -f $(seeds)
