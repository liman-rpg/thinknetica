require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }
  it { should have_many(:attachments) }

  it { should validate_presence_of(:question_id) }
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of :body }
  it { should validate_length_of(:body).is_at_least(5) }

  it { should have_db_column(:best).of_type(:boolean).with_options(default: false) }

  it { should accept_nested_attributes_for :attachments }
end
