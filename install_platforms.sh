#!/bin/bash -eux

tsuru-admin platform-add go --dockerfile https://raw.githubusercontent.com/tsuru/basebuilder/master/go/Dockerfile
tsuru-admin platform-add ruby --dockerfile https://raw.githubusercontent.com/tsuru/basebuilder/master/ruby/Dockerfile
tsuru-admin platform-add nodejs --dockerfile https://raw.githubusercontent.com/tsuru/basebuilder/master/nodejs/Dockerfile
