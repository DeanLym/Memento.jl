
type LumberMill
    timber_trucks::Dict{Any, TimberTruck}
    saws::Array

    modes::Array

    function LumberMill(; timber_trucks = Dict{Any, TimberTruck}(), saws = Any[], modes = Any[])
        lm = new(timber_trucks, saws, modes)

        # defaults
        configure(lm)
        add_saw(lm, date_saw)
        add_truck(lm, LumberjackLog(STDOUT, nothing, nothing))

        lm
    end
end

# -------

function configure(lm::LumberMill; modes = ["debug", "info", "warn", "error"])
    lm.modes = modes
end

configure(; args...) = configure(_lumber_mill; args...)


function log(lm::LumberMill, mode::String, msg::String, args::Dict)
    args[:mode] = mode
    args[:msg] = msg

    for saw in lm.saws
        args = saw(args)
    end

    for (truck_name, truck) in lm.timber_trucks
        log(truck, args)
    end
end

log(mode::String, msg::String, args::Dict) = log(_lumber_mill, mode, msg, args)

log(mode::String, args::Dict) = log(_lumber_mill, mode, "", args)


function add_saw(lm::LumberMill, saw_fn::Function, index = length(lm.saws)+1)
    insert!(lm.saws, index, saw_fn)
end

add_saw(saw_fn::Function, index = length(_lumber_mill.saws)+1) = add_saw(_lumber_mill, saw_fn, index)


function remove_saw(lm::LumberMill, index = length(lm.saws))
    splice!(lm.saws, index)
end

remove_saw(index = length(_lumber_mill.saws)) = remove_saw(_lumber_mill, index)


function add_truck(lm::LumberMill, truck::TimberTruck, name = string(UUID.v4()))
    lm.timber_trucks[name] = truck
end

add_truck(truck::TimberTruck, name = string(UUID.v4())) = add_truck(_lumber_mill, truck, name)

# -------

_lumber_mill = LumberMill()

# -------