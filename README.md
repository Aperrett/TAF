# [Test Automation Framework (TAF)](https://github.com/Aperrett/TAF)
[![License](https://img.shields.io/github/license/mashape/apistatus.svg)](https://opensource.org/licenses/MIT) [![Gem Version](https://badge.fury.io/rb/taf.svg)](https://badge.fury.io/rb/taf)


<div align="center">
    <img src="https://github.com/Aperrett/TAF/blob/master/Code/taf_logo.png" width="500px"</img> 
</div>
This is the Test Automation Framework (TAF)

Created in Ruby and using Watir to allow a user to Automate a website using an Json file type.

Please see the Wiki for more details: https://github.com/Aperrett/TAF/wiki

<h2>TAF Create Test Specs </h2>
Double click on `create_test_spec.html` to create test specs.


<div align="center">
    <img src="https://user-images.githubusercontent.com/32389685/57616562-5d18ae00-7576-11e9-9999-84af21586735.png" width="500px"</img> 
</div>

<h2>TAF Supported Browsers </h2>
chrome
chrome-headless
firefox
firefox-headless

<h3>TAF script help: </h3>
To use the TAF Script, Navigate to the Code/ Folder.
Run the following script: 
./taf.sh help

<h3>Security Audit of Ruby Gems used: </h3>
Run the following script: 
./taf.sh security_audit

<h2>TAF Builder</h2> 
<h3>To build the TAF Docker image:</h3>
Run the following script: 
./taf.sh build_taf_image

<h3>To build the TAF Ruby Gem</h3>
Run the following script: 
./taf.sh build_taf_gem {internal} or {external} {version} (i.e. 0.1.2)

<h2>TAF Runner - Docker</h2>
<h3>To run the TAF in Docker Container</h3>
Run following script in terminal: \
docker run --rm --shm-size 2g \
--env PORTAL_URL="http://url_blah.com" \
--env PORTAL_USER_1="emailblah.com" \
-v "$(pwd)"/target:/app/Results:cached taf taf --tests {test folder name} --browser {browser}

Please note the --env will need to be changed.

<h3>To run the TAF in debug mode (using VNC)</h3>
* Navigate to the taf project directory.
* Run `docker build -f Code/Dockerfile -t taf Code/ && docker run -e DEBUG=1 -p 5901:5901 --rm --shm-size 2g taf --tests {test folder name} --browser {browser}`

<h2>TAF Runner - Native</h2>
<h3>Pre-Requirements</h3>
Ruby 2.5.1 has to be installed on the system.

run bundle install - to install the required gems including the TAF Gem

<h3>To run a Test Suite using the TAF Gem:</h3>
taf --tests {test folder name} --browser {browser}

<h2>Contributing</h2>

If you would like to get involved in supporting this project going forward please get in touch.

<h2>Author</h2>

Andy Perrett

https://github.com/Aperrett


<h2>Copyright and License</h2>

Copyright 2017 - 2019 Aperrett

Code released under the MIT License.
