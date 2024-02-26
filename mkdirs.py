"""Automatically run mkdir on all used directories."""
from pathlib import Path

PWD = Path(__file__).parent


def get_tab_count(line: str) -> int:
    count = 0
    for symbol in line:
        if symbol.isspace():
            count += 1
        else:
            break
    return count


for path in PWD.glob("projects/*.yml"):
    with path.open("r") as file:
        lines = file.readlines()

    parse = False
    expected_tab_count = -1
    for line in lines:
        if not parse and line.endswith("volumes:\n"):
            parse = True
            expected_tab_count = get_tab_count(line) + 2
        elif parse:
            if get_tab_count(line) != expected_tab_count:
                break

            host_path = Path(line.strip().split(":")[0][2:].replace("${PWD}", str(PWD)))
            if not host_path.exists():
                print("creating", repr(str(host_path.resolve())))
                host_path.mkdir(parents=True, exist_ok=True)
