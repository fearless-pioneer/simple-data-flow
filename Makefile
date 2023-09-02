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
	make delta
	make elk

compose-clean:
	make elk-clean
	make delta-clean
	make spark-clean

spark:
	docker compose -p spark -f docker-compose-spark.yml up -d

spark-clean:
	docker compose -p spark down -v

delta:
	sh docker-compose-delta.sh
	docker compose -p delta -f docker-compose-delta.yml up -d

delta-clean:
	docker compose -p delta down -v
	rm -rf docker-compose-delta.yml

elk:
	docker compose -p elk -f docker-compose-elk.yml up -d

elk-clean:
	docker compose -p elk down -v
