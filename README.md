# nextflow-course

Contains course material for a short course on Nextflow DSL2

Scott Hazelhurst
School of Electrical & Information Engineering 
and 
Sydney Brenner Institute for Molecular Bioscience

University of the Witwatersrand

##Set up

Clone the repo
- `git clone shaze/nextflow-course`

##Exercise 0

Read and run the `show.nf` script
- `nextflow run show.nf`

Read and run the `cleandups.nf` script

Fix the obvious bug -- we will fix the deeper semantic issue later

You should commit your fix into git
- `git commit -a -m "fixed the problem"`

## Exercise 1

If you need some intro to Groovy, checkout the groovy branch
- `git checkout groovy`

Read the `groovy.nf` and run. Make sure you understand.

Otherwise or then move to Exercise 2

## Exercise 2

Checkout the `phase` branch

- `git checkout phasing`

In this exercise we fix the semantic problem from Exercise 0 to show that even if we have multiple input
files we get the corrrect result

- First, look at, understand phase.nf which shows a simple example of how `join` works. By default,
  it takes two channels of tuples and _phases_ them using the first element of each tuple as a common key
- Note also
   -- we can construct output names dynamically using input values
   -- the use of the directive `publishDir` to direct output. In this case, the output directory is fixed, but
      we could also construct it dynamically

Now look at `cleandups.nf`. This takes our previous example and fixes the semantic problems

-- Run the code



##  Exercise 2




