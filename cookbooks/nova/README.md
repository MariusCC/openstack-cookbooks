Description
===========
Cookbook and recipes for deploying OpenStack Nova.

This Chef repository is based on the work of Anso Labs' OpenStack-Cookbooks (https://github.com/ansolabs/openstack-cookbooks). It is currently intended for deploying the point-release codenamed "Bexar", other branches will be added in time for the next release "Cactus" as well as on-going development branches.

Requirements
============
Written and tested with Ubuntu 10.10 and Chef 0.9.12. 

Attributes
==========
Attributes under the `nova` namespace.

Definitions
===========
nova_package
------------
This handles installing nova packages generically and managing them as services.

Resources/Providers
===================

Recipes
=======
all
---

api
---

common
------

compute
-------
Provides the compute functionality, currently depends on KVM.

creds
-----
Create Nova certifications, per http://wiki.openstack.org/NovaInstall/MultipleServer

dashboard
---------

default
-------

filevg
------

finalize
--------
The last cleanup steps of the install.

hostname
--------

mysql
-----

network
-------

objectstore
-----------

openldap
--------

rabbit
------

scheduler
---------

setup
-----

source
------

volume
------

Data Bags
=========

Usage
=====

License
=======
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
