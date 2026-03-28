-- use ':hi' or ':Telescope highlights' to see the defined colors

-- STFO: hello wold something

-- PERF:

-- DECISION: this is something i did
-- this is how we do things now!

-- OPT: do something else
require("todo-comments").setup({
    keywords = {
        STFO = { icon = "", color = "stfo" },
        DECISION = { icon = "", color = "dec" },
        OPT = { icon = "", "opt" }
    },
    colors = {
        stfo = { "@keyword", "#cccccc" },
        dec = { "#cc9966", "#c68c53" },
        opt = { "@label" }
    }
});
