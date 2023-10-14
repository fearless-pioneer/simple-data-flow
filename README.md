# Python Template

[![License: Apache 2.0](https://img.shields.io/badge/license-Apache--2.0-green.svg)](https://opensource.org/licenses/Apache-2.0)
[![Python 3.10](https://img.shields.io/badge/python-3.10-blue.svg)](https://www.python.org/downloads/release/python-3100)
[![pdm-managed](https://img.shields.io/badge/pdm-managed-blueviolet)](https://pdm.fming.dev)
[![Code style: black](https://img.shields.io/badge/code%20style-black-000000.svg)](https://github.com/psf/black)
[![Imports: isort](https://img.shields.io/badge/imports-isort-white)](https://pycqa.github.io/isort)
[![Type Checking: mypy](https://img.shields.io/badge/type%20checking-mypy-red)](https://github.com/python/mypy)
[![Linting: ruff](https://img.shields.io/badge/linting-ruff-purple)](https://github.com/astral-sh/ruff)

## Preparation

Install [Python 3.10](https://www.python.org/downloads/release/python-3100/) on [Pyenv](https://github.com/pyenv/pyenv#installation) or [Anaconda](https://docs.anaconda.com/anaconda/install/index.html) and execute the following commands:

```bash
$ make init             # set up packages (need only once)
```

## Data Setup

First, create a `data` folder in the current repository path.

Next, access the [eCommerce Events History in Cosmetics Shop](https://www.kaggle.com/datasets/mkechinov/ecommerce-events-history-in-cosmetics-shop) and download the entire dataset. This will result in a file named `archive.zip`.

Lastly, unzip the zip file and move the five csv files from the `archive` folder to the `./data` directory.

## Spark Setup

TBD
