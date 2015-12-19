---
layout:     post
title:      "Live editing preview with gnuplot"
date:       2015-12-19 13:35:00 +0100
categories: [gnuplot]
keywords:   [live,realtime,preview,edit]
---

I occasionally make some plots for school experiment reports. It usually takes me tens of rebuilds until I'm satisfied with results. To make this process simpler I've made a Makefile with live monitoring feature, which I'm sharing with you in this post.

The last graph I made looks like this:
![benchmark-graph.png]({{ site.url }}/assets/img/2015-12-19-gnuplot-live-editing-preview/benchmark-graph.png)

It was generated using this data:
{% highlight text %}
1 test-in-24.txt 1000 1000000 3015.067 2350.364 686.245 617.526 5097225 5097225 5097225 5097225
2 test-in-24.txt 1000 1000000 3016.524 1178.371 686.896 625.069 5097225 5097225 5097225 5097225
4 test-in-24.txt 1000 1000000 3018.761 591.661 686.903 346.001 5097225 5097225 5097225 5097225
6 test-in-24.txt 1000 1000000 3016.318 396.687 686.603 305.530 5097225 5097225 5097225 5097225
8 test-in-24.txt 1000 1000000 3015.704 300.527 686.096 282.227 5097225 5097225 5097225 5097225
12 test-in-24.txt 1000 1000000 3015.626 207.320 686.640 275.091 5097225 5097225 5097225 5097225
16 test-in-24.txt 1000 1000000 3014.576 302.468 687.505 282.977 5097225 5097225 5097225 5097225
20 test-in-24.txt 1000 1000000 3015.040 266.546 687.524 277.467 5097225 5097225 5097225 5097225
24 test-in-24.txt 1000 1000000 3014.222 387.577 687.232 277.702 5097225 5097225 5097225 5097225
{% endhighlight %}

By this gnuplot script:
{% highlight text %}
set title "Knapsack implementations benchmark"
set xlabel "OMP\\_NUM\\_THREADS"
set ylabel "Computation time compared to Base solution"
set yr [0:1.2]

set title font "Inconsolata-dz, 16" 
set xlabel font "Inconsolata-dz, 14" 
set ylabel font "Inconsolata-dz, 14" 
set key font "Inconsolata-dz, 12" 
set tic font "Inconsolata-dz, 12" 

INPUT_FILE='benchmark-data.txt'

plot    INPUT_FILE using 1:( $5 / $5):xtic(1) title 'Base' with lines, \
        INPUT_FILE using 1:( $6 / $5) title 'OpenMP Base' with lines, \
        INPUT_FILE using 1:( $7 / $5) title 'SSE' with lines, \
        INPUT_FILE using 1:( $8 / $5) title 'OpenMP SSE' with lines
{% endhighlight %}


## Build using Makefile
Makefile is mostly used to build a software. However, it can be very useful tool for building dependend stuff. So, we can use it to build our graph. Put following text into the `Makefile`:

{% highlight make %}
TERMINAL=set terminal png size 500,450
TMP_DIR=/tmp

all: benchmark-graph.png

# rule for all *.png files
# depends on plot file and data for the plot file
%.png: %.p %-data.txt
	gnuplot -e "$(TERMINAL);set output '$(TMP_DIR)/$@.tmp'; load '$*.p'"
	dd if=$(TMP_DIR)/$@.tmp of=$@
	rm $(TMP_DIR)/$@.tmp
{% endhighlight %}

We are now able build it with just one command:
{% highlight shell %}
make
{% endhighlight %}

PNG creation rule uses a temporary file for gnuplot output. Then it writes contents of the temporary file to the destination file with `dd` utility, and then it removes the temporary file. For some magical reasons, direct output to the destination file doesn't trigger auto-refresh in image viewer, when we rebuild the graph. Neither `cat tmp > dest` work.

## Monitoring filesystem events
To achieve realtime preview of changes we can use `inotifywait` to monitor filesystem events. We create a Makefile rule which will monitor filesystem events and rebuilds the graph when something changes. 

To to that we can add new rule to the end of the `Makefile`:
{% highlight make %}
realtime:
	while true; do \
		inotifywait -e close_write,moved_to,create .; \
		make all; \
	done;
{% endhighlight %}

We are now able to launch realtime rebuild target:

{% highlight shell %}
make realtime
{% endhighlight %}

It doesn't have to be a Makefile rule, it can be also be a regular shell script. However, I'd like to keep my workspace clean. So, I decided to put it all together, because both Makefile and monitoring script are quite short.
