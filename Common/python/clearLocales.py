import os
import re
import sys

if len(sys.argv) < 2:
	print "usage: clearLocales.py source_file"
	sys.exit(1)

srcFileName = sys.argv[1]

def patch_file(srcFileName):
	srcFile = open(srcFileName)

	src = '';
	p = re.compile('(.*)=(.*)$', re.VERBOSE)

	for line in srcFile:
		src = src + p.sub(r'\1=\1',line)

	srcFile.close()
	srcFile = open(srcFileName, "wb")
	srcFile.write(src)
	srcFile.close()
	print "fixed file: %s" % srcFileName

def visit(arg, dirname, names):
	for name in names:
		s = dirname + "/" + name
		if not os.path.isdir(s):
			if re.search(".*\.properties$", name):
				patch_file(s)

arglist = []
if os.path.isdir(srcFileName):
	os.path.walk(srcFileName, visit, arglist)
else:
	patch_file(srcFileName)