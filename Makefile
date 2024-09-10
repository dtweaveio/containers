# ==============================================================================
# 定义全局 Makefile 变量方便后面引用

.PHONY: copy
copy:
	@cp -r ./3.5/debian-11/scripts/opt/* /opt/

.PHONY: minideb-bullseye
minideb-bullseye:
	@docker build --tag dtweave/minideb:bullseye -f minideb/bullseye/Dockerfile minideb/bullseye

.PHONY: minideb-bookworm
minideb-bookworm:
	@docker build --tag dtweave/minideb:bookworm -f minideb/bookworm/Dockerfile minideb/bookworm

.PHONY: minideb-java8-bullseye
minideb-java8-bullseye:
	@docker build --tag dtweave/minideb-java8:bullseye -f minideb-java8/bullseye/Dockerfile minideb-java8/bullseye

.PHONY: minideb-java8-bookworm
minideb-java8-bookworm:
	@docker build --tag dtweave/minideb-java8:bookworm -f minideb-java8/bookworm/Dockerfile minideb-java8/bookworm

.PHONY: zookeeper
zookeeper:
	@docker build --tag dtweave/zookeeper:v3.7-1.0.0 -f zookeeper/3.7/Dockerfile zookeeper/3.7

.PHONY: hadoop-common
hadoop-common:
	@docker build --tag dtweave/hadoop-common:v3.3.4 -f hadoop-common/3.3.4/Dockerfile hadoop-common/3.3.4

.PHONY: hadoop-hdfs
hadoop-hdfs:
	@docker build --tag dtweave/hadoop-hdfs:v3.3.6 -f hadoop-hdfs/3.3.6/Dockerfile hadoop-hdfs/3.3.6

.PHONY: journalnode
journalnode:
	@docker build --tag dtweave/hdfs-journalnode:v3.3.4-1.0.0 -f hadoop-hdfs/3.3.4/journalnode/Dockerfile hadoop-hdfs/3.3.4/journalnode

.PHONY: namenode
namenode:
	@docker build --tag dtweave/hdfs-namenode:v3.3.4-1.0.0 -f hadoop-hdfs/3.3.4/namenode/Dockerfile hadoop-hdfs/3.3.4/namenode

.PHONY: datanode
datanode:
	@docker build --tag dtweave/hdfs-datanode:v3.3.4-1.0.0 -f hadoop-hdfs/3.3.4/datanode/Dockerfile hadoop-hdfs/3.3.4/datanode

.PHONY: hive
hive:
	@docker build --tag dtweave/hive-metastore:v3.1.3-1.0.0 -f hive/3.1.3/metastore/Dockerfile hive/3.1.3/metastore/

.PHONY: hmaster
hmaster:
	@docker build --tag dtweave/hbase-hmaster:v2.5.6-1.0.0 -f hbase/2.5.6/hmaster/Dockerfile hbase/2.5.6/hmaster

.PHONY: hregionserver
hregionserver:
	@docker build --tag dtweave/hbase-hregionserver:v2.5.6-1.0.0 -f hbase/2.5.6/hregionserver/Dockerfile hbase/2.5.6/hregionserver

.PHONY: hive-spark-common
hive-spark-common:
	@docker build --tag dtweave/hive-spark-common:hive3.1.3-spark3.4.1-1.0.0 -f hive-spark-common/hive3.1.3-spark3.4.1/Dockerfile hive-spark-common/hive3.1.3-spark3.4.1

.PHONY: import_images
import_images:
	@k3d image import dtweave/hive-metastore:v3.1.3-1.0.0 -c kb-playground
#	@k3d image import dtweave/zookeeper:v3.7-1.0.0 -c kb-playground
#	@k3d image import dtweave/hadoop-common:v3.3.4 -c kb-playground
#	@k3d image import dtweave/hdfs-namenode:v3.3.4-1.0.0 -c kb-playground
#	@k3d image import dtweave/hdfs-journalnode:v3.3.4-1.0.0 -c kb-playground
#	@k3d image import dtweave/hdfs-datanode:v3.3.4-1.0.0 -c kb-playground
#	@k3d image import bitnami/solr:8.11.2 -c develop-cluster
#	@k3d image import dtweave/hbase-hmaster:v2.5.6-1.0.0 -c develop-cluster
#	@k3d image import dtweave/hbase-hregionserver:v2.5.6-1.0.0 -c develop-cluster
#	@k3d image import dtweave/hdfs-journalnode:v3.3.4-1.0.0 -c develop-cluster
#	@k3d image import dtweave/hdfs-namenode:v3.3.4-1.0.0 -c develop-cluster
#	@k3d image import dtweave/hdfs-datanode:v3.3.4-1.0.0 -c develop-cluster


.PHONY: minideb-build
minideb-build:
	@docker buildx build --platform linux/amd64,linux/arm64 --tag dtweave/minideb:bullseye -f minideb/bullseye/Dockerfile minideb/bullseye --push

.PHONY: minideb-java8-build
minideb-java8-build:
	@docker buildx build --platform linux/amd64,linux/arm64 --tag dtweave/minideb-java8:bullseye -f minideb-java8/bullseye/Dockerfile minideb-java8/bullseye --push

.PHONY: zookeeper-build
zookeeper-build:
	@docker buildx build --platform linux/amd64,linux/arm64 --tag dtweave/zookeeper:v3.7-1.0.0 -f zookeeper/3.7/Dockerfile zookeeper/3.7/ --push