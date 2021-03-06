require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  it_behaves_like 'voted'

  let(:question) { create(:question) }

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

  # describe 'GET #edit' do
  #   sign_in_user
  #   before { get :edit, id: question }

  #   it 'assigns the request question to @question' do
  #     expect(assigns(:question)).to eq question
  #   end

  #   it 'render edit view' do
  #     expect(response).to render_template :edit
  #   end
  # end

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      let(:create_valid_question) { post :create, question: attributes_for(:question) }

      it 'save new question in database' do
        expect { post :create, question: attributes_for(:question) }.to change(Question, :count).by(+1)
      end
      # Вопрос: нужно ли явно указывать? что .by(+1) именно с "+"?

      it 'Create @question.to_json after create question ' do
        expect(PrivatePub).to receive(:publish_to).with('/questions', anything)
        create_valid_question
      end

      it 'save new question for user in database' do
        expect { post :create, question: attributes_for(:question) }.to change(@user.questions, :count).by(+1)
      end

      it 'redirects to show view with notice' do
        create_valid_question

        expect(response).to redirect_to question_path(assigns(:question))
        expect(flash[:notice]).to be_present
      end
    end


    context 'with invalid attributes' do
      let(:create_invalid_question) { post :create, question: attributes_for(:invalid_question) }

      it 'does not save the question in database' do
       expect { post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
      end

      it 'does not save the question for user in database' do
       expect { post :create, question: attributes_for(:invalid_question) }.to_not change(@user.questions, :count)
      end

      it "Don't Create @question.to_json after create question" do
        expect(PrivatePub).to_not receive(:publish_to).with('/questions', anything)
        create_invalid_question
      end

      it 're-renders new view' do
        create_invalid_question
        expect(response).to render_template :new
      end
    end
  end

  describe 'POST #update' do
    sign_in_user
    let(:update_question) { post :update, id: question, user_id: @user.id, question: {title: 'new title', body: 'new body'}, format: :js }

    context 'with valid attributes ' do
      let(:question) { create(:question, user_id: @user.id) }
      before { update_question }

      it 'assigns request the question to @question' do
        expect(assigns(:question)).to eq question
      end

      it 'change question attributes' do
        question.reload
        expect(question.title).to eq "new title"
        expect(question.body).to eq "new body"
      end

      it 'render template update.js for question' do
        expect(response).to render_template :update
      end
    end

    context 'with invalid question' do
      let(:question) { create(:question, user_id: @user.id) }
      before { post :update, id: question, question: {title: 'new title', body: 'nill'}, format: :js }

      it 'does not change question attributes' do
        question.reload
        expect(question.title).to eq question[:title]
        expect(question.body).to eq "MyText"
      end

      it 'render update.js view' do
        expect(response).to render_template :update
      end
    end
  end


  describe 'DELETE #destroy' do
    sign_in_user
    let(:question) { create(:question, title: 'ExampleTitle', body: 'ExampleBody', user_id: @user.id) }

    it 'delete question' do
      question
      expect { delete :destroy, id: question }.to change(Question, :count).by(-1)
    end

    it 'redirect to #index' do
      delete :destroy, id: question
      expect(response).to redirect_to questions_path
    end
  end
end
