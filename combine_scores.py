import csv
import sys
import random
import re
import os
from sets import Set

# NaviGO is  released under the terms of the GNU Lesser General Public License Ver.2.1. 
# https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html

ext = "_comp.txt"

file_list = ["Human_funsim_scores",\
			"Human_funsim_scores_MF",\
			"Human_funsim_scores_BP",\
			"Human_funsim_scores_CC",\
			"Human_funsim_scores_BP+MF",\
			"Human_PAS_scores",\
			"Human_CAS_scores",\
			"Human_IAS_scores"]

hash = {}

for file in file_list:
	#print file
	#Q9NZC2  Q9Y5K6  0.176582476298049
	f = open(file + ext)

	for line in f:
		parts = line.split()
		pair = parts[0] + "-" + parts[1]
		_pair = parts[1] + "-" + parts[0]
		score = parts[2]
		
		if pair not in hash:
			if _pair in hash:
				hash[_pair][file] = score
				hash[pair] = {}
				hash[pair][file] = score
			else:
				hash[pair] = {}
				hash[pair][file] = score
				hash[_pair] = {}
				hash[_pair][file] = score
		else:
			hash[pair][file] = score
			if _pair not in hash:
				hash[_pair] = {}
			hash[_pair][file] = score
	f.close()
	
#print hash

result = {}
for file in file_list:
	#print file
	#Q9NZC2  Q9Y5K6  0.176582476298049
	f = open(file + ".txt")

	for line in f:
		parts = line.split()
		pair = parts[0] + "-" + parts[1]
		_pair = parts[1] + "-" + parts[0]
		score = parts[2]
		
		if pair not in result:
			if _pair in result:
				pass
			else:
				result[pair] = 1
				buf = ""
				buf += parts[0] + " " + parts[1]
				for method in file_list:
					buf += " " + hash[pair][method] + " "
				print buf
		else:
			pass
	f.close()