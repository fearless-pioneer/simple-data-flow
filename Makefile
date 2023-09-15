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
compose:
	make spark
	make elk

compose-clean:
	make elk-clean
	make spark-clean

spark:
	docker compose -p spark -f docker-compose-spark.yml up -d

spark-clean:
	docker compose -p spark down -v

elk:
	docker compose -p elk -f docker-compose-elk.yml up -d

elk-clean:
	docker compose -p elk down -v
