# README
This is a distributed worker service that exposes an API to process Linux jobs.

# Key Areas
- The Ruby on Rails API (app/controllers/jobs_controller.rb) contains the endpoints to start, stop, query the execution status and get the logs of job outputs.
- The CLI (app/bin/cli.rb) is ran in order to interact with the API in a way that authenticates identity and authorizes access to the endpoints.
- The application controller (app/controllers/application_controller.rb) acts as the gate to check that the http request is being made from a party that is authorized by way of a client certificate signed by the server private key then authorize access to the API endpoints. In the interest of time I hardcoded the path to the client certificate file in the HTTP request.
- This is the (Ruby style guide)[https://github.com/rubocop-hq/ruby-style-guide] that I am following for consistency in my coding

# Required Technology
Ruby
- If you do not have Ruby installed on your machine [please install accordingly](https://www.ruby-lang.org/en/downloads/)
Bundler
- If you do not already have bundler installed, please download bundler by running '$ gem install bundler' (https://bundler.io/)
PostgreSQL
- If you do not already have Postgresql installed, please follow the provided instructions  with Brew

# Instructions for running the program
- Run '$ bundle install' in the terminal
- Run '$ rails s' to run the rails API server
- Open a new terminal
- In your new terminal  enter '$ ruby bin/run.rb' in the terminal to begin the interactive CLI menu
