jQuery ->

  id = $('#article').attr('id')

  categories = $('#articles_category_id').html()
  material = $('#articles_'+id+'_material_id :selected').text()

  if (material == "" )
    $('#articles_'+id+'_category_id').parent().hide()
  else
    options = $(categories).filter("optgroup[label='#{material}']").html()
    $('#articles_'+id+'_category_id').html(options)
    $('#articles_'+id+'_category_id').parent().show()

  categories = $('#articles_'+id+'_category_id').html()
  $('#articles_'+id+'_material_id').change ->
    material = $('#articles_'+id+'_material_id :selected').text()
    options = $(categories).filter("optgroup[label='#{material}']").html()

    if options
      $('#articles_'+id+'_category_id').html(options)
      $('#articles_'+id+'_category_id').parent().show()
    else
      $('#articles_'+id+'_category_id').empty()
      $('#articles_'+id+'_category_id').parent().hide()