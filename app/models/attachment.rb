class Attachment < ActiveRecord::Base
  belongs_to :question

  validates :file, presence: true

  mount_uploader :file, FileUploader
end
