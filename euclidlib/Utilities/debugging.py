import os
current_debug_level = int(os.environ.get("EUCLID_DEBUG_LEVEL", 0))

def print_debug(level=0, txt=""):
    if level >= current_debug_level:
        print(txt)

