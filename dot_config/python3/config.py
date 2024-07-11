import atexit
import os
import readline

home = os.environ["HOME"]
histfile = os.path.join(home, ".history", "python_cli")
try:
    readline.read_history_file(histfile)
    # default history len is -1 (infinite), which may grow unruly
    readline.set_history_length(1000000)
except FileNotFoundError:
    pass

atexit.register(readline.write_history_file, histfile)