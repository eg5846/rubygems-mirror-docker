#!/bin/bash

cd /rubygems-mirror
rake mirror:update
/root/bin/gen_cto.rb
