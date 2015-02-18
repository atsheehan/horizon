# Horizon

[![Build Status](https://travis-ci.org/LaunchAcademy/event_horizon.svg?branch=master)](https://travis-ci.org/LaunchAcademy/event_horizon) [![Code Climate](https://codeclimate.com/github/LaunchAcademy/event_horizon.png)](https://codeclimate.com/github/LaunchAcademy/event_horizon) [![Coverage Status](https://coveralls.io/repos/LaunchAcademy/event_horizon/badge.png)](https://coveralls.io/r/LaunchAcademy/event_horizon)

Horizon is a Ruby on Rails application that allows users to view programming lessons and submit their solutions to them. In addition to this repository which contains the source code for the web application, there are two other major components:

* The [curriculum repository][curriculum-repo] which contains the lessons and their metadata.
* The [et gem][et-gem] that is used to download and submit challenges ([source][et-repo]).

The production version of this application is deployed to [https://horizon.launchacademy.com/][horizon-production]. A staging version is also available at [http://event-horizon-staging.herokuapp.com/][horizon-staging].

## Setup

To checkout the application and install any dependencies run the following commands:

```no-highlight
$ git clone git@github.com:LaunchAcademy/event_horizon.git
$ cd event_horizon
$ bundle
```

If this is the first time checking out the application you'll need to create a development and test database:

```no-highlight
$ rake db:setup
```

### Environment Variables

For development and test, Horizon uses the `dotenv-rails` gem to load environment variables from the `.env` file. This file is git-ignored to avoid including sensitive information in the repository but a sample file (`.env.sample`) is provided with the necessary keys.

To setup the environment variables, copy the sample file in the root of the application:

```no-highlight
$ cp .env.sample .env
```

Open the `.env` file to edit the environment variables:

```no-highlight
GITHUB_KEY=
GITHUB_SECRET=
AWS_ACCESS_KEY=
AWS_SECRET_KEY=
S3_BUCKET=
RACK_ENV=development
PORT=3000
DEFAULT_GOOGLE_CALENDAR_ID=
GOOGLE_SERVICE_ACCOUNT_EMAIL=
GOOGLE_P12_PEM=
```

The `GITHUB_KEY` and `GITHUB_SECRET` are required for user authentication via GitHub OAuth. If you have access to the [Launch Academy application settings][launch-github-apps], you can find these values in the `horizon-dev` application. If you don't have access, you can create your own application in your [GitHub application settings][personal-github-apps].

The `AWS_ACCESS_KEY`, `AWS_SECRET_KEY`, and `S3_BUCKET` are used when uploading challenges and submissions to Amazon S3. These are not required in test and development modes unless you explicitly change the [CarrierWave configuration file][carrierwave-config] to use `storage :fog`.

The `DEFAULT_GOOGLE_CALENDAR_ID`, `GOOGLE_SERVICE_ACCOUNT_EMAIL`, and `GOOGLE_P12_PEM` variables are used for the Calendar on the Horizon Dashboard.

At this point you should be able to start the web server and visit the application at [http://localhost:3000][localhost]:

```no-highlight
$ rails server

=> Booting WEBrick
=> Rails 4.1.4 application starting in development on http://0.0.0.0:3000
=> Run `rails server -h` for more startup options
=> Notice: server is listening on all interfaces (0.0.0.0). Consider using 127.0.0.1 (--binding option)
=> Ctrl-C to shutdown server
[2014-12-23 12:54:46] INFO  WEBrick 1.3.1
[2014-12-23 12:54:46] INFO  ruby 2.1.3 (2014-09-19) [x86_64-linux]
[2014-12-23 12:54:46] INFO  WEBrick::HTTPServer#start: pid=9094 port=3000
```

## Importing Assigments

### Staging
- Gain access to staging environment:  [https://event-horizon-staging.herokuapp.com/](https://event-horizon-staging.herokuapp.com/)
- Run `rake` task to import assignments:
```no-highlight
heroku run rake horizon:import_lessons --app event-horizon-staging
```

### Production
- Gain access to production environment: [https://horizon.launchacademy.com/dashboard](https://horizon.launchacademy.com/dashboard)

* Run `rake` task to import assignments:
```no-highlight
heroku run rake horizon:import_lessons --app event-horizon
```

## Database Snapshots

To capture and download a snapshot of the production database, run the following commands:

```no-highlight
$ heroku pgbackups:capture --app event-horizon
$ curl -o db/dumps/latest.dump `heroku pgbackups:url --app event-horizon`
```

To restore the snapshot to your local database, run the following command:

```no-highlight
$ pg_restore --verbose --clean --no-acl --no-owner -d event_horizon_development db/dumps/latest.dump
```

## Calendar

The Calendar feature makes use of redis to cache data. `brew install redis` and follow the instructions to start redis on system start.

A `rake horizon:create_calendar` rake task exists to create a default calendar, and populate the calendar_id field for each team if it is nil. Set the DEFAULT_GOOGLE_CALENDAR_ID in the environment before running.

## Inserting a Google PKCS12 Keyfile into the Environment (for Heroku)
```
require "google/api_client"

key = Google::APIClient::KeyUtils.load_from_pkcs12(
  "./HorizonDashboard-xxxxxxx.p12",
  "notasecret"
)

key.to_pem => ""-----BEGIN RSA PRIVATE KEY-----\nMIICXQIB..."
```

Save the return value of `key.to_pem` to the ENV as `GOOGLE_P12_PEM`.

## Encrypting a Google PKCS12 Keyfile (for Travis-CI)
Travis-CI does not like the method above for storing private keys. Encrypting the private key was the solution. Directions, [here](travis-ci-encrypting-files).

[horizon-production]: https://horizon.launchacademy.com/
[horizon-staging]: http://event-horizon-staging.herokuapp.com/
[curriculum-repo]: https://github.com/LaunchAcademy/curriculum
[et-gem]: http://rubygems.org/gems/et
[et-repo]: https://github.com/LaunchAcademy/extraterrestrial
[launch-github-apps]: https://github.com/organizations/LaunchAcademy/settings/applications
[personal-github-apps]: https://github.com/settings/applications
[carrierwave-config]: https://github.com/LaunchAcademy/event_horizon/blob/master/config/initializers/carrierwave.rb
[localhost]: http://localhost:3000
[travis-ci-encrypting-files]: http://docs.travis-ci.com/user/encrypting-files/#Using-OpenSSL
