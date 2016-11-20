.PHONY: run
run:
	python server/server.py

.PHONY: setup
setup:
	pip install -r requirements.txt
	cp server/secret.py.example server/secret.py
