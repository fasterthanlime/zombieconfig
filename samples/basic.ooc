use zombieconfig
import zombieconfig

main: func {
    config := ZombieConfig new("yourapp.config")

    launchUI(config["width"] toInt(), config["height"] toInt())
}

launchUI: func (width, height: Int) {
    "UI launched with (%d, %d) size!" printfln(width, height)
}
