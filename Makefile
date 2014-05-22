problem_file:=queen7_7.col
result_file=queen7_7.col.res
iterations:=1000
type:=simple
ordering:=random

chromatic_approx.txt: output.txt
	sort -n $< | head -n 1 > $@

output.txt: get_colours.sed $(result_file)
	sed -n -f $< $(result_file) > $@

$(result_file): $(problem_file)
	./simulation $(iterations) $(type) $(ordering) $<

clean:
	rm -f chromatic_approx.txt
	rm -f output.txt
	rm -f $(result_file)
