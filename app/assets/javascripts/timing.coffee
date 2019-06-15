
blinkWhenClose = false

fetchData = () ->
  fetch("/timings/#{Date.now()}",
    method: 'GET'
    mode: 'cors'
    headers: new Headers([[
      'Access-Control-Allow-Origin'
      '*'
    ]])).then (response) ->
    prevGap = 0
    interval = ""
    response.json().then (json) ->
      $("#data").html('')
      $("#time").html(remaining(json.params.remaining))
      $("#weather").html(json.params.weather)
      $("#temp").html(json.params.airTemp)
      $("#tracktemp").html(json.params.trackTemp)
      $("#state").html("#{json.params.racestate} #{scMessage(json)}")
      $("#state").attr('class', json.params.racestate)
      json.entries.forEach (entry) ->
        interval = (entry.gap - prevGap).toString()
        tr = "<tr class='#{fav(entry.number)}'>"
        tr += "<td class='#{entry.category}'>#{entry.number}</td>"
        tr += "<td>#{entry.ranking}</td>"
        tr += "<td>#{entry.categoryPosition}</td>"
        tr += "<td class='#{blinkLap(entry.lastLap, entry.bestlap)}'>#{entry.lastlap}</td>"
        tr += "<td>#{entry.gap || 'LEADER'}</td>"
        tr += "<td class='#{blink(interval, 1)}'>#{entry.gapPrev || 'LEADER'}</td>"
        tr += "<td>#{entry.classGap || 'CLASS LEADER'}</td>"
        tr += "<td>#{entry.classGapPrev || 'CLASS LEADER'}</td>"
        tr += "<td class='#{blink(entry.currentSector1, entry.bestSector1)}'>#{entry.currentSector1}</td>"
        tr += "<td class='#{blink(entry.currentSector2, entry.bestSector2)}'>#{entry.currentSector2}</td>"
        tr += "<td class='#{blink(entry.currentSector3, entry.bestSector3)}'>#{entry.currentSector3}</td>"
        tr += "<td class='#{entry.state}'>#{entry.state}</td>"
        tr += "<td>#{entry.driver}</td>"
        tr += "<td>#{entry.team}</td>"
        tr += "<td>#{entry.lap}</td>"
        tr += "<td>#{entry.pitstop}</td>"
        tr += "<td>#{entry.bestlap}</td>"
        tr += "<td>#{entry.bestSector1}</td>"
        tr += "<td>#{entry.bestSector2}</td>"
        tr += "<td>#{entry.bestSector3}</td>"


        $('#data').append tr
        prevGap = entry.gap
        return
      return
    return

dataLoop = () ->
  setTimeout (->
    fetchData()
    dataLoop()
    return
  ), 5000
  return

fetchData()
dataLoop()


scMessage = (json) ->
  if json.params.safetycar == 'true'
    'Safetycar deployed'
  else
    ''

remaining = (totalSeconds) ->
  hours = Math.floor(totalSeconds / 3600);
  if hours < 10
    hours = "0#{hours}"
  totalSeconds %= 3600;
  minutes = Math.floor(totalSeconds / 60);
  if minutes < 10
    minutes = "0#{minutes}"
  seconds = totalSeconds % 60;
  if seconds < 10
    seconds = "0#{seconds}"
  return "#{hours}:#{minutes}:#{seconds}"


fav = (number) ->
  if number == 38 || number == 29 || number == 10 || number == 85
    return 'fav'

blink = (current, best, difference = 0.2) ->
  if blinkWhenClose && current - best < difference
    return 'blink'


blinkLap = (current, best, difference = 0.2) ->
  if blinkWhenClose && current - best < difference
    return 'blink'
