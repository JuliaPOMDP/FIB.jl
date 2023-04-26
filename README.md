# FIB

[![Build Status](https://github.com/JuliaPOMDP/FIB.jl/actions/workflows/CI.yml/badge.svg)](https://github.com/JuliaPOMDP/FIB.jl/actions/workflows/CI.yml/)
[![codecov](https://codecov.io/gh/JuliaPOMDP/FIB.jl/branch/master/graph/badge.svg?token=nlr4r9x83U)](https://codecov.io/gh/JuliaPOMDP/FIB.jl)

Implements the fast informed bound (FIB) solver for POMDPs. FIB is discussed in Sec. 21.2 of:

* M. J. Kochenderfer, T. A. Wheeler, and K. H. Wray, [Algorithms for Decision Making](https://algorithmsbook.com/decisionmaking), MIT Press, 2022.

## Installation

```julia
Pkg.add("FIB")
```

```julia
using FIB
using POMDPModels
pomdp = TigerPOMDP() # initialize POMDP

solver = FIBSolver()

# run the solver
policy = solve(solver, pomdp)   # policy is of type AlphaVectorPolicy
```
The result of `solve` is an `AlphaVectorPolicy`. This policy type is implemented in [POMDPTools.jl](https://juliapomdp.github.io/POMDPs.jl/stable/POMDPTools/policies/#Alpha-Vector-Policy).

FIB.jl solves problems implemented using the [POMDPs.jl interface](https://github.com/JuliaPOMDP/POMDPs.jl). See the [documentation for POMDPs.jl](http://juliapomdp.github.io/POMDPs.jl/latest/) for more information.
