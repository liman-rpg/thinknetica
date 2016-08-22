ThinkingSphinx::Index.define :comment, with: :active_record do
  #fileds
  indexes body

  # attributes
  has user_id, created_at, updated_at, commentable_id, commentable_type
end
