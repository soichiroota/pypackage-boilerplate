# Minimal makefile for Sphinx documentation
#

# You can set these variables from the command line, and also
# from the environment for the first two.
SPHINXOPTS    ?=
SPHINXBUILD   ?= sphinx-build
SOURCEDIR     = .
BUILDDIR      = _build

# Put it first so that "make" without argument is like "make help".
help:
	@$(SPHINXBUILD) -M help "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

.PHONY: help Makefile

# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
%: Makefile
	@$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

build:
	docker-compose build

update:
	docker-compose run --rm lib poetry update

install:
	docker-compose run --rm lib poetry install

up:
	docker-compose up

up-build:
	docker-compose up --build

down:
	docker-compose down

test: install
	docker-compose run --rm lib poetry run pytest --cov=pypackage_boilerplate tests

lint: install
	docker-compose run --rm lib poetry run flake8 tests conf.py pypackage_boilerplate
	docker-compose run --rm lib poetry run isort --check --diff tests conf.py pypackage_boilerplate
	docker-compose run --rm lib poetry run black --check tests conf.py pypackage_boilerplate
	docker-compose run --rm lib poetry run mypy tests conf.py pypackage_boilerplate

format: install
	docker-compose run --rm lib poetry run isort tests conf.py pypackage_boilerplate
	docker-compose run --rm lib poetry run black tests conf.py pypackage_boilerplate

sphinx:
	docker-compose run --rm lib poetry run make html

sphinx-apidoc:
	docker-compose run --rm lib poetry run sphinx-apidoc -f -o ./docs ./ ./tests ./venv conf.py

build--production: update
	docker-compose run --rm lib poetry build
