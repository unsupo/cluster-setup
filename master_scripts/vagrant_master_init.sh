#!/usr/bin/env bash
git clone --single-branch -b master-setup https://github.com/unsupo/cluster-setup.git \
    && cd cluster-setup \
    && sudo sh /master_scripts/master_script.sh