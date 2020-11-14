# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
#= require jquery
#= require jquery_ujs
#= require_tree .
#= require bootstrap-sprockets
#= require twitter/typeahead
((i, s, o, g, r, a, m) ->
    i["GoogleAnalyticsObject"] = r
    i[r] = i[r] or ->
      (i[r].q = i[r].q or []).push arguments

    i[r].l = 1 * new Date()

    a = s.createElement(o)
    m = s.getElementsByTagName(o)[0]

    a.async = 1
    a.src = g
    m.parentNode.insertBefore a, m
  ) window, document, "script", "//www.google-analytics.com/analytics.js", "ga"
ga('create', 'UA-56554035-1', 'auto')
ga('send', 'pageview')


$(document).ready ->
  # Common functionality
  window.cbl = {}
  window.cbl.checks = {}
  window.cbl.CPU = 'cpu'
  window.cbl.GPU = 'gpu'
  window.cbl.CPUS = 'cpus'
  window.cbl.GPUS = 'gpus'
  window.cbl.CPUS_URL = 'https://www.notebookcheck.net/Mobile-Processors-Benchmark-List.2436.0.html?&deskornote=2&or=0&cpu_fullname=1&cores=1&threads=1'
  window.cbl.GPUS_URL = 'https://www.notebookcheck.net/Mobile-Graphics-Cards-Benchmark-List.844.0.html?multiplegpus=1&or=0&gpu_fullname=1'
  window.cbl.NOT_FOUND = 'Not found'
  window.cbl.CLASSES = {BG_DANGER: 'bg-danger'}

  # Functions
  # Checks
  window.cbl.checks.isAvgCorrect = (parent)->
    avgIndex = parseInt($(parent).find('.avg_percentage').text())
    return !isNaN(avgIndex) && avgIndex > 0

  window.cbl.checks.isCpuCorrect = (parent)->
    cpuIndex = parseInt($(parent).find('.cpu_percentage').text())
    return !isNaN(cpuIndex) && cpuIndex > 0

  window.cbl.checks.isGpuCorrect = (parent)->
    gpuIndex = parseInt($(parent).find('.gpu_percentage').text())
    return !isNaN(gpuIndex) && gpuIndex > 0

  window.cbl.checks.isPriceCorrect = (parent)->
    price = parseInt($(parent).find('.price').text())
    return !isNaN(price) && price >= 0.0

  window.cbl.checks.isCorrectData = (parent)->
    return window.cbl.checks.isAvgCorrect(parent) && window.cbl.checks.isCpuCorrect(parent) && window.cbl.checks.isGpuCorrect(parent) && window.cbl.checks.isPriceCorrect(parent)

  # Common functions
  window.cbl.tokenize = (objOrName)->
    if typeof objOrName == 'object'
      objOrName = objOrName['name']

    if typeof objOrName == 'string'
      val = objOrName.trim().match(/[a-z]+|[0-9]+/gi)
    else
      val = []
    return val

  window.cbl.getData = (rowData)->
    $rowData = $(rowData)
    $rowDesc = $(rowData).next()
    name = $rowData.find('td.laptop_name a').text().trim()
    avgIndex = $rowData.find('td.avg_percentage').text().trim()
    cpuIndex = $rowData.find('td.cpu_percentage').text().trim()
    cpuModel = $rowData.find('td.cpu_model').text().trim()
    gpuPercentage = $rowData.find('td.gpu_percentage').text().trim()
    gpuModel = $rowData.find('td.gpu_model').text().trim()
    price = $rowData.find('td.price').text().trim()
    desc = $rowDesc.find('td.laptop_desc').text().trim()
    return {
      'name': name,
      'avg_percentage': avgIndex,
      'cpu_percentage': cpuIndex,
      'cpu_model': cpuModel,
      'gpu_percentage': gpuPercentage,
      'gpu_model': gpuModel,
      'price': price,
      'desc': desc
    }

  window.cbl.moveToCorrectRow = (rowElement)->
    $rowElement = $(rowElement)
    $rowDesc = $rowElement.next()
    initialAvgPerc = parseFloat($rowElement.find('.avg_percentage').text())
    initialCpuPerc =parseFloat($rowElement.find('.cpu_percentage').text())
    initialGpuPerc = parseFloat($rowElement.find('.gpu_percentage').text())
    initialPrice = parseFloat($rowElement.find('.price').text())
    $previousRow = undefined

    $('tr.row_data').each( (index, row)->
      $row = $(row)
      avgPerc = parseFloat($row.find('.avg_percentage').text());
      cpuPerc = parseFloat($row.find('.cpu_percentage').text());
      gpuPerc = parseFloat($row.find('.gpu_percentage').text());
      price = parseFloat($row.find('.price').text());

      if avgPerc > initialAvgPerc
        $previousRow = $row
      else if avgPerc == initialAvgPerc
        if cpuPerc > initialCpuPerc
          $previousRow = $row
        else if cpuPerc == initialCpuPerc
          if gpuPerc > initialGpuPerc
            $previousRow = $row
          else if gpuPerc == initialGpuPerc
            if price >= initialPrice
              $previousRow = $row

      return
    )

    if $previousRow != undefined && $previousRow[0] != $rowElement[0]
      $rowElement.detach()
      $rowDesc.detach()
      $previousRowDesc = $previousRow.next()
      $rowElement.insertAfter($previousRowDesc)
      $rowDesc.insertAfter($rowElement)
      $rowDesc.find('td').hide()
      return

  window.cbl.fixIndecies = ()->
    i = 1
    $('table tr').each (index)->
      tds =  $(this).find('td')
      if tds.length > 3
        $(tds[0]).text(i)
        i += 1

  window.cbl.updateLaptops = ()->
    $('#laptops').val('')
    if $('#use_delimiter').prop('checked')
      delimiter = $('#delimiter').val()
      if delimiter.indexOf('\n') == -1
        delimiter = '\n' + delimiter + '\n'
    else
      delimiter = '\n\n'
    new_text = $('.laptop_desc p').map ()->
      $(this).text().trim()
    new_text = new_text.toArray().join(delimiter)
    $('#laptops').val(new_text)

  window.cbl.getProcessorData = (modelName, cpusOrGpus)->
    if cpusOrGpus == window.cbl.CPU
      data = window.cbl[window.cbl.CPUS]
      index_name = window.cbl.GPU + '_percentage'
    else if cpusOrGpus == window.cbl.GPU
      data = window.cbl[window.cbl.GPUS]
      index_name = window.cbl.CPU + '_percentage'
    else
      val = undefined

    $(data).each( (index, value)->
      if value.name == modelName
        val =  value
        return false;
    )
    return val

  window.cbl.formatPercentage = (number)->
    (number*100).toFixed(2).toString() + '%'

  window.cbl.applyTypeahead = (inputElement, cpu_or_gpu)->
    data = window.cbl[cpu_or_gpu + 's_data']
    $(inputElement).typeahead({
      hint: true,
      highlight: true,
      minLength: 1
      }, {
      name: 'data',
      displayKey: 'name',
      source: data.ttAdapter()
    })

  window.cbl.updateDesc = (laptopDataRow, laptopDescRow)->
    $laptopDescRow = $(laptopDescRow)
    $laptopDataRow = $(laptopDataRow)
    desc = ';'
    if window.cbl.checks.isCpuCorrect($laptopDataRow)
      cpu = $laptopDataRow.find('.cpu_model').text()
      desc += cpu + ';'
    if window.cbl.checks.isGpuCorrect($laptopDataRow)
      gpu = $laptopDataRow.find('.gpu_model').text()
      desc += gpu + ';'
    if window.cbl.checks.isPriceCorrect($laptopDataRow)
      price = $laptopDataRow.find('.price').text()
      desc += price
    $laptopDescRow.find('.fixed_data').text(desc)

  # Onload fuctions
  $([window.cbl.CPUS, window.cbl.GPUS]).each( (index, value)->
    $.getJSON '/notebookcheck/' + value + '.json', (resp)->
      window.cbl[value] = resp
      window.cbl[value + '_data'] = new Bloodhound({
        datumTokenizer: window.cbl.tokenize,
        queryTokenizer: window.cbl.tokenize,
        limit: 5,
        local: resp
      })

      window.cbl[value + '_data'].initialize();

      window.cbl[value.toUpperCase() + '_MAX_INDEX'] = window.cbl[value][window.cbl[value].length - 1].index
  )

  # Form events
  $('table td.laptop_name a').click (event)->
    event.preventDefault()
    $parent = $(this).parent().parent()
    $row = $parent.next()
    $laptop_desc = $row.find('td.laptop_desc')
    if $laptop_desc.hasClass('hidden')
      $laptop_desc.removeClass('hidden')
      $laptop_desc.show()
    else
      $laptop_desc.toggle()
    return

  $('form #clear_btn').click (event)->
    event.preventDefault()
    $('#laptops').val('')
    $('#delimiter').val('')
    $('#delimiter').prop('disabled', true)
    $('#use_delimiter').prop('checked', false)
    return

  $('div.checkbox label,div.checkbox input#use_delimiter').click (event)->
    if $('input#use_delimiter').is(':checked')
      $('#delimiter').prop('disabled', false)
    else
      $('#delimiter').prop('disabled', true)

  # Results events
  $('#share_results').click (event)->
    popover = $('.popover')
    if popover.length > 0
      popover.remove()
    else
      $share_results = $(this)
      $share_results.button('loading')
      descriptions = $.map($('td.laptop_desc'), (val)->
        $(val).text().trim().replace(/\s{2,}/g, ' ')
      )
      delimiter = $('#delimiter').val()
      query = descriptions.join(' ' + delimiter + '\n\n')
      $.post('/query', {'query' : query, 'delimiter': delimiter}, (resp)->
        $share_results.button('reset')
        hash = resp['hash_string']
        url = window.location.origin + window.location.pathname + '?q=' + hash
        content = "<a href='#{url}' target='_blank'>#{url}</a>"
        $share_results.popover({container: '.container', html: true, delay: 500, placement: 'left', 'content': content}).popover('show')
      )
    return

  $('table td button.remove').click (event)->
    parent = $(this).parent().parent()
    parent.next().remove()
    parent.remove()
    window.cbl.fixIndecies()

  $('table td button.edit').click (event)->
    parent = $(this).parent().parent()
    $([window.cbl.CPU, window.cbl.GPU]).each( (index, value)->
      $model = parent.find('.' + value + '_model')
      $model.removeClass(window.cbl.CLASSES.BG_DANGER)
      model = $model.text().trim()
      $model.empty()

      $input = $('<input>', {'class': 'form-control input-sm'})
      $input.appendTo($model)
      if model != window.cbl.NOT_FOUND
        $input.val(model)
      window.cbl.applyTypeahead($input, value)
    )
    # price editing
    $price = $(parent.find('td.price'))
    price = $price.text().trim()
    $price.empty()
    $input = $('<input>', {'class': 'price form-control input-sm'})
    $input.appendTo($price)
    $input.val(price)

    $apply = parent.find('.apply')
    $apply.removeClass('hidden')
    $apply.show()

    $edit = $(event.target)
    $edit.hide()

  $('table td button.apply').click (event)->
    parent = $(this).parent().parent()

    fixClass = (element, oldClass, newClass)->
      if $(element).hasClass(oldClass)
        $(element).removeClass(oldClass)
      if !$(element).hasClass(newClass)
        $(element).addClass(newClass)
      return

    $([window.cbl.CPU, window.cbl.GPU]).each( (index, value)->
      $model = parent.find('.' + value + '_model')
      model = $model.find('input.tt-input').val().trim()
      $model.empty()
      $index = parent.find('.' + value + '_percentage')
      $index.empty()
      processorData = window.cbl.getProcessorData(model, value)
      if model == window.cbl.NOT_FOUND || model.length == 0 || processorData == undefined
        $model.text(window.cbl.NOT_FOUND)
        if !$model.hasClass(window.cbl.CLASSES.BG_DANGER)
          $model.addClass(window.cbl.CLASSES.BG_DANGER)
        $index.text(window.cbl.NOT_FOUND)
      else
        if value == window.cbl.CPU
          url = window.cbl.CPUS_URL
          max_index = window.cbl.CPUS_MAX_INDEX
        else
          url = window.cbl.GPUS_URL
          max_index = window.cbl.GPUS_MAX_INDEX
        $a = $('<a></a>', {'target': '_blank', 'href': processorData['href']})
        $a.text(model)
        $a.appendTo($model)

        $aIndex = $('<a></a>', {'target': '_blank', 'href': url})
        percentage = 1 - processorData['index'] / max_index
        $aIndex.text(window.cbl.formatPercentage(percentage))
        $aIndex.appendTo($index)
      return
    )

    # price
    $price = $(parent.find('td.price'))
    price = $price.find('input.price').val().trim()
    $price.empty()
    $price.text(price)

    # setting average index
    cpuPercentage = parseFloat($(parent).find('.cpu_percentage a').text())
    gpuPercentage = parseFloat($(parent).find('.gpu_percentage a').text())
    $avgIndex = parent.find('.avg_percentage')
    if !window.cbl.checks.isCpuCorrect(parent) || !window.cbl.checks.isGpuCorrect(parent)
      avgPercentage = window.cbl.NOT_FOUND
    else
      avgPercentage = window.cbl.formatPercentage((cpuPercentage + gpuPercentage) / 200)
    $avgIndex.text(avgPercentage)

    # Fixing backgroud
    $cpu_percentage = $(parent).find('.cpu_percentage')
    $gpu_percentage = $(parent).find('.gpu_percentage')
    $avg_percentage = $(parent).find('.avg_percentage')

    if window.cbl.checks.isAvgCorrect(parent)
      $avg_percentage.removeClass(window.cbl.CLASSES.BG_DANGER)
    if window.cbl.checks.isCpuCorrect(parent)
      $cpu_percentage.removeClass(window.cbl.CLASSES.BG_DANGER)
    if window.cbl.checks.isGpuCorrect(parent)
      $gpu_percentage.removeClass(window.cbl.CLASSES.BG_DANGER)

    $edit = parent.find('.edit')
    $edit.removeClass('hidden')
    $edit.show()
    $apply = $(event.target)
    $apply.hide()

    window.cbl.updateDesc(parent, parent.next())

    window.cbl.moveToCorrectRow($(parent))

    if window.cbl.checks.isCorrectData(parent)
      fixClass($edit, 'btn-warning', 'btn-default')
      window.cbl.updateLaptops()
    else
      fixClass($edit, 'btn-default', 'btn-warning')

    window.cbl.fixIndecies()
    return

  $('[data-toggle="tooltip"]').tooltip();
