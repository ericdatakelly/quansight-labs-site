SHELL := bash 
TARGET ?= origin
# pypy.org static page and blog makefile
# type `make help` to see all options 

all: build

.PHONY: clean build help

venv_nikola/bin/nikola:  ## create a virtualenv to build the website
	@python3 -m pip install --upgrade pip
	@python3 -m venv ./venv_nikola
	@venv_nikola/bin/python -m pip install wheel
	@venv_nikola/bin/python -m pip install -r requirements.txt
	@venv_nikola/bin/nikola plugin -i localsearch

build: ## build the website if needed, the result is in ./output
	nikola build

auto: venv_nikola/bin/nikola ## build and serve the website, autoupdate on changes
	venv_nikola/bin/nikola auto -a 0.0.0.0

clean:  venv_nikola/bin/nikola  ## clean the website, usually not needed at all
	venv_nikola/bin/nikola clean

build_direct:  ## build for Netlify deployment
	echo "DEPLOY_FUTURE = True" >> conf.py
	echo "FUTURE_IS_NOW = True" >> conf.py
	nikola build

# Add help text after each target name starting with '\#\#'
help:   ## Show this help.
	@echo "\nHelp for building the website, based on nikola"
	@echo "Possible commands are:"
	@grep -h "##" $(MAKEFILE_LIST) | grep -v grep | sed -e 's/\(.*\):.*##\(.*\)/    \1: \2/'
