######################
#   initialization   #
######################
init:
	pip install -U pip
	pip install pdm
	pdm install
	pdm run pre-commit install

#######################
#   static analysis   #
#######################
check: format lint

format:
	pdm run black .

lint:
	pdm run mypy src
	pdm run ruff src --fix

######################
#   docker compose   #
######################
delta-lake:
	docker compose -p delta -f docker-compose-spark-delta-lake.yml up -d

delta-lake-clean:
	docker compose -p delta down -v
