import io/FileReader, text/StringTokenizer, structs/[ArrayList, List, HashMap]

ZombieConfig: class {

    options := HashMap<String, String> new()

    init: func ~withDefaults (path: String, defaults: Func(Func(String, String))) {
        defaults(|k, v| options put(k, v))
        init(path)
    }

    init: func (path: String) {
	f := FileReader new(path)
	while(f hasNext?()) {
	    line := f readLine() trim()
	    if(line startsWith?('#')) continue
	    if(line empty?()) continue

            parseLine(line)
	}
    }

    /** It's also possible to pass configuration options via
        the command line. Example:

            ./app path=foobar fuuu=barfoo

        To do this, just pass your `args` object to this function.
    */
    handleCommandLine: func (args: ArrayList<String>) {
        for(i in 1..args size)
            parseLine(args[i])
    }

    /** Parse a single line like `a=bc` */
    parseLine: func (line: String) {
        tokens := line split('=')
        if(tokens size != 2) {
//		"[config] Ignored line: '%s'" printfln(line)
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
