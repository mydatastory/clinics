## Style Guide for Fisheries Data Story Project

In an effrot to document the organizational style of both the code and the repository, the following style guide will provide an easy reference ot understand the prganizational structure used for the project. 

All files in the "-fish" folder are updated with the following structure

#### Code Style

The coding style uses the following elements as elective options:

= for variable defintions (no <-)
"" for all character strings and column selections (no '')
a single space is provided between each element
only column names inside data frames are capitalized

#### Variable Naming Structure

2 to 6 letters
all lower case
when combing data frames, 1-3 letters from one name and 1-3 letters from another
always use unique variable names in a single document

#### Directory Structure

project specific folders use a _
generic folders include: data, fig, doc, archive
set the working directory as the repository folder

#### File naming in repository

each file should follow the format of:

content_subcontent_type_modifier.ext

Example: sardines_noaa_data_raw.csv OR fisheries_story_draft.ipynb

Some files do not have subcontent.

