blinkWhenClose = false

fields = {
  number: '#',
  place: 'P',
  placeInClass: 'PIC',
  lastLap: 'Last',
  gap: 'Gap',
  interval: 'Int',
  classGap: 'ClassGap',
  classInterval: 'ClassInt',
  sectorOne: 'S1',
  sectorTwo: 'S2',
  sectorThree: 'S3',
  state: 'State',
  driver: 'Driver',
  team: 'Team',
  laps: 'Laps',
  stops: 'Stops',
  best: 'Best',
  bestSectorOne: 'BS1',
  bestSectorTwo: 'BS2',
  bestSectorThree: 'BS3'
}

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
        $("#weather").html(weatherFor(json.params.weather))
        $("#temp").html(json.params.airTemp)
        $("#tracktemp").html(json.params.trackTemp)
        $("#state").html("#{raceStateMessage(json.params.racestate)}")
        $("#state").attr('class', json.params.racestate)
        thTr = "<tr>"
        Object.entries(fields).forEach (entry) ->
          [key, value] = entry;
          if $('#checkbox-'+key).prop('checked')
            thTr += "<th scope='col'>#{value}</th>"
        thTr += '</tr>'
        $("#tableLabels").html(thTr)
        json.entries.forEach (entry) ->
          interval = (entry.gap - prevGap).toString()
          tr = "<tr class='#{fav(entry.number)}'>"
          if $('#checkbox-number').prop('checked')
            tr += "<td class='#{entry.category}'>#{entry.number}</td>"
          if $('#checkbox-place').prop('checked')
            tr += "<td>#{entry.ranking}</td>"
          if $('#checkbox-placeInClass').prop('checked')
            tr += "<td>#{entry.categoryPosition}</td>"
          if $('#checkbox-lastLap').prop('checked')
            tr += "<td class='#{blinkLap(entry.lastLap, entry.bestlap)}'>#{entry.lastlap}</td>"
          if $('#checkbox-gap').prop('checked')
            tr += "<td>#{overalGap(entry) }</td>"
          if $('#checkbox-interval').prop('checked')
            tr += "<td class='#{blink(interval, 1)}'>#{overalInterval(entry)}</td>"
          if $('#checkbox-classGap').prop('checked')
            tr += "<td>#{classGap(entry)}</td>"
          if $('#checkbox-classInterval').prop('checked')
            tr += "<td class='#{blink(interval, 1)}'>#{classInterval(entry)}</td>"
          if $('#checkbox-sectorOne').prop('checked')
            tr += "<td>#{entry.currentSector1}</td>"
          if $('#checkbox-sectorTwo').prop('checked')
            tr += "<td>#{entry.currentSector2}</td>"
          if $('#checkbox-sectorThree').prop('checked')
            tr += "<td>#{entry.currentSector3}</td>"
          if $('#checkbox-state').prop('checked')
            tr += "<td class='#{entry.state}'>#{entry.state}</td>"
          if $('#checkbox-driver').prop('checked')
            tr += "<td>#{entry.driver}</td>"
          if $('#checkbox-team').prop('checked')
            tr += "<td>#{entry.team}</td>"
          if $('#checkbox-laps').prop('checked')
            tr += "<td>#{entry.lap}</td>"
          if $('#checkbox-stops').prop('checked')
            tr += "<td>#{entry.pitstop}</td>"
          if $('#checkbox-best').prop('checked')
            tr += "<td>#{entry.bestlap}</td>"
          if $('#checkbox-bestSectorOne').prop('checked')
            tr += "<td>#{entry.bestSector1}</td>"
          if $('#checkbox-bestSectorTwo').prop('checked')
            tr += "<td>#{entry.bestSector2}</td>"
          if $('#checkbox-bestSectorThree').prop('checked')
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
  ), 1999
  return

fetchData()
dataLoop()

classGap = (entry) ->
  if entry.categoryPosition == 1
    return 'CLASS LEADER'
  else
    return entry.classGap

overalGap = (entry) ->
  if entry.ranking == 1
    'LEADER'
  else
    entry.gap

classInterval = (entry) ->
  if entry.categoryPosition == 1
    return 'CLASS LEADER'
  else
    return entry.classGapPrev

overalInterval = (entry) ->
  if entry.ranking == 1
    'LEADER'
  else
    entry.gapPrev

weatherFor = (code) ->
  switch code
    when 'mostly_sunny' then '🌤'
    when 'cloudy' then '☁️'
    when 'sunny' then '☀️'
    when 'rain' then '🌧'
    else code

raceStateMessage = (code) ->
  switch code
    when 'full_yellow' then 'FULL COURSE YELLOW (FCY)'
    when 'slow_zones' then 'SLOW ZONES'
    when 'safety_car' then 'SAFETYCAR(s) DEPLOYED'
    when 'green' then ''
    else code

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
  if $("#fav").val().split(',').includes(number.toString())
    return 'fav'
  else
    return ''

blink = (current, best, difference = 0.5) ->
  if blinkWhenClose && (current - best) < difference
    return 'blink'


blinkLap = (current, best, difference = 0.2) ->
  if blinkWhenClose && current - best < difference
    return 'blink'

