#!/usr/bin/python
#####################################################################
# This script cleans up the html code generated by Dymola,
# and it adds the link to the style sheet
#
# MWetter@lbl.gov                                          2011-05-15
#####################################################################
import os, string, fnmatch, os.path, sys
from os import listdir
from os.path import isfile, join
# --------------------------
# Global settings
LIBHOME=os.path.abspath(".")

helpDir=LIBHOME + os.path.sep + 'help'

files = [ f for f in listdir(helpDir) if f.endswith(".html") ]

replacements = {'</HEAD>':
               '<link rel=\"stylesheet\" type=\"text/css\" charset=\"utf-8\" media=\"all\" href=\"../Resources/www/modelicaDoc.css\">\n</HEAD>', 
               '<PRE></pre>':'', '<pre></PRE>':''}
for fil in files:
    filNam = helpDir + os.path.sep + fil
    filObj=open(filNam, 'r')
    lines = filObj.readlines()
    filObj.close()
    for old, new in replacements.iteritems():
        for i in range(len(lines)):
            lines[i] = lines[i].replace(old, new)
    filObj=open(filNam, 'w')
    for lin in lines:
        filObj.write(lin)
    filObj.close()
