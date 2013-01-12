import io/[File, FileReader]
import text/StringTokenizer
import structs/[ArrayList, List, HashMap]

ZombieConfig: class {

    options := HashMap<String, String> new()

    init: func ~withDefaults (path: String, defaults: Func(Func(String, String))) {
        defaults(|k, v| options put(k, v))
        init(path)
    }

    init: func (path: String) {
        f := File new(path)
        if (!f exists?()) {
            "[zombieconfig]: Could not find config file: %s" printfln(path)
            return
        }

	fR := FileReader new(f)
	while(fR hasNext?()) {
	    line := fR readLine() trim()
	    if(line startsWith?('#')) continue
	    if(line empty?()) continue

            parseLine(line)
	}
    }

    /**
     *  It's also possible to pass configuration options via
     *  the command line. Example:
     *
     *      ./app --key value --key2 value2
     *
     *  To do this, just pass your `args` object to this function.
     */
    handleCommandLine: func (args: ArrayList<String>) -> ArrayList<String> {
        remainingArgs := ArrayList<String> new()

        iter := args iterator()
        iter next() // eat first arg (program name/path)

        while (iter hasNext?()) {
            item := iter next() 
            if (item startsWith?("--")) {
                key := item[2..-1]
                value := iter next()
                options put(key, value)
            } else {
                remainingArgs add(item)
            }
        }

        remainingArgs
    }

    /** Parse a single line like `a=bc` */
    parseLine: func (line: String) {
        tokens := line split('=')
        if(tokens size != 2) {
            return
        }

        (key, value) := (tokens[0] trim(), tokens[1] trim())
        options put(key, value)
    }

    has?: func (key: String) -> Bool {
        options contains?(key)
    }
}

operator [] (c: ZombieConfig, key: String) -> String {
    c options[key]
}
