#!/usr/bin/nextflow

// This is pure Groovy code -- but we can put it in our Nextflow program
// Read through and make sure you understand what it does

println ({ a -> a*a } (3))

println ({ a -> a*a+7*a - 2 } (3))

for (n in 1..5) println( {it*it} (n));

println ({ x, y ->  Math.sqrt(x*x + y*y) } (3,4))



int doX(f, nums) {
    sum=0;
    for ( n in nums ) {
       sum = sum+f(n);
    }
    return sum
}



println doX ( {a->a},   [4,5,16] );

println doX ( {a->a*a}, [4,5,16] );

println doX ( { it*it }, [4,5,16]);

m=10
println doX({a->m*a+2}, [1,2,3])

x = [19,1,2,3,2]

println "Can loop  through easily...\n"

x.each { print "The number is $it\n" }

print "Create a new list\n"
squares = x.collect { it * it }

print "Find first occurrence\n"
got = x.find { it == 2 }
print "Find all occurrences\n"
gotlist = x.findAll { it == 2 }


def sqr = { it * it }

println sqr(3)

base = "clean"

plinks = { x -> ["${x}.bed","${x}.bim","${x}.fam"] } (base)

println plinks
