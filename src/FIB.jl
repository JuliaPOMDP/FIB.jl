module FIB

using POMDPs
using POMDPTools
using Printf

import POMDPs: Solver, Policy, solve

export
    FIBSolver,
    solve

include("vanilla.jl")

end # module
