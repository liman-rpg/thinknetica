require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'GET #index' do
    let(:question) { create_list(:question, 2) }

    before { get :index }

    it 'populates an array for all questions' do
      expect(assigns(:questions)).to match_array(question)
    end

    it 'render index veiw' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, id: question }

    it 'assigns the request question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'render show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user
    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    sign_in_user
    before { get :edit, id: question }

    it 'assigns the request question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'render edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'save new question in database' do
        expect { post :create, question: attributes_for(:question) }.to change(Question, :count).by(+1)
      end
      # Вопрос: нужно ли явно указывать? что .by(+1) именно с "+"?

      it 'save new question for user in database' do
        expect { post :create, question: attributes_for(:question) }.to change(@user.questions, :count).by(+1)
      end

      it 'redirects to show view' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
       expect { post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
       expect { post :create, question: attributes_for(:invalid_question) }.to_not change(@user.questions, :count)
      end

      it 're-renders new view' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end

    describe 'POST #update' do
      sign_in_user

      context 'with valid attributes ' do
        it 'assigns request the question to @question' do
          post :update , id: question, question:attributes_for(:question)
          expect(assigns(:question)).to eq question
        end

        it 'change question attributes' do
          post :update, id: question, question: {title: 'new title', body: 'new body'}
          question.reload
          expect(question.title).to eq "new title"
          expect(question.body).to eq "new body"
        end

        it 'redirect to update question' do
          post :update, id: question, question:attributes_for(:question)
          expect(response).to redirect_to question
        end
      end

      context 'with invalid question' do
        before { post :update, id: question, question: {title: 'new title', body: 'nill'} }

        it 'does not change question attributes' do
          question.reload
          expect(question.title).to eq question[:title]
          expect(question.body).to eq "MyText"
        end

        it 're-renders edit veiw' do
          expect(response).to render_template :edit
        end
      end
    end


    describe 'DELETE #destroy' do
      sign_in_user
      before { question }

      it 'delete question' do
        expect { delete :destroy, id: question }.to change(Question, :count).by(-1)
      end

      it 'redirect to #index' do
        delete :destroy, id: question
        expect(response).to redirect_to questions_path
      end
    end
  end
end
