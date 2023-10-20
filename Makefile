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
	@docker build --tag dtweave/zookeeper:v3.7-1.0.0 -f zookeeper/3.7/Dockerfile zookeeper/3.7/

.PHONY: import_images
import_images:
	@k3d image import dtweave/zookeeper:v3.7-1.0.0 -c develop-cluster