#!/bin/bash

INITIALIZE_SHELL=$1
ENV_NAME=$2
PYTHON_VERSION=$3
ACTIVATE=$4
CONDA_FILE=$5

if $INITIALIZE_SHELL; then
    echo "::debug::Initializing shell"
    source $CONDA/etc/profile.d/conda.sh
fi

echo "${HOME}/$CONDA/bin" >> $GITHUB_PATH
conda init --all --dry-run --verbose
source $CONDA/etc/profile.d/conda.sh

if [[ "$CONDA_FILE" != "" ]]; then
    echo "::debug::Building environment conda file $CONDA_FILE"

    if [[ "$ENV_NAME" == "" ]]; then
        ENV_NAME=$(yq -r ".conda_file" $CONDA_FILE)
    else
        ENV_NAME="$ENV_NAME"
    fi
    
    # Note: According to https://github.com/conda/conda/issues/8537, conda will create the environment even if it fails when requirements are indicated with pip. This
    # is problematic since any error will not be noticed. To fix it, we will redict any output happening in the conda command and capture it. This is what 2>&1 is for
    # since some output is being sent to STDERR. The command grep then looks for an exception CondaEnvException.

    if conda env create -n $ENV_NAME -f $CONDA_FILE 2>&1 | grep -q CondaEnvException ; then
        echo "::error file=$CONDA_FILE::Failed to build the environment indicated using conda. CondaEnvException happened"
        exit 1
    fi

    if ! [[ $(conda env list --json | jq -r --arg ENV_NAME $ENV_NAME '.envs[] | select(endswith($ENV_NAME))') ]]; then
        echo "::error file=$CONDA_FILE::Failed to build the environment indicated using conda"
        exit 1
    fi
else
    if [[ "$ENV_NAME" == "" ]]; then
        ENV_NAME="base"
    else
        ENV_NAME="$ENV_NAME"
        echo "::debug::Creating environment $ENV_NAME"
        conda create -n $ENV_NAME python=$PYTHON_VERSION
    fi
fi

if $ACTIVATE; then
    echo "::debug::Activating $ENV_NAME"
    conda activate $ENV_NAME
fi