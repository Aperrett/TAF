# [Test Automation Framework (TAF)](https://github.com/Aperrett/TAF)
[![License](https://img.shields.io/github/license/mashape/apistatus.svg)](https://opensource.org/licenses/MIT)

This is the Test Automation Framework (TAF)

Created in Ruby and using Watir to allow a user to Automate a website using an Excel file type.

Please see the Wiki for more details: https://github.com/Aperrett/TAF/wiki


<h2>TAF script help </h2>
To use the TAF Script, Navigate to the Code/ Folder.
Run the following script: 
./taf.sh help

<h2>Security Audit of Ruby Gems used </h2>
Run the following script: 
./taf.sh security_audit

<h2>To build the TAF Docker container image</h2>
Run the following script: 
./taf.sh build_taf_image

<h2>To use the TAF Docker container image</h2>
To run the TAF to use in a Docker conatainer use the following script in terminal:
./taf.sh run_container {filename} [{browser}] - note: (browser is optional)

This will also start the TAF container for you.

<h2>To build the Selenium Grid Docker container image</h2>
Run the following script: 
./taf.sh build_selenium_grid

<h2>To use the TAF Docker container image with Selenium Grid</h2>
To build the TAF to use in a Docker conatainer and to use Selenium grid Docker use the following script in terminal:

<h3>Pre-Requirements</h3>
Make sure the TAF image has been built before running the script below:
./taf.sh run_selenium_grid {filename}

This will also start the TAF container and selenium Grid container with the following browsers: Firefox and Chrome.

To access the Selenium Grid navigate to your browser: http://localhost:4444/grid/console

<h2>TAF Native</h2>
<h3>Pre-Requirements</h3>
Ruby 2.5.1 has to be installed on the system.

run bundle install - to install the required gems

<h2>To run a Test Suite using the TAF:</h2>
./taf.sh run {filename} [{browser}] - note: (browser is optional)

<h2>Contributing</h2>

If you would like to get involved in supporting this project going forward please get in touch.

<h2>Author</h2>

Andy Perrett

https://github.com/Aperrett


<h2>Copyright and License</h2>

Copyright 2018 Aperrett

Code released under the MIT License.
