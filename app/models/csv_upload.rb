class CsvUpload < ActiveRecord::Base
  has_attached_file :document,
                    :content_type => { content_type: 'text/csv' }


  do_not_validate_attachment_file_type :document
end
