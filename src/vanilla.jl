# tolerance is ||alpha^k - alpha^k+1||_infty
mutable struct FIBSolver <: Solver
    max_iterations::Int64
    tolerance::Float64
end
function FIBSolver(;max_iterations::Int64=100, tolerance::Float64=1e-3)
    return FIBSolver(max_iterations, tolerance)
end

mutable struct FIBPolicy{P<:POMDP, A} <: Policy
    alphas::Matrix{Float64}
    action_map::Vector{A}
    pomdp::P
end

function FIBPolicy(pomdp::POMDP; alphas::Matrix{Float64}=zeros(0,0))
    ns = n_states(pomdp)
    na = n_actions(pomdp)
    if !isempty(alphas)
        @assert size(alphas) == (ns,na)
    else
        alphas = zeros(ns, na)
    end
    action_map = ordered_actions(pomdp)
    return FIBPolicy(alphas, action_map, pomdp)
end

updater(p::FIBPolicy) = DiscreteUpdater(p.pomdp)

# TODO: I think this is inefficient
#  b' allocates a new vector
#  maybe I should just iterate instead of using matrix multiplication
value(p::FIBPolicy, b::DiscreteBelief) = maximum(b.b' * p.alphas)

function action(p::FIBPolicy, b::DiscreteBelief)
    a_ind = indmax(b.b' * p.alphas)
    return p.action_map[a_ind]
end

function solve(solver::FIBSolver, pomdp::POMDP; verbose::Bool=false)
    ns = n_states(pomdp)
    na = n_actions(pomdp)

    alphas = zeros(ns,na)
    old_alphas = zeros(ns,na)

    state_list = ordered_states(pomdp)
    obs_list = observations(pomdp)
    action_list = actions(pomdp)

    for i = 1:solver.max_iterations

        # copy!(dest, src)
        copy!(old_alphas, alphas)

        residual = 0.0

        for (ai, a) in enumerate(action_list)
            for (si, s) in enumerate(state_list)

                sp_dist = transition(pomdp, s, a)

                # Sum_o max_a' Sum_s' O(o | s',a) T(s'|s,a) alpha_a^k(s')
                o_sum = 0.0
                for o in obs_list

                    # take maximum over ap
                    ap_sum = -Inf
                    for (api, ap) in enumerate(action_list)

                        # Sum_s' O(o | s',a) T(s'|s,a) alpha_a^k(s')
                        temp_ap_sum = 0.0
                        for (spi, sp) in enumerate(state_list)
                            o_dist = observation(pomdp, a, sp)
                            p_o = pdf(o_dist, o)
                            p_sp = pdf(sp_dist, sp)

                            temp_ap_sum += p_o * p_sp * old_alphas[spi,api]
                        end
                        ap_sum = max(temp_ap_sum, ap_sum)
                    end

                    o_sum += ap_sum
                end

                r = reward(pomdp, s, a)

                alphas[si, ai] = r + discount(pomdp) * o_sum

                alpha_diff = abs(alphas[si, ai] - old_alphas[si, ai])
                residual = max(alpha_diff, residual)
            end
        end

        verbose ? @printf("[Iteration %-4d] residual: %10.3G \n", i, residual) : nothing
        residual < solver.tolerance ? break : nothing
    end

    return FIBPolicy(pomdp, alphas=alphas)
end
