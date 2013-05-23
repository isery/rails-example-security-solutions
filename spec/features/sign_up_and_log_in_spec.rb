require "spec_helper"

describe "Sign Up and Log In", :type => :feature do

  def user_data
      { :name => "the tester", :email => "foo@bar.com", :password => "1234567" }
  end
  def article_data
      { :title => "the title", :description => "this is a very important article" }
  end

  it "stranger can read articles" do
    @a = Article.create!( article_data )
    visit "/"
    expect(page).to have_text( article_data[:title] )
    expect(page).to have_text( article_data[:description] )
    expect(page).to_not have_link( "write new article", :href => new_article_path      )
    expect(page).to_not have_link( "Edit",                    :href => edit_article_path(@a) )
  end

  it "user can sign up, is logged in afterwards" do
    @a = Article.create!( article_data )
    visit "/"
    click_link "Sign up"
    fill_in "Name",     :with => user_data[:name]
    fill_in "Email",    :with => user_data[:email]
    fill_in "Password", :with => user_data[:password]
    click_button "Create User"
    expect(page).to have_text("User was successfully created")
    expect(page).to have_text("Logged in as")
    expect(page).to have_text( user_data[:name] )
    click_link "Article"
    expect(page).to have_link( "write new article", :href => new_article_path      )
    expect(page).to have_link( "Edit",                    :href => edit_article_path(@a) )
  end

  it "user can log in" do
    @u = User.create!( user_data )
    @a = Article.create!( article_data )
    visit "/"
    click_link "Log in"
    fill_in "Email",    :with => user_data[:email]
    fill_in "Password", :with => user_data[:password]
    click_button "Login"
    expect(page).to have_text("Logged in as")
    expect(page).to have_text( user_data[:name] )
    click_link "Article"
    expect(page).to have_link( "write new article", :href => new_article_path      )
    expect(page).to have_link( "Edit",                    :href => edit_article_path(@a) )
  end

  it "can not edit other articles" do
    @u1 = User.create!( user_data )
    @u = User.create!( { :name => "michael", :email => "bar@bar.com", :password => "1234567" } )
    visit "/"
    click_link "Log in"
    fill_in "Email",    :with => user_data[:email]
    fill_in "Password", :with => user_data[:password]
    click_button "Login"
    expect(page).to have_text("Logged in as")  
    visit "/articles"
    click_link "write new article"
    fill_in "Title", :with => "Testartikel"
    fill_in "Description", :with => "Das ist ein Testeintrag"
    click_button "Create Article"
    visit "1/edit"
    expect(page).to have_button("Update Article")
    click_link "Log out"
    visit "/"
    visit "articles/1/edit"
    expect(page).to_not have_button("Update Article")
    click_link "Log in"
    fill_in "Email",    :with => user_data[:email]
    fill_in "Password", :with => user_data[:password]
    visit "articles/1/edit"
    expect(page).to_not have_button("Update Article")
  end
end
