require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  sign_in_user

  let(:question) { create(:question, user_id: @user.id) }
  let(:answer)   { create(:answer, question_id: question.id, user_id: @user.id) }

  describe 'POST #create for questions' do
    context 'with valid attributes' do
      let(:create_comment) { post :create, commentable: 'questions', question_id: question.id, comment: attributes_for(:comment), format: :js }

        it "save new comment in database" do
          expect { create_comment }.to change(question.comments, :count).by(+1)
        end

        it "save new comment for user in database" do
          expect { create_comment }.to change(@user.comments, :count).by(+1)
        end

        it 'Create @comment.to_json after create comment for questions' do
          expect(PrivatePub).to receive(:publish_to).with('/comments', anything)

          create_comment
        end

        it "render nothing" do
          create_comment

          expect(response.body).to eq ""
        end
     end

    context 'with invalid attributes' do
      let(:create_invalid_comment) { post :create, commentable: 'question', question_id: question, comment: { body: nil }, format: :js }

      it "does not save comment for question in database" do
        expect { create_invalid_comment }.to_not change(question.comments, :count)
      end

      it "Don't create @comment.to_json after create comment for questions" do
        expect(PrivatePub).to_not receive(:publish_to).with('/comments', anything)

        create_invalid_comment
      end

      it "does not save comment for user in database" do
        expect { create_invalid_comment }.to_not change(@user.comments, :count)
      end
    end
  end

  describe 'POST #create for answers' do
    context 'with valid attributes' do
      let(:create_comment) { post :create, commentable: 'answers', answer_id: answer.id, comment: attributes_for(:comment), format: :js }

        it "save new comment in database" do
          expect { create_comment }.to change(answer.comments, :count).by(+1)
        end

        it "save new comment for user in database" do
          expect { create_comment }.to change(@user.comments, :count).by(+1)
        end

        it 'Create @comment.to_json after create comment for answer' do
          expect(PrivatePub).to receive(:publish_to).with('/comments', anything)

          create_comment
        end

        it "render nothing" do
          create_comment

          expect(response.body).to eq ""
        end
     end

    context 'with invalid attributes' do
      let(:create_invalid_comment) { post :create, commentable: 'answer', answer_id: answer.id, comment: { body: nil }, format: :js }

      it "does not save comment for answer in database" do
        expect { create_invalid_comment }.to_not change(answer.comments, :count)
      end

      it "Don't create @comment.to_json after create comment for answer" do
        expect(PrivatePub).to_not receive(:publish_to).with('/comments', anything)

        create_invalid_comment
      end

      it "does not save comment for user in database" do
        expect { create_invalid_comment }.to_not change(@user.comments, :count)
      end
    end
  end

end
