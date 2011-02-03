Description
===========
This is based on the work of Anso Labs' OpenStack-Cookbooks (https://github.com/ansolabs/openstack-cookbooks).

The goal for this set of cookbooks is to provide a set of roles and cookbooks to deploy OpenStack Compute and Object Storage (Nova and Swift respectively) with Chef. The plan is to provide a Bexar-release branch and then continue development on a Cactus branch.

Instructions
============

Have a Launchpad Account, have your SSH key uploaded.

Build your Ubuntu 10.04 VM.

Add your SSH key to your user - ~/.ssh/id_dsa or ~/.ssh/id_rsa

As your user, do:

curl http://c0020195.cdn1.cloudfiles.rackspacecloud.com/install-swift.sh > install-swift.sh
bash ./install-swift.sh

You'll be prompted for your username, your group (which is most likely just
your username again), your Launchpad login, and the email address you want any
bzr commits to use.

When the script completes, it will prompt you to run the commands needed to
execute the funtional test suite.

Requirements
============
Written and tested with Ubuntu 10.10 and Chef 0.9.12.

Attributes
==========
Attributes under the `openstack` namespace.

Resources/Providers
===================

Recipes
=======

Data Bags
=========

Roles
=====

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
