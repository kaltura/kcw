import os
import re
import sys

if len(sys.argv) < 3:
	print "usage: addComment.py comment_file source_file"
	sys.exit(1)

licenseFileName = sys.argv[1]
srcFileName = sys.argv[2]

licenseFile = open(licenseFileName)
license = licenseFile.read(100000)
licenseFile.close()

license += "\n"

def patch_file(license, srcFileName):
	srcFile = open(srcFileName)
	src = srcFile.read(1000000)
	srcFile.close()

	if re.search(r"/\*.*?copyright.*?\*/", src, re.DOTALL | re.IGNORECASE) or src.find(license) != -1:
		return

	r = re.search("(^\s*<\?xml.*?\?>\s*)", src, re.DOTALL)
	if r:
		e = r.end()
		src = src[:e] + "<!--" + license + "-->\n" + src[e:]
	else:
		src = license + src

	srcFile = open(srcFileName, "wb")
	srcFile.write(src)
	srcFile.close()
	print "fixed file: %s" % srcFileName


def visit(arg, dirname, names):
	for name in names:
		s = dirname + "/" + name
		if not os.path.isdir(s):
			if re.search(".*\.as$", name) or re.search(".*\.mxml$", name):
				patch_file(arg, s)

if os.path.isdir(srcFileName):
	os.path.walk(srcFileName, visit, license)
else:
	patch_file(license, srcFileName)



