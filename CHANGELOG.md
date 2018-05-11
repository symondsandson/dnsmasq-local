# Dnsmasq-Local Cookbook CHANGELOG

This file is used to list changes made in each version of the dnsmasq-local
cookbook.

## 2.3.0 (2018-05-03)

- Inherit test configs from a central repo where possible
- Disable systemd-resolved on Systemd platforms
- Run integration tests with Microwave

## v2.2.1 (2018-04-02)

- Resolve a new style offense

## v2.2.0 (2018-02-09)

- Resolve all new style offenses
- Run sub-resources in the main resource's run context instead of root

## v2.1.0 (2017-05-20)

- Run app, config, and service resources in the root run context

## v2.0.0 (2017-05-18)

- BREAKING CHANGE: Drop Chef 11 compatibility, test against Chef 13 and 12
- BREAKING CHANGE: Change the default config file from dns.conf to default.conf
- Convert all the HWRPs to Chef custom resources
- Patch the custom resources for Chef 13 compatibility
- Support multiple config resources with different filename properties
- Work around a failure condition with the :remove action on RHEL6
- Add an environment property and attribute for passing to the service resource

## v1.1.0 (2016-08-11)

- Remove 'proxy-dnssec' as a default setting

## v1.0.0 (2016-08-09)

- Add support for RHEL and RHEL-alike platforms
- Replace the "environment" attribute/property with command line "options"
- Add an :upgrade action to the dnsmasq_local_app resource
- Add a "version" attribute to the dnsmasq_local_app resource
- Bypass NetworkManager's Dnsmasq management if it's running

## v0.5.0 (2016-07-26)

- Support hashes as config properties

## v0.4.0 (2016-06-24)

- Take over management of the Dnsmasq environment variables
- Add a warning comment to all Chef-managed config files

## v0.3.0 (2016-05-26)

- Fix custom config properties/attributes under Chef 11
- Support arrays for config attributes with >1 value (e.g. "server")

## v0.2.0 (2016-05-18)

- Ensure the APT cache is up to date before installing
- Refactor config merging to avoid attribute collision warnings

## v0.1.0 (2016-05-06)

- Initial release!

## v0.0.1 (2016-04-25)

- Development started
