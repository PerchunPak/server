import shutil

from . import PWD


def move_env_files() -> None:
    for file in PWD.glob("configs/env/*"):
        copy_to = PWD / f"data/{file.stem}/.env"
        copy_to.parent.mkdir(parents=True, exist_ok=True)
        if not copy_to.exists():
            print(f"Coping {file.relative_to(PWD)} to {copy_to.relative_to(PWD)}")
            shutil.copy(file, copy_to)


if __name__ == "__main__":
    move_env_files()
