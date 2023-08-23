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

delta-lake:
	bash docker-compose-delta-lake.sh
	docker compose -p delta-lake -f docker-compose-delta-lake.yml up -d

delta-lake-clean:
	docker compose -p delta-lake down -v
	rm -rf docker-compose-delta-lake.yml

elk:
	docker compose -p elk -f docker-compose-elk.yml up -d

elk-clean:
	docker compose -p elk down -v
