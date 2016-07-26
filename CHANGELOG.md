Dnsmasq Local Cookbook CHANGELOG
================================

v0.5.0 (2016-07-26)
-------------------
- Support hashes as config properties

v0.4.0 (2016-06-24)
-------------------
- Take over management of the Dnsmasq environment variables
- Add a warning comment to all Chef-managed config files

v0.3.0 (2016-05-26)
-------------------
- Fix custom config properties/attributes under Chef 11
- Support arrays for config attributes with >1 value (e.g. "server")

v0.2.0 (2016-05-18)
-------------------
- Ensure the APT cache is up to date before installing
- Refactor config merging to avoid attribute collision warnings

v0.1.0 (2016-05-06)
-------------------
- Initial release!

v0.0.1 (2016-04-25)
-------------------
- Development started
