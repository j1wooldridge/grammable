require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe "comments#create action" do
    let(:gram) { FactoryBot.create(:gram) }
    let(:user) { FactoryBot.create(:user) }
    let(:message) { 'awesome gram' }

    context "user is logged in" do
      before(:each) do
        sign_in user
      end

      it "allow users to create comments on grams" do
        post :create, params: { gram_id: gram.id, comment: { message: message } }

        gram.reload!

        expect(response).to redirect_to root_path
        expect(gram.comments.length).to eq 1
        expect(gram.comments.first.message).to eq message
      end

      it "creates a new gram post sucessfully" do
        expect { post :create, params: { gram_id: gram.id, comment: { message: message } } }.to change { Gram.count }.by(1)
      end

      it "return http status code of not found if the gram isn't found" do
        post :create, params: { gram_id: 'YOLOSWAG', comment: { message: message } }

        expect(response).to have_http_status :not_found
      end
    end

    context "user is not logged in" do
      it "require a user to be logged in to comment on a gram" do
        post :create, params: { gram_id: gram.id, comment: { message: message } }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
