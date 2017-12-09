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
pomdp = MyPOMDP() # initialize POMDP

solver = FIBSolver()

# run the solver
policy = solve(solver, pomdp)
```
