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
      let(:create_answer) { post :create, question_id: question, answer: attributes_for(:answer), format: :js }

        it "save new answer for question in database" do
          expect { create_answer }.to change(question.answers, :count).by(+1)
        end

        it "save new answer for user in database" do
          expect { create_answer }.to change(@user.answers, :count).by(+1)
        end

        it "render template create.js" do
          create_answer
          expect(response).to render_template :create
        end
     end

    context 'with invalid attributes' do
      let(:create_invalid_answer) { post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js }

      it "does not save answer for question in database" do
        expect { create_invalid_answer }.to_not change(question.answers, :count)
      end

      it "does not save answer for user in database" do
        expect { create_invalid_answer }.to_not change(@user.answers, :count)
      end

      it "render template create.js" do
        create_invalid_answer
        expect(response).to render_template :create
      end
    end
  end

  describe 'POST #update' do
    sign_in_user

    context 'with valid attributes' do
      it "assign requested answer to @answer" do
        patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
        expect(assigns(:answer)).to eq answer
      end

      it "change answer attributes" do
        patch :update, id: answer, question_id: question, answer: { body: "Mytest" }, format: :js
        answer.reload
        expect(answer.body).to eq "Mytest"
      end

      it "render template update" do
        patch :update, id: answer, answer: attributes_for(:answer), format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it "does not change question attributes" do
        patch :update, id: answer, question_id: question, answer: { body: nil }, format: :js
        answer.reload
        expect(answer.body).to_not eq nil
      end

      it "render edit view" do
        patch :update, id: answer, question_id: question, answer: { body: nil }, format: :js
        expect(response).to render_template :update
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
