# sgenc-wiki-ref
This repository contains scripts that were used for research project leading to the masters thesis:

Rožek, Š. A Verified Knowledge Source and Wikipedia. [Master’s Thesis] Charles University, Faculty of Arts, Institute of Information Studies and Librarianship : Prague CZ, 2020.

Further description of the thesis (in Czech) can be found on this website: https://is.cuni.cz/studium/dipl_st/index.php?do=main&doo=detail&did=211426 

----------Data harvesting----------

For purpose of data harvesting, this repository contains script sgenc_wiki_ref.R. 

This script works with MediaWiki API and its purpose is to get data about appearance of Sociologická encyklopedie (Encyclopedia of Sociology) in czech Wikipedia. The script has defined dataframe with specific measured text strings, whose appearance is measured in czech Wikipedia and also specifically defined part for harvesting appearance of URL leading to Sociologická encyklopedie (Encyclopedia of Sociology). First of all the script collects data for a certain measured aspect (text string or URL) in JSON format and stores it in a separate variable. Then the script creates a JSON file. Later on information from json file is converted to data frame a CSV file is produced. Every produced file is stored in a folder with date and time in its name (YYYY-MM-DD_HOURS:MINUTES:SECONDS). Every folder contains files with backlinks from Czech Wikipedia to Czech Sociological Encyclopedia, appearance of its Czech title on Wikipedia and also appearance of titles of printed original works, which this online Encyclopedia contains. Namely every folder contains JSON and CSV files with following measured aspects:
* Backlinks from Czech Wikipedia to Czech sociological Encyclopedia (the ext_usage.{json|csv} and ext_usage_http.{json|csv} files) 
* Appearance of text string "Sociologická encyklopedie" on Czech Wikipedia
* Appearance of text string "Velký sociologický slovník" on Czech Wikipedia
* Appearance of text string "Malý sociologický slovník" on Czech Wikipedia
* Appearance of text string "Slovník českých sociologů" on Czech Wikipedia
* Appearance of text string "Slovník sociologického zázemí české sociologie" on Czech Wikipedia

The JSON files contain the raw responses of the MediaWiki API. The CSV files contain the same information presented in tabular form.
The backlinks CSV files have the following columns:
* (blank): record number
* page_id: the ID of the page where the link was found 
* title: the title of the page
* url: the URL of the page

The text string appearance CSV files have the following columns:
* (blank): record number
* article_titles: the title of the Wikipedia article where the search term appeared
* article_id: the ID of the Wikipedia article where the search term appeared
* article_text_mention: a snippet of the article text where the search term appeared

Complete dataset with references to the Encyclopedia of Sociology(Sociologická encyklopedie, https://encyklopedie.soc.cas.cz/, in Czech language only) from articles on the Czech Wikipedia in the period from 2020-03-12 to 2020-07-19 is stored and freely available at Zenodo: https://zenodo.org/record/3955721#.Xxqqn_gzZsM

----------Data analysis----------

For purposes of data analysis, multiple scripts were created. First of all it is mandatory to to create a folder (set in R studio as working directory) that contains Setup.R, init_dataset_R, analysis.R and also 2 specific folders called rstudio_import and rstudio_data. Rstudio_data should be kept empty. Rstudio_import have to contain file articles_edited_list.csv and also folder for each for each day of the data harvesting process. Name of the folders is kept the same as the one from the originally harvested data, but it is necessary to only contain ext_usage.csv file in each folder. That can be done for example via bash command: cp -v  -- parents  ./*/ext.usage.csv ../rstudio_import

1. Setup.R

This is the main script developed for preparing needed libraries and folders, loading processing functions and creating complete dataset. Script checks for rstudio_import and rstudio_data folders and creates them if not found in working directory.

Then the script processes data provided by folder rstudio_import and for each folder with ext_usage.csv file, the script creates a new CSV file  in rstudio_data with name format „YYYY-MM-DD_ext_usage.csv“. 

Then the script checks for specific libraries and installs them if not found. Then the script also loads processing functions from init_dataset.R, graph.R and analysis.R.

Nevertheless the script runs processing function init_dataset and stores created dataset from rstudio_data into variable "ds". It also runs init_articles_edited and add_page_id_to_ae functions, which results in loading list of edited articles and adding articles ID’s to them.


2. init_dataset.R

This script contains several processing functions. First one is init_dataset, which creates the dataset from the data provided by folder rstudio_data. Except for columns present in each ext_usage.csv file it also adds a new column called date_harvested. Then it sets the date_harvested column as date format. Later it also applies filters, which filter out data outside the Wikipedia mainspace.

Second function is init_articles_edited. This function loads the file  articles_edited_list.csv. Following function add_page_id_to_ae then appends page ID to each row via looking up for the same page name in ds variable.

3. Analysis.R

This script's main function get_difference serves for analysis purpose of finding newly created backlinks to Sociologická encyklopedie. Get_difference functions first of all filters data in chosen range, filters out articles edited by researcher and then filters out articles present before chosen from date.

4. Graph.R

This script and its function graph_labels serves for creation of plot from previously collected and processed data that are stored in variables "ds" and "ae". The defined function graph_labels first of all creates a new column called contains_edited with values TRUE or FALSE. Then it creates plot comments column for later display of specific important dates of the experiment in the plot. Later on the ggplot library with usage of geom_area displays two separate areas according to TRUE and FALSE values defined for appearance of edited articles. Then it creates plot lagend and also displays numbers instead of month abbreviations. Later on the ggplot draws points and displays text description for previously defined important dates. Nevertheless it adds title and axis names to the plot and  presents plot in certain range of values (75, 175).
