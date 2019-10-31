# README

Selina mock

Rails version             6.0.0
Ruby version              ruby 2.6.5p114 (2019-10-01 revision 67812) [x86_64-darwin18]

Installation:

bundle install

If mysql2 is giving you a hard time, try and:

`gem install mysql2 -v '0.5.2' -- --with-cflags=\"-I/usr/local/opt/openssl/include\" --with-ldflags=\"-L/usr/local/opt/openssl/lib\"`

After bundle install is completed, run:

`rails db:migrate db:seed`

`rails s`


Tests:
rspec