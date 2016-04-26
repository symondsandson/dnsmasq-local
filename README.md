Dnsmasq Local Cookbook
======================
[![Cookbook Version](https://img.shields.io/cookbook/v/dnsmasq-local.svg)][cookbook]
[![Build Status](https://img.shields.io/travis/socrata-cookbooks/dnsmasq-local.svg)][travis]
[![Code Climate](https://img.shields.io/codeclimate/github/socrata-cookbooks/dnsmasq-local.svg)][codeclimate]
[![Coverage Status](https://img.shields.io/coveralls/socrata-cookbooks/dnsmasq-local.svg)][coveralls]

[cookbook]: https://supermarket.chef.io/cookbooks/dnsmasq-local
[travis]: https://travis-ci.org/socrata-cookbooks/dnsmasq-local
[codeclimate]: https://codeclimate.com/github/socrata-cookbooks/dnsmasq-local
[coveralls]: https://coveralls.io/r/socrata-cookbooks/dnsmasq-local

Installs a localhost-only instance of dnsmasq for improved DNS reliability.

Requirements
============

This cookbook currently supports Ubuntu only.

Usage
=====

Add the default recipe to your run list.

Recipes
=======

***default***

Installs dnsmasq and configures it to listen only on localhost with no caching.


Contributing
============

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Add tests for the new feature; ensure they pass (`rake`)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create a new Pull Request

License & Authors
=================
- Author: Jonathan Hartman <jonathan.hartman@socrata.com>

Copyright 2016, Socrata, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
