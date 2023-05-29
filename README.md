# nextflow-course

Contains course material for a short course on Nextflow DSL2

Scott Hazelhurst
School of Electrical & Information Engineering 
and 
Sydney Brenner Institute for Molecular Bioscience

University of the Witwatersrand

## Set up

Clone the repo
- `git clone shaze/nextflow-course`

## Exercise 0

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

- First, look at, understand `phase.nf` which shows a simple example of how `join` works. By default,
  it takes two channels of tuples and _phases_ them using the first element of each tuple as a common key
- Note also
   -- we can construct output names dynamically using input values
   -- the use of the directive `publishDir` to direct output. In this case, the output directory is fixed, but
      we could also construct it dynamically

Now look at `cleandups.nf`. This takes our previous example and fixes the semantic problems. There is some new
Nextflow here
-- Generally, we connect the channels of two processes by passing paramters

   ```
   processA(x,y)
   processB(processA.out)
   ```

   If `processA` had multiple output channels we could also specify which channel to be used.
   However, when the output signature of one process (i.e., the number of channels) matches the input of the next
   we can use the pipe ("|") symbol

   ```
   processA(x,y) | processB
   ```

   which is cleaner. The two are semantically equivalent though so you can choose which you'd prefer.

-- note the use of `join`. Join takes two parameters -- generally we'd write `a_ch.join(b_ch)` using the
   tradtional "." notation (so the first parameter is before the "."!). When we use piping then the first parameter
   comes from the preceding channel and the second is given explicitly

-- note the use of `view` here. `view` takes values from one channel, displays it on the terminal and then creates a
   new output channel with the same value. It's main purpose is debugging. I introduced it because there was
   a bug in my first version of the code and I wanted to see what was happening. Once I found the bug and
   fixed the code, I should have taken it out and have only left it in order to show you



Run the code
- `nextflow run cleandups.nf`
-  Note where the output can be found
- Run it again : `nextflow run cleandups.nf -resume`

We now move the next exercise.


##  Exercise 3

To move to this exercise say `git checkout grouping` (If you've changed any of my files in the current exercise, git may complain and you will have to say `git commit -a -m "MovingOn!!!"`)

In this exercise we are going to look at two things
-- creating configuration files
-- more sophisticated ways of creating channels

### Configuration files

The default configuration file is `nextflow.config` (we can actually have multiple configuration files and can also structure config files in JSON or yaml format) but we'll stick with the basics.

A config file consists of two _scopes_. In our example, there are two scopes -- the _manifest_ and _params_. The manifest is mainly informational although it can be used by nextflow to choose which script to run if there are multiple scripts in a directory (we'll explore this later).

The _params_ file is used set set a record/struct variable called _params_ that can be accessed and manipulated in the
Nextflow program. In this case, we can refer to `params.input_dir` and `params.output` etc. So this is a very convenient way of sending values into our Nextflow program rather than hard-coding values. In particular, it's generally a bad idea to fix absolute directory paths into a Nextflow program -- these should be set by using _params_.

There are several ways in which _params_ can be set. This causes occasional confusion but it gives great flexibility in writing code that has sensible defaults for parameters which can be over-ridden by the user or environment. In order of increasing precedence (that is paramters set by later methods over-ride values set by earlier methods) the key ones are:
- you can set the parameter in the Nextflow program itself `params.input_dir="myinputdir"`
- the `nextflow.config` file in the directory of the workflow script
- the `nextflow.config` file in the directory from which you run the script
- paramters set by on the command-line: for example if I run `nextflow run --input_dir data simplefreq.nf` then in my program, `params.input_dir` will hve the value _data_.

There are other rules and you can also have different config files -- look at the documentation for detail.


### Grouping input files


Have a look at `group.nf`. First, note how we create channels using different methods. The factory method _fromFilePairs_ allows us to create a channel of file tuples that are grouped according to some rule. In our case, we do several  things
-- we use our _params_ to select which directory and file sets will be used
-- we specify we only want _bed_, _bim_ and _fam_ files (NB:  the use of braces and commas like this `{bed,bim,fam}` is a standard command-line feature (glob) (and is not specific to Nextflow) -- just as the glob "*" means everything, a list of things in braces, separated by commas specifies a list of things.
-- we specify that we are only intersted in filesets with exactly three elements -- for example, if there's a _fam_ file missing for one data set, we are not interested in it. (As an aside the use of the word _Pairs_ is misleading since you can have any number of elements picked up, the default value for _size_ is 2.)
-- Finally and very importantly we pass _fromFilePairs_ a closure which specifies how to group the elements. What _fromFilePairs_ does is to pick up all the files that match the expression given, and then groups the elements according to the closure -- it applies the function specified in the closure to each file and groups all files for which the closure returns the same value).


Now run `group.nf`: `nextflow run group.nf`

There's another example you can uncomment out. One slightly confusing thing in running is that Nexflow maximises concurrency where possible and so you see the outputs all mixed up.

### PLINK example

In this example, we are going to take a number of different PLINK file sets, compute the frequencies, and then merge the results. When `plink` is run it needs three input files a _bed_, _bim_ and _fam_ file. If we are running multiple file sets through `plink` we have to make sure that we are consistent -- we can't use the _bed_ file from one data set, the _bim_ from another and the _fam_ from yet another. Even if by some miracle the sizes of the files somehow allow this to work we are going to get nonsense as a result.

Thus we use _fromFilePairs_ to do the grouping. Look at `freq.nf`

*Exercise*: The problem with this solution is that the output file is not in the right order -- how can it be fixed?


*Exercise*: Checkout _pairs_ for a simple exercise. Here we have different data for differents months of different years. Combine the monthly data by doing a _paste_ and then combined the monthly data to get yearly data.


## Exercise 4: Using the config file.

Checkout the _config_ branch: `git checkout config`  (again, if you have amended any of my files you may have to commit the change.

* Have a look at the _nextflow.config_ file
* Run the program _show_param.nf_: `nextflow run show_param.nf`
* Can you understand the output?
* Try different toptions like `nextflow run show_param.nf --other 7 --cut-off 15`
* modify the _nextflow.config_ file and see how it works

Now check out the _docker_ branch:  `git checkout docker`



