#!/usr/bin/env bash

set -e # exit on error

# remove already run flagr
test -f '.config-done' && rm .config-done

ldap_base_dn="{{ ['dc='] | product(domain | split('.')) | map('join') | join(',') }}"
occ='docker exec --user www-data nextcloud-aio-nextcloud php occ'

# configure smtp
$occ config:system:set mail_smtpmode --value smtp
$occ config:system:set mail_smtphost --value "{{ core_hostname }}"
$occ config:system:set mail_smtpport --value 465

# enable ldap
$occ app:enable user_ldap
$occ ldap:show-config s01 || $occ ldap:create-empty-config

$occ ldap:set-config s01 ldapHost "ldap://{{ core_hostname }}"
$occ ldap:set-config s01 ldapPort 3890
$occ ldap:set-config s01 ldapAgentName "uid=readonly,ou=people,$ldap_base_dn"
$occ ldap:set-config s01 ldapAgentPassword "{{ ('lldap-readonly@' + deployment_secret) | hash('sha256') }}"
$occ ldap:set-config s01 ldapBase "$ldap_base_dn"
$occ ldap:set-config s01 ldapBaseUsers "$ldap_base_dn"
$occ ldap:set-config s01 ldapBaseGroups "$ldap_base_dn"
$occ ldap:set-config s01 ldapConfigurationActive 1
$occ ldap:set-config s01 ldapLoginFilter "(&(objectclass=person)(uid=%uid))"
$occ ldap:set-config s01 ldapUserFilter "(&(objectclass=person)(memberOf=cn=users,ou=groups,$ldap_base_dn))"
$occ ldap:set-config s01 ldapUserFilterMode 0
$occ ldap:set-config s01 ldapUserFilterObjectclass person
$occ ldap:set-config s01 turnOnPasswordChange 0
$occ ldap:set-config s01 ldapCacheTTL 600
$occ ldap:set-config s01 ldapExperiencedAdmin 0
$occ ldap:set-config s01 ldapGidNumber gidNumber
$occ ldap:set-config s01 ldapGroupFilter "(&(objectclass=groupOfUniqueNames)(|(cn=users)))"
$occ ldap:set-config s01 ldapGroupFilterGroups "users"
$occ ldap:set-config s01 ldapGroupFilterMode 0
$occ ldap:set-config s01 ldapGroupDisplayName cn
$occ ldap:set-config s01 ldapGroupFilterObjectclass groupOfUniqueNames
$occ ldap:set-config s01 ldapGroupMemberAssocAttr uniqueMember
$occ ldap:set-config s01 ldapEmailAttribute "mail"
$occ ldap:set-config s01 ldapLoginFilterEmail 0
$occ ldap:set-config s01 ldapLoginFilterUsername 1
$occ ldap:set-config s01 ldapMatchingRuleInChainState unknown
$occ ldap:set-config s01 ldapNestedGroups 0
$occ ldap:set-config s01 ldapPagingSize 500
$occ ldap:set-config s01 ldapTLS 0
$occ ldap:set-config s01 ldapUserAvatarRule default
$occ ldap:set-config s01 ldapUserDisplayName displayname
$occ ldap:set-config s01 ldapUserFilterMode 1
$occ ldap:set-config s01 ldapUuidGroupAttribute auto
$occ ldap:set-config s01 ldapUuidUserAttribute auto
$occ ldap:set-config s01 ldapExpertUsernameAttr user_id

# configure preview generator
$occ app:install previewgenerator || $occ app:enable previewgenerator

# create already run flag
touch .config-done
