#!/usr/bin/env python

import reg_parser as rp
import time

from lxml import etree

xml_file = '../regulations-parser/fr-notices/articles/xml/201/131/725.xml'
reg_xml = ''

with open(xml_file, 'r') as f:
    reg_xml = f.read();

doc = etree.fromstring(reg_xml)

part = doc.xpath('//PART')[0]

sections = [section for section in part.getchildren() if section.tag == 'SECTION']

paragraphs = []

for section in sections:
    section_pars = [p.text.encode('utf-8') for p in section.getchildren() if p.tag == 'P']
    paragraphs.extend(section_pars)

start = time.clock()
for p in paragraphs:
    
    tokens = rp.parse(p)[::-1]
    print p
    print tokens
    
end = time.clock()

print 'time elapsed: {0}'.format(end - start)
