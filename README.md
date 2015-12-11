# branching

Author: William Wang
Aldous Undergraduate Research Group, University of California, Berkeley.

A visualization of multiple branching processes, including the "Birth and Assassination" process, a modification of the Galton-Watson branching process. Based on a paper
written by David Aldous, a professor of statistics at the University of California, Berkeley. The paper can be found here:

https://www.stat.berkeley.edu/~aldous/Papers/me44.pdf

Check a button for the process type: the default is Galton-Watson.
- Galton-Watson: requires the birth rate field and a killing distribution. Particles are born according to a Poisson process with the given birth rate parameter and have lifetimes distributed as the killing distribution.
- Birth-and-Assassination: requires the birth rate field and a killing distribution. Works the same as the Galton-Watson process, but particles only start their death timer when their parent is dead. They are able to give birth even if they are not at risk of death.
- Conditional-Uniform: Requires the birth rate field and a constant representing the initial lifetime. Particles are born according to a Poisson process with the given birth rate parameter. The lifetimes are distributed uniform from 0 to their parent's lifetime.
- Conditional-Birth-and-Assassination: Requires the birth rate field and a constant representing the initial lifetime. Works the same as the Conditional-Uniform but with the added element of Birth-and-Assassination.

Press "Start" to start the simulation. Press "Reset" to stop the current simulation and enter parameters for a new simulation. Invalid inputs will cause a message to appear in the log. The log will also display simulation information, including the initial particle lifetime, the number of particles in each generation, and the extinction or expected survival status.

Killing distributions currently supported with density functions:
Uniform(a, b): f(x) = 1 / (b - a)
Exponential(lambda): f(x) = lambda * exp(-lambda * x)
f(x) = 3 * x^2 on (0, 1)

Some parameters that provide interesting results:
Galton-Watson, birth rate .5, uniform(3, 5)
Galton-Watson, birth rate 1, F(x) = x^3
Birth-and-Assassination, birth rate .5, exponential(.4)
Conditional-Uniform, birth rate .8, initial lifetime 6
Conditional-Birth-and-Assassination, birth rate .3, initial lifetime 6

Possible additions in the future:
Wider variety of killing distributions
Functionality to pause sketch and continue where it left off
User-input killing distribution given by valid PDF or CDF

Source code can be found here:
https://github.com/williamwwang/branching