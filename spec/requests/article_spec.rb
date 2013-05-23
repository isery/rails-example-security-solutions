require "spec_helper"

describe "Users", :type => :request do

  describe "EVIL TEST: create a article" do

    it "with not logged in" do
      post "/articles", :article => { :title => 'yeah', :description => 'This is a nice tag'}
      expect(response.status).to eql(302)  # http redirect when create succeeds

      a = Article.find_by_title('yeah')
      a.should be_nil
    end
  end
end
