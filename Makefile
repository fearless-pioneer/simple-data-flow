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
	make spark-cluster
	make elk

compose-clean:
	make elk-clean
	make spark-cluster-clean

spark-cluster:
	docker compose -p spark -f docker-compose-spark.yml up -d

spark-cluster-clean:
	docker compose -p spark down -v
	docker rmi spark-spark-master spark-spark-notebook

elk:
	docker compose -p elk -f docker-compose-elk.yml up -d

elk-clean:
	docker compose -p elk down -v
