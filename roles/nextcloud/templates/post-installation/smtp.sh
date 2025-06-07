#!/usr/bin/env sh
set -e

# configure smtp
./occ config:system:set mail_smtpmode --value smtp
./occ config:system:set mail_smtphost --value "{{ core_hostname }}"
./occ config:system:set mail_smtpport --value 465
