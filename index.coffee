env = (require 'jsdom').env
http = require 'http'
querystring = require 'querystring'
iconv = require 'iconv-lite'
html = ''
options =
	hostname: "e.tju.edu.cn"
	port: 80
	path: "/Education/schedule.do?schekind=6"
	method: 'POST'


post_data = querystring.stringify
	todo: 'displayWeekBuilding'
	week: 1
	building_no: '0022'

req = http.request options,(res)->
	res.setEncoding 'utf8'
	res.on 'data',(chunk)->
		html += chunk
	res.on 'end',->
		env html,(err,window)->
			$ = (require 'jquery')(window)
			# table = $('form table')[1]
			# console.log table.html()
			# $('strong font').filter ->
			# 	console.log 'a'
			# 	if $(@).attr 'color' is 'White' then true else false
			# .each (index,ele)->
			# 	building = $(@).html()
			# 	console.log building

req.write "#{post_data}\n"
req.end()