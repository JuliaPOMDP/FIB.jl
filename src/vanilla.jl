# tolerance is ||alpha^k - alpha^k+1||_infty
mutable struct FIBSolver <: Solver
    max_iterations::Int64
    tolerance::Float64
    verbose::Bool
end
function FIBSolver(;max_iterations::Int64=100, tolerance::Float64=1e-3, verbose::Bool=false)
    return FIBSolver(max_iterations, tolerance, verbose)
end


function solve(solver::FIBSolver, pomdp::POMDP; kwargs...)
    if !isempty(kwargs)
        @warn("Keyword args for solve(::FIBSolver, ::MDP) are no longer supported. For verbose output, use the verbose option in the FIBSolver")
    end

    state_list = ordered_states(pomdp)
    obs_list = observations(pomdp)
    action_list = ordered_actions(pomdp)

    ns = length(state_list)
    na = length(action_list)

    alphas = zeros(ns,na)
    old_alphas = zeros(ns,na)

    for i = 1:solver.max_iterations

        # copyto!(dest, src)
        copyto!(old_alphas, alphas)

        residual = 0.0

        for (ai, a) in enumerate(action_list)
            for (si, s) in enumerate(state_list)

                sp_dist = transition(pomdp, s, a)

                r = 0.0
                for (sp, p_sp) in weighted_iterator(sp_dist)
                    r += p_sp*reward(pomdp, s, a, sp)
                end

                # Sum_o max_a' Sum_s' O(o | s',a) T(s'|s,a) alpha_a^k(s')
                o_sum = 0.0
                for o in obs_list

                    # take maximum over ap
                    ap_sum = -Inf
                    for (api, ap) in enumerate(action_list)

                        # Sum_s' O(o | s',a) T(s'|s,a) alpha_a^k(s')
                        temp_ap_sum = 0.0
                        for (sp, p_sp) in weighted_iterator(sp_dist)
                            o_dist = observation(pomdp, a, sp)
                            p_o = pdf(o_dist, o)
                            spi = stateindex(pomdp, sp)

                            temp_ap_sum += p_o * p_sp * old_alphas[spi,api]
                        end
                        ap_sum = max(temp_ap_sum, ap_sum)
                    end

                    o_sum += ap_sum
                end

                alphas[si, ai] = r + discount(pomdp) * o_sum

                alpha_diff = abs(alphas[si, ai] - old_alphas[si, ai])
                residual = max(alpha_diff, residual)
            end
        end

        solver.verbose ? @printf("[Iteration %-4d] residual: %10.3G \n", i, residual) : nothing
        residual < solver.tolerance ? break : nothing
    end

    return AlphaVectorPolicy(pomdp, alphas, action_list)
end
