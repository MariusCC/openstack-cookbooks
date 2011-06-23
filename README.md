Description
===========
The goal for this set of cookbooks is to provide a set of roles and cookbooks to deploy OpenStack Compute, Object Storage and Image Registry and Delivery Service (Nova, Swift and Glance respectively) with Chef.

This Chef repository was forked from Anso Labs' OpenStack-Cookbooks (https://github.com/ansolabs/openstack-cookbooks) shortly after "bexar" was released (it is no longer actively tracking that repository). It is intended for deploying the stable releases and currently supports "Cactus", other releases will be supported as they become available.

Requirements
============
Written and tested with Ubuntu 10.04 and 10.10 and Chef 0.10 and later. 

Roles
=====
You can use the command `rake roles` to upload all the roles provided.

openstack Data Bag
==================
In order to manage configuration of our OpenStack cloud, we will use the `openstack` data bag. You will need to configure each of the following items and load them into the `openstack` data bag when ready.

```
% knife data bag create openstack
% knife data bag from file openstack data_bags/openstack/glance.json
% knife data bag from file openstack data_bags/openstack/images.json
% knife data bag from file openstack data_bags/openstack/nova.json
```

conversely you can also just use
```
% rake databag:upload_all
```

nova
----
The `nova` item for the `openstack` data bag contains the settings for configuring Nova.

glance
------
The `glance` item for the `openstack` data bag contains the settings for configuring Glance.

images
------
The `images` item for the `openstack` data bag contains the locations, contents and metadata of the various AMIs to load into the system to make available for Nova. Good places to go for AMIs include https://uec-images.ubuntu.com and http://www.eucalyptussoftware.com/downloads/eucalyptus-images/list.php. You may want to copy these to a local site for future deployments.

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
