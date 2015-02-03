#!/bin/bash -eux

tsuru-admin platform-add ruby --dockerfile https://raw.githubusercontent.com/tsuru/basebuilder/master/ruby/Dockerfile
tsuru-admin platform-add ruby20 --dockerfile https://raw.githubusercontent.com/tsuru/basebuilder/master/ruby20/Dockerfile
tsuru-admin platform-add ruby21 --dockerfile https://raw.githubusercontent.com/tsuru/basebuilder/master/ruby21/Dockerfile
tsuru-admin platform-add ruby22 --dockerfile https://raw.githubusercontent.com/tsuru/basebuilder/master/ruby22/Dockerfile

tsuru-admin platform-add nodejs --dockerfile https://raw.githubusercontent.com/tsuru/basebuilder/master/nodejs/Dockerfile
tsuru-admin platform-add go --dockerfile https://raw.githubusercontent.com/tsuru/basebuilder/master/go/Dockerfile
