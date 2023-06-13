# WienerDiffusionModel.jl

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://t-alfers.github.io/WienerDiffusionModel.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://t-alfers.github.io/WienerDiffusionModel.jl/dev/)
[![Build Status](https://github.com/t-alfers/WienerDiffusionModel.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/t-alfers/WienerDiffusionModel.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/t-alfers/WienerDiffusionModel.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/t-alfers/WienerDiffusionModel.jl)

This package provide basic distribution and sampling (rng) functions (pdf, cdf, rand) for the Wiener Diffusion Model without inter-trial variability. It extends on the Distributions.jl API and is highly inspired by the RWiener package in R (Wabersich & Vandekerckhove, 2014). 

The Wiener diffusion model is a well-established mathematical model extensively used in cognitive science to analyze binary decision-making processes (Ratcliff & McKoon, 2008). This model, also known as the drift-diffusion model, conceptualizes the decision-making process as a stochastic accumulation of evidence over time until a decision threshold is reached (Ratcliff, 1978). Central to the Wiener diffusion model are four primary parameters: 

- drift rate $\nu$: 
    - the speed at which you're collecting or processing information to make a decision. Larger absolute values indicate faster decision processes.
- boundary separation or decision threshold $\alpha$: 
    - represents the amount of information needed to make a decision. Higher values correspond to more careful, slower decision-making, while lower values represent more impulsive, faster decision-making.
- non-decision time $\tau$:
    - represents the time spent on processes other than decision-making, such as stimulus encoding and motor response.
- bias $z$:
    - represents the starting point of the information accumulation process, essentially denoting initial bias towards one decision over the other.

Future releases will extend this package to incorporate inter-trial variability parameters:

- Inter-trial variability in drift rate (sv): reflects fluctuations in the speed of information processing across different trials or tasks
- Inter-trial variability in bias (sz): reflects how much the initial bias or starting point fluctuates across different trials or tasks
- Inter-trial variability in non-decision time (st): reflects variability in the time taken for processes other than decision-making across different trials or tasks.

# References

- Ratcliff, R. (1978). A theory of memory retrieval. *Psychological Review, 85*(2), 59–108. https://doi.org/10.1037/0033-295X.85.2.59
- Ratcliff, R., & McKoon, G. (2008). The diffusion decision model: Theory and data for two-choice decision tasks. *Neural Computation, 20*, 873–922. https://dooi.org/10.1162/neco.2008.12-06-420
- Wabersich, D., & Vandekerckhove, J. (2014). The RWiener package: An R package providing distribution functions for the Wiener diffusion model. *The R Journal, 6*, 49–56. R package version 1.3-3. https://journal.r-project.org/archive/2014/RJ-2014-005/RJ-2014-005.pdf