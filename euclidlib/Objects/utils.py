def call_or_get(func):
    return func() if callable(func) else func