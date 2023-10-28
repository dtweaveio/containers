# ==============================================================================
# 定义全局 Makefile 变量方便后面引用

.PHONY: copy
copy:
	@cp -r ./3.5/debian-11/scripts/opt/* /opt/

.PHONY: minideb
minideb:
	@docker build --tag dtweave/minideb:bullseye -f minideb/bullseye/Dockerfile minideb/bullseye

.PHONY: minideb-java8
minideb-java8:
	@docker build --tag dtweave/minideb-java8:bullseye -f minideb-java8/bullseye/Dockerfile minideb-java8/bullseye

.PHONY: zookeeper
zookeeper:
	@docker build --tag dtweave/zookeeper:v3.7-1.0.0 -f zookeeper/3.7/Dockerfile zookeeper/3.7

.PHONY: hadoop-hdfs
hadoop-hdfs:
	@docker build --tag dtweave/hadoop-hdfs:v3.3.6 -f hadoop-hdfs/3.3.6/Dockerfile hadoop-hdfs/3.3.6

.PHONY: journalnode
journalnode:
	@docker build --tag dtweave/hdfs-journalnode:v3.3.6-1.0.0 -f hadoop-hdfs/3.3.6/journalnode/Dockerfile hadoop-hdfs/3.3.6/journalnode

.PHONY: import_images
import_images:
	@k3d image import dtweave/zookeeper:v3.7-1.0.0 -c develop-cluster

.PHONY: minideb-build
minideb-build:
	@docker buildx build --platform linux/amd64,linux/arm64 --tag dtweave/minideb:bullseye -f minideb/bullseye/Dockerfile minideb/bullseye --push

.PHONY: minideb-java8-build
minideb-java8-build:
	@docker buildx build --platform linux/amd64,linux/arm64 --tag dtweave/minideb-java8:bullseye -f minideb-java8/bullseye/Dockerfile minideb-java8/bullseye --push

.PHONY: zookeeper-build
zookeeper-build:
	@docker buildx build --platform linux/amd64,linux/arm64 --tag dtweave/zookeeper:v3.7-1.0.0 -f zookeeper/3.7/Dockerfile zookeeper/3.7/ --push