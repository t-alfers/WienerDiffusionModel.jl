params(d::Wiener) = (d.ν, d.α, d.τ, d.z)

#####################################
# Probability density function      #
# Navarro & Fuss (2009)             #
# Wabersich & Vandekerckhove (2014) #
#####################################

function pdf(d::Wiener, x::Int, t::Real; ϵ::Real = 1.0e-12)
    if x == 1
        (ν, α, τ, z) = params(d)
        return pdf(Wiener(-ν, α, τ, 1-z), t; ϵ=ϵ)
    end

    return pdf(d, t; ϵ=ϵ)
end

# probability density function over the lower boundary
function pdf(d::Wiener{T}, t::Real; ϵ::Real = 1.0e-12) where {T<:Real}
    (ν, α, τ, z) = params(d)
    if τ ≥ t
        return T(NaN)
    end
    u = (t - τ) / α^2

    K_s = 2.0
    K_l = 1 / (π * sqrt(u))
    # number of terms needed for large-time expansion
    if (π*u*ϵ) < 1
        K_l = max(sqrt((-2*log(π*u*ϵ)) / (π^2 * u)), K_l)
    end
    # number of terms needed for small-time expansion
    if (2*sqrt(2*π*u)*ϵ) < 1
        K_s = max(2 + sqrt(-2u * log(2ϵ*sqrt(2*π*u))), sqrt(u)+1)
    end

    p = exp((-α*z*ν) - (0.5*(ν^2)*(t-τ))) / (α^2)

    # decision rule for infinite sum algorithm
    if K_s < K_l
        return p * _small_time_pdf(u, z, ceil(Int, K_s))
    end
    
    return p * _large_time_pdf(u, z, ceil(Int, K_l))
end

# small-time expansion
function _small_time_pdf(u::T, z::T, K::Int) where {T<:Real}
    inf_sum = zero(T)

    k_series = -floor(Int, 0.5*(K-1)):ceil(Int, 0.5*(K-1))
    for k in k_series
        inf_sum += ((2k + z) * exp(-((2k + z)^2 / (2u))))
    end

    return inf_sum / sqrt(2π*u^3)
end

# large-time expansion
function _large_time_pdf(u::T, z::T, K::Int) where {T<:Real}
    inf_sum = zero(T)

    for k in 1:K 
        inf_sum += (k * exp(-0.5*(k^2*π^2*u)) * sin(k*π*z)) 
    end

    return π * inf_sum
end

logpdf(d::Wiener, x::Int, t::Real; ϵ::Real = 1.0e-12) = log(pdf(d, x, t; ϵ=ϵ))
logpdf(d::Wiener, t::Real; ϵ::Real = 1.0e-12) = log(pdf(d, t; ϵ=ϵ))

#########################################
# Cumulative density function           #
# Blurton, Kesselmeier, & Gondan (2012) #
#########################################
 
function cdf(d::Wiener, x::Int, t::Real; ϵ::Real = 1.0e-12)
    if x == 1
        (ν, α, τ, z) = params(d)
        return cdf(Wiener(-ν, α, τ, 1-z), t; ϵ=ϵ)
    end

    return cdf(d, t; ϵ=ϵ)
end

# cumulative density function over the lower boundary
function cdf(d::Wiener{T}, t::Real; ϵ::Real = 1.0e-12) where {T<:Real}
    if d.τ ≥ t
        return T(NaN)
    end

    K_s = _K_small(d, t; ϵ=ϵ)
    K_l = _K_large(d, t; ϵ=ϵ)

    if K_l < 10*K_s
        return _Fl_lower(d, K_l, t)
    end

    return _Fs_lower(d, K_s, t)
end

function _Fl_lower(d::Wiener{T}, K::Int, t::Real) where {T<:Real}
    (ν, α, τ, z) = params(d)
    F = zero(T)
    K_series = K:-1:1
    for k in K_series
        F -= (k/(ν^2 + k^2*π^2/(α^2)) * 
            exp(-ν*α*z - 0.5*ν^2*(t-τ) - 0.5*k^2*π^2/(α^2)*(t-τ)) *
            sin(π * k * z))
    end
    return _P_upper(ν, α, z) + 2*π/(α^2) * F
end

function _Fs_lower(d::Wiener{T}, K::Int, t::Real) where {T<:Real}
    (ν, α, τ, z) = params(d)
    if abs(ν) < sqrt(eps(T))
        return _Fs0_lower(d, K, t)
    end

    sqt = sqrt(t-τ)

    S1 = zero(T)
    S2 = zero(T)
    K_series = K:-1:1
    for k in K_series
        S1 += (_exp_pnorm(2*ν*α*k, -sign(ν)*(2*α*k+α*z+ν*(t-τ))/sqt) -
            _exp_pnorm(-2*ν*α*k-2*ν*α*z, sign(ν)*(2*α*k+α*z-ν*(t-τ))/sqt))
        S2 += (_exp_pnorm(-2*ν*α*k, sign(ν)*(2*α*k-α*z-ν*(t-τ))/sqt) - 
            _exp_pnorm(-2*ν*α*k-2*ν*α*z, -sign(ν)*(2*α*k-α*z-ν*(t-τ))/sqt))
    end

    return _P_upper(ν, α, z) + sign(ν) * (
        (cdf(Normal(), -sign(ν) * (α*z+ν*(t-τ))/sqt) - _exp_pnorm(-2*ν*α*z, sign(ν) * (α*z-ν*(t-τ)) / sqt))
    ) + S1 + S2
