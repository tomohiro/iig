IIG
================================================================================

HatenaBookmark Interest IRC Gateway

[![Stillmaintained](http://stillmaintained.com/Tomohiro/iig.png)](http://stillmaintained.com/Tomohiro/iig)
[![Build Status](https://img.shields.io/travis/Tomohiro/iig.svg?style=flat-square)](https://travis-ci.org/Tomohiro/iig)
[![Dependency Status](https://img.shields.io/gemnasium/Tomohiro/iig.svg?style=flat-square)](https://gemnasium.com/Tomohiro/iig)
[![Code Climate](https://img.shields.io/codeclimate/github/Tomohiro/iig.svg?style=flat-square)](https://codeclimate.com/github/Tomohiro/iig)

![IIG screenshot](screenshot.png)


Requirements
-------------------------------------------------------------------------------

- Ruby 2.2.2


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

### Start the IIG server

```sh
$ bundle exec iig
```

Example: Change listen IP address, port.

```sh
$ bundle exec iig --host 192.168.10.1 --port 16667
```


### Connect the IIG

1. Launch a IRC client.(Limechat, irssi, weechat...)
2. Connect the server


#### Server options

If you want check the command-line options, following type command.

```sh
$ bundle exec iig --help
```

Option       | Value                              | Default
-----------  | ---------------------------------- | ----------
-p, --port   | Port number to listen              | 16704
-h, --host   | Host name or IP address to listen  | 0.0.0.0
-w, --wait   | Wait SECONDS between retrievals    | 3600(sec)
-l, --log    | Log file                           | STDOUT


#### IRC Client options

Setting server properties.

Option    | Value
--------- | ------------------
Real name | Hatena username
Password  | Hatena password


### Channels

Channel     | Description                     | Auto join
----------- | ------------------------------- | ---------
`#interest` | HatenaBookmark Interest entries | yes


LICENSE
--------------------------------------------------------------------------------

&copy; 2013 - 2015 Tomohiro TAIRA.
This project is licensed under the MIT license.
See LICENSE for details.
