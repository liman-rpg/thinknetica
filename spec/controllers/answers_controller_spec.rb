require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  describe 'GET #new' do
    sign_in_user
    before { get :new, question_id: question }

    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    sign_in_user
    before { get :edit, id: answer, user_id: @user }

    it 'assigns requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'render edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      let(:create_answer) { post :create, question_id: question, answer: attributes_for(:answer) }

        it "save new answer for question in database" do
          expect { create_answer }.to change(question.answers, :count).by(+1)
        end

        it "save new answer for user in database" do
          expect { create_answer }.to change(@user.answers, :count).by(+1)
        end

        it "redirect to new view" do
          create_answer
          expect(response).to redirect_to question_path(question)
        end
     end

    context 'with invalid attributes' do
      let(:invalid_answer) { post :create, question_id: question, answer: attributes_for(:invalid_answer) }

      it "does not save answer for question in database" do
        expect { invalid_answer }.to_not change(question.answers, :count)
      end

      it "does not save answer for user in database" do
        expect { invalid_answer }.to_not change(@user.answers, :count)
      end

      it "redirect to new view" do
        invalid_answer
        expect(response).to render_template :new
      end
    end
  end

  describe 'POST #update' do
    sign_in_user

    context 'with valid attributes' do
      it "assign requested question to @question" do
        patch :update, id: answer, answer: attributes_for(:answer)
        expect(assigns(:answer)).to eq answer
      end

      it "change answer attributes" do
        patch :update, id: answer, answer: { body: "Mytest" }
        answer.reload
        expect(answer.body).to eq "Mytest"
      end

        it "redirect to answers question" do
        patch :update, id: answer, answer: attributes_for(:answer)
        expect(response).to redirect_to question_url(answer.question_id)
      end
    end

    context 'with invalid attributes' do
      it "does not change question attributes" do
        patch :update, id: answer, answer: { body: nil }
        answer.reload
        expect(answer.body).to eq answer[:body]
      end

      it "render edit view" do
        patch :update, id: answer, answer: { body: nil }
        expect(response).to render_template :edit
      end
    end
  end


  describe 'DELETE #destroy' do
    sign_in_user
    let(:destroy_answer) { delete :destroy, question_id: answer.question_id, id: answer }

    it "delete answer from database" do
      answer
      expect { destroy_answer }.to change(Answer, :count).by(-1)
    end

    it "redirect to question show view" do
      destroy_answer
      expect(response).to redirect_to question_url(answer.question_id)
    end
  end
end
