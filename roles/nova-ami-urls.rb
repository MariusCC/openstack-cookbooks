name "nova-ami-urls"
description "Feed in a list URLs for AMIs to download"
default_attributes(
                   "nova" => {
                     "images" => [
                                  "http://192.168.11.5/ubuntu1010-UEC-localuser-image.tar.gz"
                                 ]
                   }
                   )
