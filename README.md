<h1>NaviGO</h1>

Setup
-----
Make sure the Perl, Python 2.7 and MySQL server is set up on your machine or server, first we need to create the database files used for NaviGO, you can clone NaviGO repo with the following command:
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
When script finished there should be a folder named as GO_YYYYMM for example GO_201611, and all the files should be inside this folder.


<br>
Also make sure there is the flat file for PAS, CAS, IAS scores, you can download them from our server
```bash
wget http://kiharalab.org/web/navigo/data/PAS.txt
wget http://kiharalab.org/web/navigo/data/CAS.txt
wget http://kiharalab.org/web/navigo/data/BIOGRID-3.2.107_GOpair_IASscores.txt
```


