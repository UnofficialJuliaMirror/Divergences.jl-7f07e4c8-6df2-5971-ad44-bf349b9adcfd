################################################################################
## Chi squared
##
## ==> \gamma(a/b)b
## ==> \gamma(u)
################################################################################

################################################################################
## evaluate
################################################################################
function evaluate{T<:AbstractFloat}(dist::ChiSquared, a::T, b::T)
    u = a/b
    return u^2/2.0 - u + 0.5
end

function evaluate{T<:AbstractFloat}(dist::ChiSquared, a::AbstractVector{T})
    n = length(a)::Int
    r = zero(T)
    l = one(T)
    @inbounds for i in 1:n
        r += a[i]^2/2.0 - a[i] + 0.5
    end
    return r
end

function evaluate{T<:AbstractFloat}(dist::ChiSquared, a::AbstractVector{T}, b::AbstractVector{T})
    n = get_common_len(a, b)::Int
    r = zero(T)
    l = one(T)
    @inbounds for i in 1:n
        ui = ai/bi
        r += evaluate(dist, ui, l)
    end
    return r
end

################################################################################
## gradient
################################################################################
function gradient{T<:AbstractFloat}(dist::ChiSquared, a::T, b::T)
    ## b \left(\frac{\left(\frac{a}{b}\right)^{\alpha }}{\alpha  b}-\frac{1}{\alpha  b}\right)
    return a/b-one(T)
end

function gradient{T<:AbstractFloat}(dist::ChiSquared, a::T)
    return a-one(T)
end

function gradient!{T<:AbstractFloat}(u::Vector{T}, dist::ChiSquared, a::AbstractVector{T}, b::AbstractVector{T})
    n = get_common_len(a, b)::Int
    @inbounds for i = 1:n
        ai = a[i]
        bi = bi[i]
        u[i] = gardient(dist, ai, bi)
    end
end

function gradient!{T<:AbstractFloat}(u::Vector{T}, dist::ChiSquared, a::AbstractVector{T})
    n = length(a)::Int
    l = one(T)
    @simd for i = 1:n
        @inbounds u[i] = a[i]-l
    end
end

################################################################################
## Hessian
################################################################################
function hessian{T<:AbstractFloat}(dist::ChiSquared, a::T, b::T)
    return one(T)
end

function hessian{T<:AbstractFloat}(dist::ChiSquared, a::T)
    return one(T)
end

function hessian!{T<:AbstractFloat}(u::Vector{T}, dist::ChiSquared, a::AbstractVector{T}, b::AbstractVector{T})
    n = get_common_len(a, b)::Int
    l = one(T)
    @simd for i = 1:n
         @inbounds u[i] = l
    end
end

function hessian!{T<:AbstractFloat}(u::Vector{T}, dist::ChiSquared, a::AbstractVector{T})
    n = length(a)::Int
    l = one(T)
    @simd for i = 1:n
        @inbounds u[i] = l
    end
end

