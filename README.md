# Conda Setup Action

Installs and setup conda to work in the agent.

## When to use it

Use `conda-setup-action` to configure a conda environment in a GitHub Action worker.

## Getting Started

### Inputs

| name                       | Description | Required |
|----------------------------|-------------|----------|
| initializeShell            | Indicates if the shell needs to be initialized. This should be true the first time you run this action on any worker | No |
| envName                    | Name of the environemnt to create, if any. This name is used if a name is also indicated in `condaFile`. | No |
| condaFile                  | Conda file (YAML) for the environment to create, if any. | No |
| activate                   | Inidicates if the environment has to be activated. If no environment is provided, this affects the `base` environment. Defaults to `false` | No | 
| python                     | Version of `Python` to use. If a `conda file` is provided, then the one indicated there is used. Defaults to `3.8` | No |

### Remarks

On Github Actions, agents execute bash without a profile and hence, if you try to run `conda activate` you will recieve the error `conda is not initialized`. To workaround this problem, if you want to use later `conda activate` run `source $CONDA/etc/profile.d/conda.sh` before to ensure proper initialization of `conda` in your shell.

### Example usage

**#1**
> Initialize conda but no environment is created.

```yml
name: Configuring conda
uses: pyrunit/conda-setup-action@v1.0.0
with:
    initializeShell: true
```

**#2**
> Initialize conda and create an environment from a file.

```yml
name: Configuring conda
uses: pyrunit/conda-setup-action@v1.0.0
with:
    initializeShell: true
    activate: true
    condaFile: conda_dependencies.yml
```

**#3**
> Initialize conda and create an environment from scratch with `Python` version `3.9`.

```yml
name: Configuring conda
uses: pyrunit/conda-setup-action@v1.0.0
with:
    initializeShell: true
    activate: true
    envName: myproject
    python: 3.9
```