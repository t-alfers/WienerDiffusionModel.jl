var documenterSearchIndex = {"docs":
[{"location":"","page":"Home","title":"Home","text":"CurrentModule = WienerDiffusionModel","category":"page"},{"location":"#WienerDiffusionModel","page":"Home","title":"WienerDiffusionModel","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Documentation for WienerDiffusionModel.","category":"page"},{"location":"","page":"Home","title":"Home","text":"","category":"page"},{"location":"","page":"Home","title":"Home","text":"Modules = [WienerDiffusionModel]","category":"page"},{"location":"#WienerDiffusionModel.Wiener","page":"Home","title":"WienerDiffusionModel.Wiener","text":"Wiener(ν, α, τ, z)\nWiener(ν, α, τ)\n\nA struct representing a Wiener diffusion model distribution. \n\nArguments\n\nν::Real: The drift rate. This represents the speed of information accumulation or the ease of the decision process. A positive value denotes a bias towards one decision, whereas a negative value indicates a bias towards the other decision. \nα::Real: The boundary separation. This parameter represents the amount of information needed before a decision is made. Larger values denote more careful or accurate decision-making, but slower response times. Smaller values denote more impulsive decision-making with faster response times, but potentially more errors.\nτ::Real ≥ 0: The non-decision time. This represents the time taken by non-decision processes such as stimulus encoding and motor response.\nz::Real ∈ [0, 1]: The relative bias. This parameter denotes the initial bias towards one of the decisions, as a proportion of the boundary separation. When not provided, the relative bias will be fixed to 0.5 denoting equal bias towards either decision.\n\nWiener(ν, α, τ, z) \n\nparams(d)            # Get the parameters, i.e. (ν, α, τ, z)\n\n\n\n\n\n","category":"type"}]
}