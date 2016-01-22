jQuery ->
  categories = $('#article_category_ids').html()
  material = $('#article_material_id :selected').text()

  if (material == "" )
    $('#article_category_ids').empty()
    $('#article_category_ids').trigger("chosen:updated")
    $('#article_category_ids').parent().hide()
  else
    options = $(categories).filter("optgroup[label='#{material}']").html()
    $('#article_category_ids').html(options)
    $('#article_category_ids').trigger("chosen:updated")
    $('#article_category_ids').parent().show()

  $('#article_material_id').change ->
    material = $('#article_material_id :selected').text()
    options = $(categories).filter("optgroup[label='#{material}']").html()

    if options
      $('#article_category_ids').html(options)
      $('#article_category_ids').trigger("chosen:updated")
      $('#article_category_ids').parent().show()
    else
      $('#article_category_ids').trigger("chosen:updated").empty()
      $('#article_category_ids').parent().hide()