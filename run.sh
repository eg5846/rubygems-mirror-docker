#!/bin/bash

rm /mirror/rubygems.org/content.cto
cd /rubygems-mirror
rake mirror:update && /root/bin/gen_cto.rb
