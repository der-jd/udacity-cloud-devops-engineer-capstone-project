## The Makefile includes instructions on environment setup and lint

setup:
	# Create python virtualenv
	# Activate virtualenv: 'source ~/.udacity/bin/activate'
	# Deactivate virtualenv: 'deactivate'
	if [ ! -d ~/.udacity ]; then \
		mkdir ~/.udacity; \
	fi
	python3 -m venv ~/.udacity

install:
	# This should be run from inside a virtualenv
	pip install --upgrade pip &&\
		pip install -r backend/src/requirements.txt
	cd frontend &&\
		npm install

# Separated target to install hadolint because
# target must be called locally with 'sudo' whereas on CircleCi it must be called without 'sudo'
install_hadolint:
	wget -O /bin/hadolint https://github.com/hadolint/hadolint/releases/download/v2.8.0/hadolint-Linux-x86_64 &&\
    chmod +x /bin/hadolint

lint:
	# See local hadolint install instructions: https://github.com/hadolint/hadolint
	# This is linter for Dockerfiles
	hadolint Dockerfile
	# This is a linter for Python source code linter: https://www.pylint.org/
	# This should be run from inside a virtualenv
	pylint --disable=R,C,W1203,W1202 backend/app.py

all: install install_hadolint lint
