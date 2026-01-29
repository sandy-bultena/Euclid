class Bar: ...
class Foo(Bar):
    def __init__(self):
        print("created foo")

a={"foo":(Foo,"foo")}

def foo() -> tuple[type[Bar], str]:
    return a["foo"]

x: tuple[type[Bar], str]=foo()

x[0]()

