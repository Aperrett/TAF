This is the Test Automation Framework (TAF)

Created in Ruby and using Watir to allow a user to Automate a website using an Excel file and exporting that file in to a XML or CSV file type.

Please see the Wiki for more details: https://github.com/Aperrett/TAF/wiki

<h2>To use the Docker container image</h2>
To build the Docker container navigate to the Code/ Folder:

execute "docker build -t taf ./" in cmd line.

To run the container in a interactive shell:

execute "docker run —rm -it taf sh " in cmd line.

To run a Test Suite:

execute "ruby main.rb [Testsuite.csv or Testsuite.xml]" in cmd line.

Enjoy and Thank you :) 

<h2>Author</h2>

Andy Perrett

https://github.com/Aperrett


<h2>Copyright and License</h2>

Copyright 2017 Aperrett

Code released under the MIT License.
