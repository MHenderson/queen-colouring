src_dir:=~/workspace/graphs-collection/src/Colouring/Trick
simulation:=-./simulation
get_colours:=get_colours.sed
output:=output.txt
approx:=chromatic_approx.txt

problem_file:=$(src_dir)/queen10_10.col
result_file=$(addsuffix .res, $(problem_file))
iterations:=500
type:=random
ordering:=random

chromatic_approx.txt: $(output)
	sort -n $< | head -n 1 > $@

output.txt: $(get_colours) $(result_file)
	sed -n -f $< $(result_file) > $@

$(result_file): $(problem_file)
	$(simulation) $(iterations) $(type) $(ordering) $<

clean:
	rm -f $(approx)
	rm -f $(output)
	rm -f $(result_file)
