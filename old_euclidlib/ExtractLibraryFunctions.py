from pathlib import Path
import re
import os

def main():
    pathlist = Path("../lib/Geometry").rglob('*.pm')
    for path in pathlist:
        path: Path
        filename = str(path)
        content = path.read_text()
        print(filename.split('/')[-1])
        for match in re.finditer(r"^sub (\w+)", content, re.MULTILINE):
            print(f"    {match.group(1)}")

if __name__ == '__main__':
    main()
