# Dnsmasq Local Cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/dnsmasq-local.svg)][cookbook]
[![Build Status](https://img.shields.io/travis/socrata-cookbooks/dnsmasq-local.svg)][travis]

[cookbook]: https://supermarket.chef.io/cookbooks/dnsmasq-local
[travis]: https://travis-ci.org/socrata-cookbooks/dnsmasq-local

Installs Dnsmasq with an opinionated default configuration geared toward
localhost-only improved DNS reliability.

## Requirements

This cookbook currently supports both Debian-based and RHEL-based platforms.

It now requires Chef 12.10+, or Chef 12.1+ and the compat_resource cookbook.

## Usage

Set the attributes you wish and add the default recipe to your run list, or
create a recipe of your own that implements the included Chef resources.

## Recipes

***default***

Installs and configures Dnsmasq in an attribute-driven fashion.

## Attributes

***default***

The config attribute hash defaults to empty and can be overridden with settings
to be rendered out to Dnsmasq's .conf file:

    default['dnsmasq_local']['config'] = {}

Any option that contains a hyphen should be set as an attribute with an
underscore:

    default['dnsmasq_local']['config']['cache_size'] = 300

Any option that is a boolean with no value can be set to true or false to be
enabled or disabled:

    default['dnsmasq_local']['config']['proxy_dnssec'] = true

Any option that can have multiple entries can be set as either an array
(where all entries will be rendered in the config) or a hash (where entries
set to false will not be rendered):

    default['dnsmasq_local']['config']['server'] = %w(8.8.8.8)

    default['dnsmasq_local']['config']['server']['8.8.8.8'] = true

The options attribute hash defaults to empty and can be overridden with
command line options to run Dnsmasq with. The longform versions of switches
must be used, with the same underscore and boolean rules as for the config: 

    default['dnsmasq_local']['options']['bind_dynamic'] = true
    default['dnsmasq_local']['options']['enable_dbus'] = 'com.example'

The environment attribute hash can be used for setting any other environment
variables that should populate the `/etc/default/dnsmasq` file:

  default['dnsmasq_local']['environment']['IGNORE_RESOLVCONF'] = 'yes'

## Resources

***dnsmasq_local***

A parent resource that combines an app + config + service resource.

Syntax:

    dnsmasq_local 'default' do
      config(cache_size: 0)
      options(bind_dynamic: true)
      environment(IGNORE_RESOLVCONF: 'yes')
      action :create
    end

Actions:

| Action    | Description                                  |
|-----------|----------------------------------------------|
| `:create` | Install, configure, and enable+start Dnsmasq |
| `:remove` | Stop+disable and remove Dnsmasq              |

Properties:

| Property    | Default   | Description                           |
|-------------|-----------|---------------------------------------|
| config      | `nil`     | A Dnsmasq configuration hash          |
| options     | `nil`     | A Dnsmasq command line options hash   |
| environment | `{}`      | A hash of other environment variables |
| action      | `:create` | Action(s) to perform                  |

***dnsmasq_local_app***

A resource for installation and removal of the Dnsmasq app packages.

Syntax:

    dnsmasq_local_app 'default' do
      action :install
    end

Actions:

| Action     | Description                   |
|------------|-------------------------------|
| `:install` | Install the Dnsmasq package   |
| `:upgrade` | Upgrade the Dnsmasq package   |
| `:remove`  | Uninstall the Dnsmasq package |

Properties:

| Property | Default    | Description                               |
|----------|------------|-------------------------------------------|
| version  | `nil`      | Install a specific version of the package |
| action   | `:install` | Action(s) to perform                      |

***dnsmasq_local_config***

A resource for generating Dnsmasq configurations.

Syntax:

    dnsmasq_local_config 'default' do
      filename 'dns'
      config(cache_size: 100)
      no_hosts false
      server %w(8.8.8.8 8.8.4.4)
      interface(eth0: false, eth1: true)
      action :create
    end

Actions:

| Action    | Description                       |
|-----------|-----------------------------------|
| `:create` | Write out the Dnsmasq config file |
| `:remove` | Delete the Dnsmasq config file    |

Properties:

| Property        | Default                    | Description                         |
|-----------------|----------------------------|-------------------------------------|
| filename        | Derived from resource name | The /etc/dnsmasq.d filename         |
| config          | See below                  | A complete config hash \*           |
| interface       | ''                         | Listen only on the loopback         |
| cache_size      | 0                          | Disable caching                     |
| no_hosts        | true                       | Do not DNSify `/etc/hosts`          |
| bind_interfaces | true                       | Bind only to listening interfaces   |
| query_port      | 0                          | Use a static, ephemeral return port |
| \*\*            | `nil`                      | Varies                              |
| action          | `:create`                  | Action(s) to perform                |

\* A config property that is passed in will override the entirety of the
  default config, whereas individual properties passed in will be merged with
  it.

\*\* Any unrecognized property that is passed in will be assumed to be a
  correct Dnsmasq setting and rendered out to its config. These properties'
values can be `true`, `false`, integers, strings, arrays, or hashes.

***dnsmasq_local_service***

A resource for the managing the Dnsmasq service.

Syntax:

    dnsmasq_local_service 'default' do
      options(bind_dynamic: true)
      enable_dbus 'com.example'
      environment(IGNORE_RESOLVCONF: 'yes')
      action [:create, :enable, :start]
    end

Actions:

| Action     | Description                                        |
|------------|----------------------------------------------------|
| `:create`  | Set up `/etc/default/dnsmasq` and any init patches |
| `:remove`  | Remove `/etc/default/dnsmasq` and any init patches |
| `:enable`  | Enable the service                                 |
| `:disable` | Disable the service                                |
| `:start`   | Start the service                                  |
| `:stop`    | Stop the service                                   |
| `:restart` | Restart the service                                |

Properties:

| Property    | Default                      | Description                 |
|-------------|------------------------------|-----------------------------|
| options     | See below                    | A complete options hash \*  |
| \*          | `nil`                        | Varies                      |
| environment | `{}`                         | Other environment variables |
| action      | `[:create, :enable, :start]` | Action(s) to perform        |

\* Command line options can be passed in either as one complete `options` hash,
   or as individual property calls for each option.

## Maintainers

- Jonathan Hartman <jonathan.hartman@socrata.com>
