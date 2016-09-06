Key to Filenames for .json Files Extracted from the SSM Database
2016-09-06

The Bash shell script extractMaps.sh pulls each System Support Map .json file
out from the Postgresql database on the server and writes it to a .json file.
Each filename is:

<state>\_<affilsa><affilfm><affilhp><affilep><affilss><affillos>\_<em><id>.json

where the generic names inside the <brackets> have the following values (all
except <id> are what the user entered on the System Support Map Wizard's
"Create a New Account" page):

* <state> "State/Territory/Country" 

* \<affilsa> "Self Advocate" affiliation: single character 't' if user selected
this check box, 'f' if blank

* <affilfm> "Family Member/Representative" affiliation: 't' or 'f' as above

* <affilhp> "Health Provider or Professional" affiliation: 't' or 'f'

* <affilep> "Education Provider or Professional" affiliation: 't' or 'f'

* <affilss> "State Maternal Child Health Agency Staff" affiliation: 't' or 'f'

* <affillos> "Community-Based or Local Organization Staff" affiliation: 't' or 'f'

* <em> "Email address" up to but not including the '@' sign

* <id> The unique integer identifier for this specific map.

Example: 

* State/Territory/Country: "North Dakota"
* "Self Advocate": not selected
* "Family Member/Representative": not selected
* "Health Provider or Professional": selected
* "Education Provider or Professional": selected
* "State Maternal Child Health Agency Staff": selected
* "Community-Based or Local Organization Staff": not selected
* Email address: "bob\_johnson.77@interop.org"
* Map id: 654

filename: NorthDakota\_fftttf\_bob\_johnson.77\_654.json

If Bob subsequently creates a second map with id = 765, the resulting filename
will be NorthDakota\_fftttf\_bob\_johnson.77\_765.json.

Note that all blanks have been removed from the filename: some systems don't 
handle filenames with spaces in them, in particular the CentOS (Linux) operating
system that hosts the server, the database, and the extractMaps.sh shell script.
