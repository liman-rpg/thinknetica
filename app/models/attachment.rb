class Attachment < ActiveRecord::Base
  mount_uploader :file, FileUploader

  belongs_to :question

  validates :file, presence: true
end
