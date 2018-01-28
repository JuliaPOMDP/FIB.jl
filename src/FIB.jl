__precompile__()

module FIB

using POMDPs

using POMDPToolbox

import POMDPs: Solver, Policy, solve

export
    FIBSolver,
    solve

include("vanilla.jl")

end # module
