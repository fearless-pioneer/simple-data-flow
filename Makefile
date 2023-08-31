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
spark:
	docker compose -p spark -f docker-compose-spark.yml up -d

spark-clean:
	docker compose -p spark down -v

delta:
	bash docker-compose-delta.sh
	docker compose -p delta -f docker-compose-delta.yml up -d

delta-clean:
	docker compose -p delta down -v
	rm -rf docker-compose-delta.yml

elk:
	docker compose -p elk -f docker-compose-elk.yml up -d

elk-clean:
	docker compose -p elk down -v

jupyter:
	docker compose -p jupyter -f docker-compose-jupyter.yml up -d

jupyter-clean:
	docker compose -p jupyter down -v
