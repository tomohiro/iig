IIG [![Stillmaintained](http://stillmaintained.com/Tomohiro/iig.png)](http://stillmaintained.com/Tomohiro/iig)
================================================================================

HatenaBookmark Interest IRC Gateway

[![Dependency Status](https://gemnasium.com/Tomohiro/iig.png)](https://gemnasium.com/Tomohiro/iig)
[![Code Climate](https://codeclimate.com/github/Tomohiro/iig.png)](https://codeclimate.com/github/Tomohiro/iig)


Requirements
-------------------------------------------------------------------------------

- Ruby 1.9.3 or later


Installation
--------------------------------------------------------------------------------

### Bundler

```sh
$ git clone git://github.com/Tomohiro/iig.git
$ cd iig
$ bundle install --path vendor/bundle
```


Usage
--------------------------------------------------------------------------------

### Start service

```sh
$ bundle exec iig
```

Example: Change listen IP address, port.

```sh
$ bundle exec iig --server 192.168.10.1 --port 16667
```


### Connect the IIG

1. Launch a IRC client.(Limechat, irssi, weechat...)
2. Connect the server(option is below)


#### Options

Setting server properties.

option    | value
--------- | ------------------
Real name | Hatena username
Password  | Hatena password


### Channels

Channel     | Description                     | Auto join
----------- | ------------------------------- | ---------
`#interest` | HatenaBookmark Interest entries | yes


LICENSE
--------------------------------------------------------------------------------

&copy; 2013 Tomohiro TAIRA.
This project is licensed under the MIT license.
See LICENSE for details.
