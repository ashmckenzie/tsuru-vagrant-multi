#!/bin/bash -ux

tsuru-admin platform-add go --dockerfile https://raw.githubusercontent.com/ashmckenzie/basebuilder/master/go/Dockerfile
tsuru-admin platform-add ruby --dockerfile https://raw.githubusercontent.com/ashmckenzie/basebuilder/master/ruby/Dockerfile
tsuru-admin platform-add nodejs --dockerfile https://raw.githubusercontent.com/ashmckenzie/basebuilder/master/nodejs/Dockerfile
