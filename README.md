# FIB

[![Build Status](https://travis-ci.org/JuliaPOMDP/FIB.jl.svg?branch=master)](https://travis-ci.org/JuliaPOMDP/FIB.jl)

[![Coverage Status](https://coveralls.io/repos/JuliaPOMDP/FIB.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/JuliaPOMDP/FIB.jl?branch=master)

## Installation

```julia
Pkg.clone("https://github.com/JuliaPOMDP/FIB.jl")
```

## Usage

```julia
using FIB
using POMDPModels
pomdp = TigerPOMDP() # initialize POMDP

solver = FIBSolver()

# run the solver
policy = solve(solver, pomdp)
```

FIB.jl solves problems implemented using the [POMDPs.jl interface](https://github.com/JuliaPOMDP/POMDPs.jl). See the [documentation for POMDPs.jl](http://juliapomdp.github.io/POMDPs.jl/latest/) for more information.
