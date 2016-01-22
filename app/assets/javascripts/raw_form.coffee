jQuery ->
  categories = $('#article_ssubcategory_id').html()
  material = $('#article_subcategory_id :selected').text()

  if (material == "" )
    $('#article_ssubcategory_id').parent().hide()
  else
    options = $(categories).filter("optgroup[label='#{material}']").html()
    $('#article_ssubcategory_id').html(options)
    $('#article_ssubcategory_id').parent().show()


  $('#article_subcategory_id').change ->
    material = $('#article_subcategory_id :selected').text()
    options = $(categories).filter("optgroup[label='#{material}']").html()

    if options
      $('#article_ssubcategory_id').html(options)
      $('#article_ssubcategory_id').parent().show()
    else
      $('#article_ssubcategory_id').empty()
      $('#article_ssubcategory_id').parent().hide()