class QuestionSerializer < ActiveModel::Serializer
  #показывает root ( question: {...} )
  ActiveModelSerializers.config.adapter = :json

  attributes :id, :title, :body, :created_at, :updated_at

  has_many :attachments
  has_many :comments
end