end

function _Fs0_lower(d::Wiener{T}, K::Int, t::Real) where {T<:Real}
    (_, α, τ, z) = params(d)
    F = zero(T)
    K_series = K:-1:0
    for k in K_series
        F -= (cdf(Normal(), (-2*k - 2+z) * α / sqrt(t-τ)) + cdf(Normal(), (-2*k -z) * α / sqrt(t-τ)))
    end
    return 2*F
end

function _K_large(d::Wiener{T}, t::Real; ϵ::Real = 1.0e-12) where {T<:Real}
    (ν, α, τ, z) = params(d)
    return ceil(Int, max(sqrt(1/(t-τ)) * α/π, sqrt(max(1, -2/(t-τ)*α^2/(π^2) * (log(ϵ*π*(t-τ)/2 * (ν^2 + π^2/(α^2)))) + ν*α*z + ν^2*(t-τ)/2))))
end

function _K_small(d::Wiener{T}, t::Real; ϵ::Real = 1.0e-12) where {T<:Real}
    (ν, α, τ, z) = params(d)
    if abs(ν) < sqrt(eps(T))
        return ceil(Int, max(0, z/2 - sqrt(t-τ)/(2*α) * quantile(Normal(), max(0, min(1, ϵ/(2-2*z))))))
    end
    if ν > 0
        return _K_small(Wiener(-ν, α, τ, z), t; ϵ = exp(-2*α*z*ν)*ϵ)
    end
    S2 = z - 1 + 1/(2*ν*α) * log(ϵ/2 * (1-exp(2*ν*α)))
    S3 = (0.535 * sqrt(2*(t-τ)) + ν*(t-τ) + α*z)/(2*α)
    S4 = z/2 - sqrt(t-τ)/(2*α) * quantile(Normal(), max(0, min(1, ϵ*α/(0.3 * sqrt(2*π*(t-τ))) * exp(ν^2*(t-τ)/2 + ν*α*z) ))) 
    return ceil(Int, max(0, S2, S3, S4))
end

function _P_upper(ν::T, α::T, z::T) where {T<:Real}
    e = exp(-2 * ν * α * (1-z))
    if isinf(e)
        return 1
    end
    if abs(e-1) < sqrt(eps(T))
        return 1-z
    end
    return (1-e)/(exp(2*ν*α*z) - e)
end

# Approximation by Kiani et al. (2008)
function _exp_pnorm(a::T, b::T) where {T<:Real}
    r = exp(a) * cdf(Normal(), b)
    if isnan(r) && b < -5.5
        r = (1/sqrt(2)) * exp(a - b^2/2) * (0.5641882/(b^3) - 1/(b * sqrt(π))) 
    end
    return r
end

#########################################
# Sampling                              #
#########################################

function rand(rng::AbstractRNG, d::Wiener)
    return _rand_rejection(rng, d)
end

# Rejection-based method (Tuerlinckx et al., 2001 based on Lichters et al., 1995)
# adapted from the RWiener R package, note, here σ = 0.1
function _rand_rejection(rng::AbstractRNG, d::Wiener)
    (ν, α, τ, z) = params(d)
    
    ϵ = 1.0e-15

    D = .005 # = 2*σ^2 => 1/200
    zn = (z*α) / 10 # absolute bias!
    αn = α / 10
    νn = ν / 10

    total_time = 0.0
    start_pos = 0.0
    Aupper = αn - zn
    Alower = -zn
    radius = min(abs(Aupper), abs(Alower))
    λ = 0.0
    F = 0.0
    prob = 0.0

    while true
        if νn == 0
            λ = (0.25D*π^2) / (radius^2)
            F = 1.0
            prob = .5            
        else
            λ = ((0.25*νn^2)/D) + ((0.25*D*π^2) / (radius^2))
            F = (D*π) / (radius*νn)
            F = F^2 / (1+F^2)
            prob = exp((radius*νn)/D)
            prob = prob / (1+prob)
        end

        r = rand(rng)
        dir = r < prob ? 1 : -1
        l = -1.0
        s1 = 0.0
        s2 = 0.0

        # Tuerlinckx et al. (2001; eq. 16)  
        while s2 > l
            s1 = rand(rng)
            s2 = rand(rng)
            tnew = 0.0
            tδ = 0.0
            uu = zero(Int)

            while (abs(tδ) > ϵ) || (uu == 0)
                uu += 1
                tt = 2*uu + 1
                tδ = tt * (uu % 2 == 0 ? 1 : -1) * (s1 ^ (F * tt^2))
                tnew += tδ                              
            end

            l = 1 + (s1^(-F)) * tnew 
        end

        total_time += abs(log(s1)) / λ
        dir = start_pos + dir * radius

        if (dir + ϵ) > Aupper
            return total_time + τ
        elseif (dir - ϵ) < Alower
            return -(total_time + τ)
        else
            start_pos = dir
            radius = min(abs(Aupper - start_pos), (abs(Alower - start_pos)))
        end
    end
end

sampler(rng::AbstractRNG, d::Wiener) = rand(rng::AbstractRNG, d::Wiener)