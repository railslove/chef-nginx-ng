Description
===========

Installs and sets up the Nginx Webserver. The used packages originate from
Brightbox and include Phussion Passenger support for Ruby 1.8.7, 1.9.x and 2.x

Requirements
============

Attributes
==========

Various parameters used for the reverse proxy recipe can be configured.
If you do so make sure you override them in the `override_attributes`:

    "override_attributes": {
      "nginx_ng": {
        "client_max_body_size": "10m",
        "proxy_connect_timeout": 5,
        "proxy_send_timeout": 500,
        "proxy_read_timeout": 500
      }
    }

See `attributes/default.rb` for possible parameters and the defaults and
a short description of what they do.

Usage
=====


Credits
=======

This cookbook is highly influenced by Opscode's `users` and `nginx` cookbooks.
