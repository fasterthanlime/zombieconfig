use zombieconfig
import zombieconfig

main: func {

    config := ZombieConfig new("empty.config", |base|
        base("width", "1024")
        base("height", "768")
    )

    launchUI(config["width"] toInt(), config["height"] toInt())
}

launchUI: func (width, height: Int) {
    "UI launched with (%d, %d) size!" printfln(width, height)
}
