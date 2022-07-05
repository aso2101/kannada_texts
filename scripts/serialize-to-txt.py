import re, os, string, sys, pathlib, subprocess
from lxml import etree
from itertools import chain

if __name__ == "__main__":
    teidir = str(pathlib.Path(__file__).parent.parent.absolute()) + '/tei/'
    teifiles = [x for x in pathlib.Path(teidir).glob('**/*.xml') if x.is_file()]
    for tei in teifiles:
        outputfilename = str(tei).replace('/tei/','/txt/').replace('.xml','.txt')
        xsl = str(pathlib.Path(__file__).parent.parent.absolute()) + '/scripts/' + "/tei2text.xsl"
        source = "-s:'"+str(tei)+"'"
        stylesheet = "-xsl:'"+os.path.abspath(xsl)+"'"
        output = "-o:'"+outputfilename+"'"
        javacall = "java -cp /usr/share/java/*:/usr/share/java/ant-1.9.6.jar net.sf.saxon.Transform "+source+ " "+stylesheet+" "+output
        try:
            txt = subprocess.Popen(javacall,stdout=subprocess.PIPE,shell=True)
        except Exception as ex:
            template = "An exception of type {0} occurred. Arguments:\n{1!r}"
            message = template.format(type(ex).__name__, ex.args)
            print(message)
