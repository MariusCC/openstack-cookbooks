Description
===========
The goal for this set of cookbooks is to provide a set of roles and cookbooks to deploy OpenStack Compute, Object Storage and Image Registry and Delivery Service (Nova, Swift and Glance respectively) with Chef.

This Chef repository was forked from Anso Labs' OpenStack-Cookbooks (https://github.com/ansolabs/openstack-cookbooks) shortly after "bexar" was released (it is no longer actively tracking that repository). It is intended for deploying the stable releases and currently supports "Cactus", other releases will be supported as they become available.

Requirements
============
Written and tested with Ubuntu 10.04 and 10.10 and Chef 0.9.16 and later. 

Usage
=====
The file `infrastructure.yml` may be used with the [http://bit.ly/spcwsl](Spiceweasel) command to generate the knife commands to download and install the cookbooks and upload the roles. 

Documentation
=============
[http://bit.ly/OSChef](http://bit.ly/OSChef "Deploying OpenStack with Chef") has an extensive write-up with much more detail about using this repository.

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
