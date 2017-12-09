module FIB

using POMDPs
using POMDPToolbox

import POMDPs: Solver, Policy
import POMDPs: solve, action, value, update, initialize_belief, updater

export
    FIBSolver,
    FIBPolicy,
    solve,
    action,
    value

include("vanilla.jl")

end # module
