from euclidlib.Objects import convert_to_coord


def call_or_get(func):
    return func() if callable(func) else convert_to_coord(func)