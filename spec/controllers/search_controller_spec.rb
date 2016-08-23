require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  let!(:questions) { create(:question, title: 'Test Text Sphinx') }

  describe 'GET #find' do
    context 'with valid params' do
      context 'Any search type' do
        let(:search_type) { get :find, query: 'sphinx', search_type: 'questions' }

        it 'find with specified type' do
          expect(Question).to receive(:search).with('sphinx')
          search_type
        end

        it 'assigns to @content' do
          search_type
          expect(assigns(:content)).to be_instance_of(ThinkingSphinx::Search)
        end

        it 'redirect to find view' do
          search_type
          expect(response).to render_template :find
        end
      end

      context 'anywhere' do
        let(:search_anywhere) { get :find, query: 'sphinx', search_type: 'anywhere' }

        it 'find with specified type' do
          expect(ThinkingSphinx).to receive(:search).with('sphinx')
          search_anywhere
        end

        it 'assigns to @content' do
          search_anywhere
          expect(assigns(:content)).to be_instance_of(ThinkingSphinx::Search)
        end

        it 'redirect to find view' do
          search_anywhere
          expect(response).to render_template :find
        end
      end
    end

    context 'with invalid params' do
      before { get :find, query: 'sphinx', search_type: 'invalid' }

      it 'redirect to root path' do
        expect(response).to redirect_to root_url
      end
    end
  end
end
