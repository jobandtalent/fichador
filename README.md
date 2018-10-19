# README

This app is published as https://

## Environment

This is a Ruby 2.5.x + Rails 5.2.x project + Webpack 4.x project.

## System dependencies

Dependencies are identified as _Soft_, _Hard_, _Optional_, _Development_.

Hard: is a must and must be working/available to be able to use Workers. Without this dependency major outage is expected.

Soft: is required, but this service could operate with minor non-operative features or managed recovery/healing. But is desirable to restablish the service as soon as posible.

Optional: adds some extra features, but in case of not being presents there is no impact on users.

Development: required to develop the app, not needed during runtime.

### Direct dependencies

This application depends directly this dependencies. All services must be configured and running.

#### Postgresql +10.4 [Hard]

    #### ??? Redis +3.0 [Hard]

    ### 3rd party services

    #### ??? Google OAuth 2.0 [Soft]

    #### ??? Rollbar [Optional]

    #### ??? Google Analytics [Optional]

## Configuration

## Database creation

   rails db:create

## Database initialization

No needed

## Running the test suites

### Unit & integration tests:

    PARALLEL_TEST_GROUPS=Default rails test

Don't set any value to `PARALLEL_TEST_GROUPS` to skip code coverage generation.

### System tests:

Ensure the assets (javascript, images and css) are compiled in test mode.

    yarn build-for-tests

There are a "live" mode to rebuild the assets when changes are detected in the assets.

    yarn server-for-tests

Note: For dockerized environments use the following command to ensure the assets for tests are built.

    docker exec workers-webpack yarn server-for-tests

This command will keep the assets compiled according to the last syncrhonized sources and produce the output on the `public/packs-tests` directory which is mounted in the `workers` container where the tests are run.

Run the tests

    PARALLEL_TEST_GROUPS=System rails test:system

This tests includes tests being executed in a real browser. The default configuration needs a Google Chrome locally installed. In `test/support/application_system_test_case.rb` you can change the configuration for Selenium to use other browser (values as `firefox` or `safari` are already supported). Or you can use a remote Selenium driver, setting the ENV var `SELENIUM_SERVER_URL` with the URL to the server, for example:

    SELENIUM_SERVER_URL=http://localhost:4444/wd/hub rails test:system

Don't set any value to `PARALLEL_TEST_GROUPS` to skip code coverage generation.

### Ruby linting (currently not enforced by continuous integration process):

    rubocop

### Javascript client tests:

    yarn test

Adding the `--watch` modifier the test will run against any new changed file.

### Javascript linting:

    yarn eslint

Using `yarn eslint-watch` the linting will be reevaluated after changes in the code.

### Security check on dependencies:

    brakeman -c config/brakeman.yml

No errors are admitted. Continuous integration will fail if some error is detected.

## Development instructions

To run the development version of this service you need to start the following software pieces:

### Web Application

    rails server

### Web client (JS + CSS + other assets)

    yarn server

Usually this command will be enough, but in case of need some special config, you can change the port, server address and other arguments supported by `webpack-dev-server`, i.e.:

    yarn server --port 8001

This configuration will launch the UI (web) for [webpack-bundle-analizer](https://github.com/webpack-contrib/webpack-bundle-analyzer). This plugin shows the packages includes in each Javascript output file, is useful to debugging the webpack's configuration and optimize the bundles.

### Postgresql

A Postgresql instance running and configured according to `config/database.yml`.

## Deployment instructions

Deployment to staging & production is configured in continuous deployment mode. Just push to the origin branch, and Codeship will take care.

For production the origin branch is `master`. The continuous deployment for `master` will no really update the service in `production` you need to ask `manuel deploy workers to production` in the [Deploys] channel in Slack.
