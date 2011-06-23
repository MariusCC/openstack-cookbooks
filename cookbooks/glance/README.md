DESCRIPTION
===========
Chef Cookbook to install and configure Glance API and Registry and to upload AMIs.

REQUIREMENTS
============
Requires access to Glance packages and uses the `openstack` data bag item `images`. Includes the `glance-uploader.bash` from Kevin Bringard's http://github.com/kevinbringard/OpenStack-tools.

Recipes
=======
api
---
common and service

common
------
package, directories, template

registry
--------
common and service

upload
------
uploads the AMIs specified in the `openstack` data bag `images` item.

TODO
====
- can glance use the mysql for sqlconnection from nova(does it even matter?)

License
=======
Author:: Dan Prince <dan.prince@rackspace.com>

Author:: Matt Ray <matt@opscode.com>

Copyright:: 2011 Opscode, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
