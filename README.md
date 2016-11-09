<h1>NaviGO</h1>

Setup
-----
Make sure the Perl, Python 2.7, Python 3.4 and MySQL server is set up on your machine or server, first we need to create the database files used for NaviGO, you can clone NaviGO repo with the following command:
```bash
$ git https://github.com/kiharalab/NaviGO.git
$ cd NaviGO
```
Then navigate to AutoUpdate folder:
```bash
$ cd AutoUpdate
```
If there is no tmp folder in the directory, please make one with
```bash
$ mkdir tmp
```
Now you need to modify the access.inc file to give the user and password to your MySQL server.
<br>
Next step is to run the update.pl script to generate the database used by NaviGO
```bash
$ perl update.pl
```
When script finished there should be a folder named as GO_YYYYMM for example GO_201611, and all the files should be inside this folder. Before running NaviGO, please set the paths correctly in config_template.pl and then:
```bash
$ mv config_template.pl config.pl
```

<br>
Also make sure there is the flat file for PAS, CAS, IAS scores and the paths in config.pl are correctly set, you can download them from our server with following command
```bash
wget http://kiharalab.org/web/navigo/data/PAS.txt
wget http://kiharalab.org/web/navigo/data/CAS.txt
wget http://kiharalab.org/web/navigo/data/BIOGRID-3.2.107_GOpair_IASscores.txt
```

To run protein set function on NaviGO, please create your own folder under job folder
```bash
$ cd job
$ mkdir your_job_name
$ cd your_job_name
```
Now you need to create the annotation file, the format of annotation file can be found on our server <a href="http://kiharalab.org/web/wei72/NaviGO/views/proteinset.php">NaviGO</a>, and we provided a file checker under format_check folder, currently, we are supporting our own format and also CAFA format, the format checker will convert CAFA format to our format or check the file you provided. You can run by:
```bash
$ python ../../format_check/cafa_go_format_checker.py file > annotation.txt
```

Then you can run NaviGO using:
```bash
$ perl ../../run.pl annotation.txt
```

To run GO set, you also need to:
```bash
$ cd job
$ mkdir your_job_name
$ cd your_job_name
$ cp path_to_your_go_file ./annotation.txt
$ perl execute.pl
```

To run Enrichment analysis, you need to:
```bash
$ cd job
$ mkdir your_job_name
$ cd your_job_name
$ python3.4 ../../Enrich/enrich.py -f annotation.txt -o organism_id
```

