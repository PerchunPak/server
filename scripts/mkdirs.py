"""Automatically run mkdir on all used directories."""
from pathlib import Path

from . import PWD


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

    parse: "bool | str" = False
    expected_tab_count = -1
    for line in lines:
        if parse:
            if get_tab_count(line) != expected_tab_count:
                parse = False
                continue

            if parse == "volumes":
                if "${PWD}" not in parse:
                    continue

                host_path = Path(
                    line.strip().split(":")[0][2:].replace("${PWD}", str(PWD))
                )
            else:
                host_path = Path(line.strip()[8:].replace("${PWD}", str(PWD))).parent

            if not host_path.exists():
                print("creating", repr(str(host_path.resolve())))
                host_path.mkdir(parents=True, exist_ok=True)
        else:
            if line.endswith("volumes:\n"):
                parse = "volumes"
                expected_tab_count = get_tab_count(line) + 2
            elif line.endswith("env_file:\n"):
                parse = "env"
                expected_tab_count = get_tab_count(line) + 2
