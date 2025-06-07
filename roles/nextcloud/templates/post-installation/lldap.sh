#!/usr/bin/env sh
set -e

./occ app:enable user_ldap
./occ ldap:show-config s01 || ./occ ldap:create-empty-config

./occ ldap:set-config s01 ldapHost "ldap://{{ core_hostname }}"
./occ ldap:set-config s01 ldapPort 3890
./occ ldap:set-config s01 ldapAgentName "uid=readonly,ou=people,{{ nextcloud_ldap_base_dn }}"
./occ ldap:set-config s01 ldapAgentPassword "{{ nextcloud_ldap_agent_pass }}"
./occ ldap:set-config s01 ldapBase "{{ nextcloud_ldap_base_dn }}"
./occ ldap:set-config s01 ldapBaseUsers "{{ nextcloud_ldap_base_dn }}"
./occ ldap:set-config s01 ldapBaseGroups "{{ nextcloud_ldap_base_dn }}"
./occ ldap:set-config s01 ldapConfigurationActive 1
./occ ldap:set-config s01 ldapLoginFilter "(&(objectclass=person)(uid=%uid))"
./occ ldap:set-config s01 ldapUserFilter "(&(objectclass=person)(memberOf=cn=users,ou=groups,{{ nextcloud_ldap_base_dn }}))"
./occ ldap:set-config s01 ldapUserFilterMode 0
./occ ldap:set-config s01 ldapUserFilterObjectclass person
./occ ldap:set-config s01 turnOnPasswordChange 0
./occ ldap:set-config s01 ldapCacheTTL 600
./occ ldap:set-config s01 ldapExperiencedAdmin 0
./occ ldap:set-config s01 ldapGidNumber gidNumber
./occ ldap:set-config s01 ldapGroupFilter "(&(objectclass=groupOfUniqueNames)(|(cn=users)))"
./occ ldap:set-config s01 ldapGroupFilterGroups "users"
./occ ldap:set-config s01 ldapGroupFilterMode 0
./occ ldap:set-config s01 ldapGroupDisplayName cn
./occ ldap:set-config s01 ldapGroupFilterObjectclass groupOfUniqueNames
./occ ldap:set-config s01 ldapGroupMemberAssocAttr uniqueMember
./occ ldap:set-config s01 ldapEmailAttribute "mail"
./occ ldap:set-config s01 ldapLoginFilterEmail 0
./occ ldap:set-config s01 ldapLoginFilterUsername 1
./occ ldap:set-config s01 ldapMatchingRuleInChainState unknown
./occ ldap:set-config s01 ldapNestedGroups 0
./occ ldap:set-config s01 ldapPagingSize 500
./occ ldap:set-config s01 ldapTLS 0
./occ ldap:set-config s01 ldapUserAvatarRule default
./occ ldap:set-config s01 ldapUserDisplayName displayname
./occ ldap:set-config s01 ldapUserFilterMode 1
./occ ldap:set-config s01 ldapUuidGroupAttribute auto
./occ ldap:set-config s01 ldapUuidUserAttribute auto
./occ ldap:set-config s01 ldapExpertUsernameAttr user_id
