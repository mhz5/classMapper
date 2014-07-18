from bs4 import BeautifulSoup
import httplib
import urllib2
import re 		# Regular expression
from pprint import pprint

baseUrl = 'http://students.yale.edu/oci/resultDetail.jsp?'
term = '&term=201401'

classHtml = urllib2.urlopen('http://students.yale.edu/oci/resultDetail.jsp?course=23297&term=201401').read()

for i in range(23000, 24000):
	fullUrl = baseUrl + 'course=' + str(i) + term
	
	# Try to scrape the class. Move on to next one if unable to establish HTTP connection.
	response = None
	try:
		response = urllib2.urlopen(fullUrl)
	except urllib2.HTTPError:
		print 'Class ' + str(i) + ' does not exist!'
		continue
		
	html = response.read()
	soup = BeautifulSoup(html)
	main = soup.body('table')[1].tr('td')

	# info provides course code, name, professor, meeting times, and building
	info = main[0].table('tr')
	
	# subj = info[0].td.string	# Subject
	# if subj == None:
	# 	subj = info[0].td.a.string

	# Array containing class subject and code (For ENGL 114, subj = 'ENGL', code = 114).
	classCodeArr = info[0].td.get_text().split();	
	# TODO: trailing semicolon for 23007, 23009 (MB&B)
	subj = classCodeArr[0]
	code = classCodeArr[1]
	
	# TODO: sanitize name string
	name = info[1].td.b.get_text()	# Class name
	if name == None:
		name = info[1].td.b.p.string

	prof = info[2].td.a.string	# Professor

	meet = info[3].td.get_text()	# Meeting time & location
	arr = meet.split()
	building = 'Location unavailable'
	if len(arr) >= 3:
		building = arr[2]

	semester = main[5].table.tr('td')[0].string	# Semester (eg. Spring 2014)

	if len(main) >= 9:			
		reqs = main[8].string	# Requirements
	else:
		reqs = "No listed requirements"

	descTable = soup.body('table')[1].find_next_sibling()
	desc = descTable.tr.td.get_text()	# Description
	if desc == None:
		desc = descTable.tr.td.p.get_text()

	# print '>' * 30 + '\n'
	# print 'SCRAPING: ' + fullUrl
	# print 'Subject: ' + subj
	# print 'Code: ' + code
	# print 'Building: ' + building

	# To create CSV
	lst = [subj, code, building]
	print ','.join(lst)

	# print 'Name: ' + name 
	# print 'Meet: ' + meet
	# print 'Prof: ' + prof
	# print 'Semester: ' + semester
	# print 'Requirements: ' +  reqs
	# print 'Description: ' + desc

	# print(soup.prettify())

