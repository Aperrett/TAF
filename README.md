This is the Test Automation Framework (TAF)

Created in Ruby and using Watir to allow a user to Automate a website using an Excel file and exporting that file in to a XML or CSV file type.

Please see the Wiki for more details: https://github.com/Aperrett/TAF/wiki

<h2>To use the Docker container images</h2>
To build the TAF Docker container navigate to the Code/ Folder:

To build the TAF to use in a Docker conatainer use the following script in terminal:

./Start_TAF_Only.sh

This will also start the TAF container for you.

To build the TAF to use in a Docker conatainer and to use Selenium grid Docker use the following script in terminal:

./Start_TAF_With_Selenium_Grid.sh

This will also start the TAF container and selenium Grid container with the following browsers: Firefox and Chrome.

Also to note that this will Also link the TAF to the Selenium Grid Container --- Note not working at moment ---.

To access the Selenium Grid navigate to your browser: http://localhost:4444/grid/console

To run a Test Suite:

Execute "ruby main.rb [Testsuite.csv or Testsuite.xml]" in cmd line.

Note: To exit the TAF container type: 'exit' then type 'docker-compose down' to shutdown Selenium grid. 

<h2>Contributing</h2>

If you would like to get involved in supporting this project going forward please get in touch.

<h2>Author</h2>

Andy Perrett

https://github.com/Aperrett


<h2>Copyright and License</h2>

Copyright 2017 Aperrett

Code released under the MIT License.
