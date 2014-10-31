# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready ->
  # Common functionality
  window.cbl = {}
  window.cbl.CPU = 'cpu'
  window.cbl.GPU = 'gpu'
  window.cbl.CPUS = 'cpus'
  window.cbl.GPUS = 'gpus'
  window.cbl.CPUS_URL = 'http://www.notebookcheck.net/Mobile-Processors-Benchmarklist.2436.0.html'
  window.cbl.GPUS_URL = 'http://www.notebookcheck.net/Mobile-Graphics-Cards-Benchmark-List.844.0.html?multiplegpus=1'
  window.cbl.UNKNOWN = 'unknown'
  window.cbl.CLASSES = {BG_DANGER: 'bg-danger'}

  # Functions
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
    avgIndex = $rowData.find('td.avg_index').text().trim()
    cpuIndex = $rowData.find('td.cpu_index').text().trim()
    cpuModel = $rowData.find('td.cpu_model').text().trim()
    gpuIndex = $rowData.find('td.gpu_index').text().trim()
    gpuModel = $rowData.find('td.gpu_model').text().trim()
    price = $rowData.find('td.price').text().trim()
    desc = $rowDesc.find('td.laptop_desc').text().trim()
    return {
      'name': name, 
      'avg_index': avgIndex, 
      'cpu_index': cpuIndex, 
      'cpu_model': cpuModel, 
      'gpu_index': gpuIndex, 
      'gpu_model': gpuModel, 
      'price': price, 
      'desc': desc
    }

  window.cbl.moveToCorrectRow = (rowElement)->
    $rowElement = $(rowElement)
    $rowDesc = $rowElement.next()
    initialAvgIndex = parseInt($rowElement.find('.avg_index').text())
    initialCpuIndex =parseInt($rowElement.find('.cpu_index').text())
    initialGpuIndex = parseInt($rowElement.find('.gpu_index').text())
    initialPrice = parseFloat($rowElement.find('.price').text())
    $previousRow = undefined

    $('tr.row_data').each( (index, row)->
      $row = $(row)
      avgIndex = parseInt($row.find('.avg_index').text());
      cpuIndex = parseInt($row.find('.cpu_index').text());
      gpuIndex = parseInt($row.find('.gpu_index').text());
      price = parseFloat($row.find('.price').text());

      if avgIndex < initialAvgIndex
        $previousRow = $row
      else if avgIndex == initialAvgIndex
        if cpuIndex < initialCpuIndex
          $previousRow = $row
        else if cpuIndex == initialCpuIndex
          if gpuIndex < initialGpuIndex
            $previousRow = $row
          else if gpuIndex == initialGpuIndex
            if price <= initialPrice
              $previousRow = $row
      else
        return false
      return
    )

    if $previousRow != undefined
      $rowElement.detach()
      $rowDesc.detach()
      $previousRowDesc = $previousRow.next()
      $rowElement.insertAfter($previousRowDesc)
      $rowDesc.insertAfter($rowElement)
      return

  window.cbl.fixIndecies = ()->
    i = 1
    $('table tr').each (index)->
      tds =  $(this).find('td')
      if tds.length > 3
        $(tds[0]).text(i)
        i += 1

  window.cbl.getProcessorData = (modelName, cpusOrGpus)->
    if cpusOrGpus == window.cbl.CPU
      data = window.cbl[window.cbl.CPUS]
      index_name = window.cbl.GPU + '_index'
    else if cpusOrGpus == window.cbl.GPU
      data = window.cbl[window.cbl.GPUS]
      index_name = window.cbl.CPU + '_index'
    else
      val = undefined

    $(data).each( (index, value)->
      if value.name == modelName
        val =  value
        return false;
    )
    return val

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

  # Onload fuctions
  # TODO only get CPU and GPU data if there is some data
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

  # Row/Laptop events
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
      if model != window.cbl.UNKNOWN
        $input.val(model)
      window.cbl.applyTypeahead($input, value)
    )

    $apply = parent.find('.apply')
    $apply.removeClass('hidden')
    $apply.show()

    $edit = $(event.target)
    $edit.hide()
    
  $('table td button.apply').click (event)->
    parent = $(this).parent().parent()
    
    # inner functions
    isCorrectData = ()->
      avgIndex = parseInt($(parent).find('.avg_index').text())
      cpuIndex =parseInt($(parent).find('.cpu_index').text())
      gpuIndex = parseInt($(parent).find('.gpu_index').text())
      price = parseFloat($(parent).find('.price').text())
      return !isNaN(avgIndex) && !isNaN(cpuIndex) && !isNaN(gpuIndex) && !isNaN(price) && avgIndex > 0 && cpuIndex > 0 && gpuIndex > 0 && price > 0.0

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
      $index = parent.find('.' + value + '_index')
      $index.empty()
      processorData = window.cbl.getProcessorData(model, value)
      if model == window.cbl.UNKNOWN || model.length == 0 || processorData == undefined
        $model.text(window.cbl.UNKNOWN)
        if !$model.hasClass(window.cbl.CLASSES.BG_DANGER)
          $model.addClass(window.cbl.CLASSES.BG_DANGER)
        $index.text(-1)
      else
        if value == window.cbl.CPU
          url = window.cbl.CPUS_URL
        else 
          url = window.cbl.GPUS_URL
        $a = $('<a></a>', {'target': '_blank', 'href': processorData['href']})
        $a.text(model)
        $a.appendTo($model)
        
        $aIndex = $('<a></a>', {'target': '_blank', 'href': url})
        $aIndex.text(processorData['index'])
        $aIndex.appendTo($index)
      return
    )

    # setting average index
    cpuIndex = parseInt($(parent).find('.' + window.cbl.CPU + '_index a').text())
    gpuIndex = parseInt($(parent).find('.' + window.cbl.GPU + '_index a').text())
    $avgIndex = parent.find('.avg_index')
    if isNaN(cpuIndex) || isNaN(gpuIndex)
      avgIndex = -1
    else
      avgIndex = parseInt((cpuIndex + gpuIndex) / 2)
    $avgIndex.text(avgIndex)
    
    $edit = parent.find('.edit')
    $edit.removeClass('hidden')
    $edit.show()
    $apply = $(event.target)
    $apply.hide()
    window.cbl.moveToCorrectRow($(parent))
    if isCorrectData()
      # TODO fix description
      # TODO fix message
      # TODO add OK message - green when all OK
      fixClass($edit, 'btn-warning', 'btn-default')
    else
      fixClass($edit, 'btn-default', 'btn-warning')
      
    window.cbl.fixIndecies()
    return
