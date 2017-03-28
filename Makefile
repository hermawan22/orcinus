PREFIX := /usr/local/bin
CONFIG_DIRS := config
SRC := $(PWD)

.PHONY: all clean build frontend install prebuild orcinusd

all: build

prebuild:
			@npm install -g nexe

frontend:
			@git clone https://github.com/orcinustools/dashboard.git
			@npm run build:prod dashboard
			@mv ./dashboard/dist www
			@rm -rf dashboard

build: frontend
			@npm install
			@nexe

install:
			@cp -rf orcinus $(PREFIX)

clean:
			@rm -rf build orcinus

orcinusd:
			@systemctl stop docker
			@systemctl disable docker
			@cp $(CONFIG_DIRS)/orcinusd.service /lib/systemd/system
			@chmod 644 /lib/systemd/system/orcinusd.service
			@systemctl enable orcinusd
			@systemctl start orcinusd
