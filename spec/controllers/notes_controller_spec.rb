require 'rails_helper'

RSpec.describe NotesController, type: :controller do
  describe "notes#index action" do
    it "should successfully respond" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "should return all Notes in ascending order" do
      2.times do
        FactoryGirl.create(:note)
      end
      get :index
      json = JSON.parse(response.body)
      expect(json[0]['id'] < json[1]['id']).to be true
    end
  end

  describe "notes#create action" do
    before do
      post :create, params: {note: {title: 'First', content: 'Hello'}}
    end
    it "should return 200 status-code" do
      expect(response).to be_success
      #expect(response).to have_http_status(:success) This is the same as above
    end

    it "should successfully create & save a note in the db" do
      note = Note.last
      expect(note.content).to eq('Hello')
      expect(note.title).to eq('First')
    end

    it "should return the created note in the response body" do
      json = JSON.parse(response.body)
      expect(json['content']).to eq('Hello')
      expect(json['title']).to eq('First')
    end
  end

  describe "notes#create action validations" do
    before do
      post :create, params: { note: { title: '', content: '' } }
    end
    it "should properly deal with validation errors" do
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "should return error json on validation error" do
      json = JSON.parse(response.body)
      expect(json["errors"]["content"][0]).to eq("can't be blank")
      expect(json["errors"]["title"][0]).to eq("can't be blank")
    end
  end

end
