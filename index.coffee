env = (require 'jsdom').env
http = require 'http'
querystring = require 'querystring'
iconv = require 'iconv-lite'
BufferHelper = require 'bufferhelper'
jquery = require 'jquery'
fs = require 'fs'
buildings = require './building'
async = require 'async'

week_count = 26
build_count = buildings.length
week = 0
buildIndex = 0



send_request = (callback)->
	build = buildings[buildIndex]
	# build = '0022'
	post_data = querystring.stringify
		todo: 'displayWeekBuilding'
		week: week
		building_no: build

	options =
		hostname: "e.tju.edu.cn"
		port: 80
		path: "/Education/schedule.do?schekind=6"
		method: 'POST'
		headers:
			'Content-Type': 'application/x-www-form-urlencoded'
			'Content-Length': post_data.length

	req = http.request options,(res)->
		bufferHelper = new BufferHelper()
		res.on 'data',(chunk)->
			bufferHelper.concat chunk
		res.on 'end',->
			html = iconv.decode bufferHelper.toBuffer(),'GBK'
			env html,(err,window)->
				$ = jquery(window)
				$('strong').each ->
					room = $(@).find('font').html()
					is_seldom = ''
					tr = $(@).parent().parent()
					fonts = tr.find('font').filter ->
						if ($(@).attr 'color') is 'White' then false else true
					.each ->
						is_seldom += if ($(@).attr 'color') is 'black' then  '0' else '1'
					line = "#{build} #{room} #{is_seldom} #{week}\n"
					fs.appendFileSync 'studyroom.txt',line
				html = null
				callback()

	req.write "#{post_data}\n"
	req.end()
async.whilst ->
	buildIndex < build_count
,(callback)->
	week = 0
	async.whilst ->
		week < 26
	,(callback) ->
		week++
		send_request callback
	,(err) ->
		console.log (if err then err else "第#{week}周#{buildings[buildIndex]}success")
		buildIndex++
		callback()
,(err)->
	console.log (if err then err else "第#{week}周#{buildings[buildIndex]}success")