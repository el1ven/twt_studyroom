env = (require 'jsdom').env
http = require 'http'
querystring = require 'querystring'
iconv = require 'iconv-lite'
BufferHelper = require 'bufferhelper'
jquery = require 'jquery'
fs = require 'fs'
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
	bufferHelper = new BufferHelper()
	res.on 'data',(chunk)->
		bufferHelper.concat chunk
	res.on 'end',->
		html = iconv.decode bufferHelper.toBuffer(),'GBK'
		env html,(err,window)->
			$ = jquery(window)
			fs.writeFile 'message.html',html,(err)->
				throw err if err
				console.log 'saved'
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