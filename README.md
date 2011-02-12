Description
===========
The goal for this set of cookbooks is to provide a set of roles and cookbooks to deploy OpenStack Compute and Object Storage (Nova and Swift respectively) with Chef.

This Chef repository is based on the work of Anso Labs' OpenStack-Cookbooks (https://github.com/ansolabs/openstack-cookbooks). It is currently intended for deploying the point-release codenamed "Bexar", other branches will be added in time for the next release "Cactus" as well as on-going development branches.

Requirements
============
Written and tested with Ubuntu 10.10 and Chef 0.9.12. 

Roles
=====
nova-single-machine-install
---------------------------
Installs Nova on a single node with all dependencies.

nova-cloud-controller
---------------------
Cloud controller that runs the nova- services.

rabbitmq-server
---------------
Installs RabbitMQ with the Opscode cookbook.

Usage
=====

Currently FlatDHCP

Single Box
----------
nova-single-machine-install

2 Boxes
-------
nova-cloud-controller
nova-compute-node

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
