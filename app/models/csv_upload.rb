class CsvUpload < ActiveRecord::Base
  has_attached_file :document,
                    :content_type => { content_type: ['text/csv', 'application/vnd.ms-excel'] }


  do_not_validate_attachment_file_type :document
end
