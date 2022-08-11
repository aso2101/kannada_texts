# -*- coding: utf-8 -*-

import sys, os, re, pathlib, sanscript
from lxml import etree
from natsort import natsorted, ns

namespaces = {'tei': 'http://www.tei-c.org/ns/1.0'}
outfile = str(pathlib.Path(__file__).parent.parent.absolute()) + '/meter.md'

if __name__ == "__main__":
    teidir = str(pathlib.Path(__file__).parent.parent.absolute()) + '/tei/'
    teifiles = [x for x in pathlib.Path(teidir).glob('**/*.xml') if x.is_file()]
    meters = {}
    with open(outfile,'w') as o:
        o.write("""# Metrical data from TEI texts

Note that this file is generated automatically from the data in `/tei/` by the script `/scripts/meter.py`.
""")
        for tei in teifiles:
            intermed = {}
            with open(tei,'r') as f:
                tree = etree.parse(f)
                text = tree.getroot().attrib['n']
                title = tree.find("//tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title",namespaces).text
                for target in tree.findall("//tei:*[@met]",namespaces):
                    met = target.attrib['met']
                    verse = target.attrib['n']
                    if 'n' in target.getparent().attrib:
                        parent = target.getparent().attrib['n']
                        reference = text + "." + parent + "." + verse
                    else:
                        reference = text + "." + verse
                    if met in intermed:
                        intermed[met].append(reference)
                    else:
                        intermed[met] = [reference]
                sortednames=sorted(intermed.keys(), key=lambda x: sanscript.transliterate(x.lower(),'iso','kannada'))
                o.write("\n## " + title)
                o.write("\n| Meter | Count | References |")
                o.write("\n| :--- | :--- | :--- |")
                for x in sortednames:
                    references = natsorted(intermed[x], key=lambda y: y.lower())
                    intermed[x] = references
                    o.write("\n|" + x + "|" + str(len(references)) + "|" + ", ".join(references) + "|")
                    if x in meters:
                        meters[x].extend(references)
                    else:
                        meters[x] = references
        o.write("\n## Overall")
        o.write("\n| Meter | Count | References |")
        o.write("\n| :--- | :--- | :--- |")
        sortednames=sorted(meters.keys(), key=lambda x: sanscript.transliterate(x.lower(),'iso','kannada'))
        for x in meters:
             references = natsorted(meters[x], key=lambda y: y.lower())
             meters[x] = references
             o.write("\n|" + x + "|" + str(len(references)) + "|" + ", ".join(references) + "|")
