import yaml
import os
import subprocess

import fastapi
import uvicorn
from pathlib import Path
import pydantic
import typing as t

PWD = Path(__file__).parent.parent.parent
app = fastapi.FastAPI()


class Body(pydantic.BaseModel):
    token: str
    project: str


class ProjectInfo(pydantic.BaseModel):
    file: Path
    services: list[str]


@app.post("/")
def update_service(body: Body) -> t.Literal["success"]:
    if body.token != os.environ["TOKEN"]:
        raise fastapi.HTTPException(status_code=403, detail="Invalid token")

    if not (PWD / "projects" / f"{body.project}.yml").exists():
        raise fastapi.HTTPException(status_code=404, detail="Service not found")

    subprocess.run(["git", "pull"], cwd=PWD, check=True)
    info = get_project_info(body.project)

    for service in info.services:
        subprocess.run(["docker", "rm", "-f", f"projects-{service}-1"], check=True)

    subprocess.run(["./run.sh", str(info.file.relative_to(PWD))], cwd=PWD, check=True)

    return "success"


def get_project_info(project_name: str) -> ProjectInfo:
    project_file = PWD / "projects" / f"{project_name}.yml"
    with project_file.open("r") as file:
        data = yaml.safe_load(file)

    return ProjectInfo(
        file=project_file,
        services=list(data["services"].keys()),
    )


if __name__ == "__main__":
    assert os.environ["TOKEN"] != "", "TOKEN environment variable must be set"  # i forgot once
    uvicorn.run(app, host="0.0.0.0", port=9999, log_level="info")
