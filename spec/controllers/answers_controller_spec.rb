require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  it_behaves_like 'voted'

  sign_in_user

  let(:question) { create(:question, user_id: @user.id) }
  let(:answer)   { create(:answer, question_id: question.id, user_id: @user.id) }

  describe 'GET #new' do
    before { get :new, question_id: question.id }

    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { get :edit, id: answer, user_id: @user.id }

    it 'assigns requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'render edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      let(:create_answer) { post :create, question_id: question.id, answer: attributes_for(:answer), format: :js }

        it "save new answer in database" do
          expect { create_answer }.to change(question.answers, :count).by(+1)
          expect(assigns(:answer).user_id).to eq @user.id
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
    let(:answer) { create(:answer, question: question, user_id: @user.id) }
    let(:update) { patch :update, id: answer, question_id: answer.question_id, answer: attributes_for(:answer), format: :js }
    let(:update_body) { patch :update, id: answer, question_id: answer.question_id, answer: { body: "Mytest" }, format: :js }

    context 'with valid attributes' do
      it "assign requested answer to @answer" do
        update
        expect(assigns(:answer)).to eq answer
      end

      it "change answer attributes" do
        update_body
        answer.reload
        expect(answer.body).to eq "Mytest"
      end

      it "assigns the question" do
        update
        expect(assigns(:answer).question_id).to eq question.id
      end

      it "render template update" do
        update
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      let(:invalid_attributes) { patch :update, id: answer, question_id: answer.question_id, answer: { body: nil }, format: :js }

      before do
        invalid_attributes
      end

      it "does not change question attributes" do
        answer.reload
        expect(answer.body).to_not eq nil
      end

      it "render edit view" do
        expect(response).to render_template :update
      end
    end
  end


  describe 'DELETE #destroy' do
    let(:destroy_answer) { delete :destroy, question_id: answer.question_id, id: answer, format: :js }

    it "delete answer from database" do
      answer
      expect { destroy_answer }.to change(Answer, :count).by(-1)
    end

    it "redirect to question show view" do
      destroy_answer
      expect(response).to render_template :destroy
    end
  end
end
