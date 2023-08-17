# -*- coding: utf-8 -*-

import sys, os, re, pathlib, sanscript, json
from lxml import etree
from natsort import natsorted, ns
from collections import OrderedDict

namespaces = {'tei': 'http://www.tei-c.org/ns/1.0'}
outfile = str(pathlib.Path(__file__).parent.parent.absolute()) + '/verbforms.md'
C = "kgcjṭḍṇtdnpbmhyvrlḷsḻṟ"
V = "aāiīuūeēoō"
v = "aiueo"
vv = "āīūēō"
suffixes = "(udu|uvu|aṁ|aḷ|an|am|en|eṁ|evu|oḍaṁ|oḍe|oḍam)"
#past_suffixes = "((en(?={}))|(eṁ)|(em(?={}))|(eṁ|evu)|(ai|ay|e)|(ir)|(aṁ)(an(?={}))|(aḷ)|(udu))".format(V,V,V)

# class iv: a CVVCu, 
# class iv: b CVCCu
# class iv: c VCVCu
class_iv_a = "([{}]*[{}][{}]{{0,2}}u))$".format(C,vv,C)
class_iv_a_past = ".*?(([{}]*[{}][{}])id{}).*".format(C,vv,C,suffixes)
class_iv_a_past_conv = ".*?(([{}]*[{}][{}]{{1,2}})i[y $]).*".format(C,vv,C,C,V,C)
class_iv_a_nonpast = ".*?((([{}]*[{}][{}]{{1,2}})(p|uv)){}).*".format(C,vv,C,suffixes)
class_iv_c = "([{}][{}][{}][{}]u)$".format(v,C,v,C)
class_iv_c_past = "(([{}][{}][{}][{}])id{})".format(v,C,v,C,suffixes)
class_iv_c_past_conv ="(([{}][{}][{}][{}])i(?<!d))".format(v,C,v,C)
class_iv_c_nonpast = ""

def addform(headword,category,form,reference,data):
    if headword in data:
        if category in data[headword]:
            data[headword][category].append((form,reference))
        else:
            data[headword][category] = [ (form,reference) ] 
    else:
        data[headword] = { category : [ (form,reference) ] }

def process_matches(match,data,cl,category):
    w = ""
    form = match.group(1).strip()
    if category == "past":
        if cl == "4a":
            if match.group(1).strip().endswith("i"):
                w = match.group(1).strip()[:-1] + "u$"
            else:
                if match.group(2) is not None:
                    w = match.group(2) + "u$"
    elif category == "nonpast":
        if cl == "4a":
            if match.group(2) is not None:
                if match.group(2).endswith("p"):
                    x = match.group(2)
                    if x[-2] == "ḻ":
                        w = x[:-2] + "ḍu$"
                    elif x[-2] ==  "r":
                        w = x[:-2] + "[rṟ]u$"
                else:
                    w = match.group(2)[:-1]
    if w != "":
        for hw in headwords:
            hwmatch = re.match(w,hw)
            if hwmatch:
                addform(hw,category,form,reference,intermed)
                    
if __name__ == "__main__":
    teidir = str(pathlib.Path(__file__).parent.parent.absolute()) + '/tei/'
    teifiles = [x for x in pathlib.Path(teidir).glob('**/*.xml') if x.is_file()]
    meters = {}
    intermed = {}
    headwords = set()
    with open('kēśirāja-headwords.txt','r') as h:
        for headword in h.readlines():
            headwords.add(headword.strip())
    with open(outfile,'w') as o:
        for tei in teifiles:
            with open(tei,'r') as f:
                tree = etree.parse(f)
                text = tree.getroot().attrib['n']
                title = tree.find("//tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title",namespaces).text
                for verse in tree.xpath("//tei:TEI/tei:text/tei:body//tei:lg[ancestor-or-self::tei:*[@xml:lang='kan-Latn']][@n]",namespaces=namespaces):
                    verseno = verse.attrib['n']
                    try:
                        parent = verse.xpath("ancestor::tei:div[@n]",namespaces=namespaces)[0]
                        reference = text + "." + parent.attrib['n'] + "." + verseno
                    except:
                        reference = text + "." + verseno
                    # make a list of potential past stems
                    t = ""
                    for part in verse.xpath("tei:*[not(ancestor-or-self::tei:rdg|tei:note)]//text()",namespaces=namespaces):
                        t = t + part
                        # habitualre = re.match("((\S{2,20})[k|g]u(ṁ |m[aāiīeēoōuū]))",t)
                        # if habitualre:
                        #     akkum = re.match(".*[rnmḷ](akku[ṁm])",habitualre.group(1))
                        #     if akkum:
                        #         if "āgu" in intermed:
                        #             if "hab" in intermed["āgu"]:
                        #                 if "akkum" in intermed["āgu"]["hab"]:
                        #                     intermed["āgu"]["hab"]["akkum"].append(reference)
                        #         else:
                        #             intermed["āgu"] = { "hab": { "akkum" : [ reference ] } }
                    iv_a_past = re.match(class_iv_a_past,t)
                    if iv_a_past:
                        process_matches(iv_a_past,intermed,"4a","past")
                    iv_a_past_conv = re.match(class_iv_a_past_conv,t)
                    if iv_a_past_conv:
                        process_matches(iv_a_past_conv,intermed,"4a","past")
                    iv_a_nonpast = re.match(class_iv_a_nonpast,t)
                    if iv_a_nonpast:
                        process_matches(iv_a_nonpast,intermed,"4a","nonpast")
    intermedsorted=OrderedDict(sorted(intermed.items(), key=lambda x: sanscript.transliterate(x[0].lower(),'iso','kannada')))
        # references = natsorted(meters[x], key=lambda y: y.lower())
        # meters[x] = references
    with open(outfile,"w") as o:
        o.write("# Verb forms gathered automatically from corpus\n\n")
        for key in intermedsorted:
            o.write("\n\n## "+key+"\n")
            for category in intermedsorted[key]:
                o.write("\n### "+category+"\n")
                o.write("\n| Form | References |")
                o.write("\n| :--- | :---       |")
                forms = {}
                for pair in intermedsorted[key][category]:
                    if pair[0] in forms:
                        print("pair[0]: " + pair[0])
                        print("pair[1]: " + pair[1])
                        print("forms[pair[0]]: "+", ".join(forms[pair[0]]))
                        forms[pair[0]].append(pair[1])
                    else:
                        forms[pair[0]] = [ pair[1] ]
                sortedforms=OrderedDict(sorted(forms.items(), key=lambda x: sanscript.transliterate(x[0].lower(),'iso','kannada')))
                for k in sortedforms:
                    sortedrefs = sorted(sortedforms[k], key=lambda x: sanscript.transliterate(x.lower(),'iso','kannada'))
                    o.write("\n|"+k+"|"+", ".join(sortedrefs)+"|")
