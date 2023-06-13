abstract type AbstractWiener <: ContinuousUnivariateDistribution end

"""
    Wiener(ν, α, τ, z)
    Wiener(ν, α, τ)

A struct representing a *Wiener diffusion model distribution*. 

# Arguments

- `ν::Real`: The drift rate. This represents the speed of information accumulation or the ease of the decision process. A positive value denotes a bias towards one decision, whereas a negative value indicates a bias towards the other decision. 

- `α::Real`: The boundary separation. This parameter represents the amount of information needed before a decision is made. Larger values denote more careful or accurate decision-making, but slower response times. Smaller values denote more impulsive decision-making with faster response times, but potentially more errors.

- `τ::Real ≥ 0`: The non-decision time. This represents the time taken by non-decision processes such as stimulus encoding and motor response.

- `z::Real ∈ [0, 1]`: The relative bias. This parameter denotes the initial bias towards one of the decisions, as a proportion of the boundary separation. When not provided, the relative bias will be fixed to `0.5` denoting equal bias towards either decision.

```julia
Wiener(ν, α, τ, z) 

params(d)            # Get the parameters, i.e. (ν, α, τ, z)
```
"""
struct Wiener{T<:Real} <: AbstractWiener
    ν::T # drift rate
    α::T # boundary separation
    τ::T # non-decision time
    z::T # relative bias
    Wiener{T}(ν::T, α::T, τ::T, z::T) where {T<:Real} = new{T}(ν, α, τ, z)
end

function Wiener(ν::T, α::T, τ::T, z::T; check_args::Bool=true) where {T <: Real}
    check_args && Distributions.@check_args Wiener (α, α > zero(α)) (τ, τ > zero(τ)) (z, z ≥ 0 && z ≤ 1)
    return Wiener{T}(ν, α, τ, z)
end

function Wiener(ν::T, α::T, τ::T; check_args::Bool=true) where {T <: Real}
    return Wiener(ν, α, τ, 0.5; check_args=check_args)
end

Wiener(ν::Real, α::Real, τ::Real, z::Real; check_args::Bool=true) = Wiener(promote(ν, α, τ, z)...; check_args=check_args)
Wiener(ν::Real, α::Real, τ::Real; check_args::Bool=true) = Wiener(promote(ν, α, τ)...; check_args=check_args)
