require 'test_helper'

class UserVisitsHomePageTest < ActionDispatch::IntegrationTest
  setup do
    @user = users :one
    sign_in
  end

  #test "the truth" do
  #  assert true
  #end

  test "should go to home after clicking on home" do
  	within("div#globalNavbar.collapse.navbar-collapse") do
  		click_on('Home', match: :first)
  		assert_equal current_path, root_path
  	end	
  end

  test "should go to about page when clicking about in header"  do
  	within("div#globalNavbar.collapse.navbar-collapse") do
  		click_on('About', match: :first)
  		assert_equal current_path, aboutus_path
  	end	
  end 

  #dpc = discover previous conversations
  test "should go to dpc page when clicking on dpc in header"  do
  	within("div#globalNavbar.collapse.navbar-collapse") do
  		click_on("Discover Previous Conversations", match: :first)
  		assert_equal current_path, supportourwork_path
  	end	
  end 

  test "should go to FAQ page when clicking on FAQ in header"  do
  	within("div#globalNavbar.collapse.navbar-collapse") do
  		click_on('FAQ', match: :first)
  		assert_equal current_path, faq_path
  	end	
  end 

  test "should go to view profile after clicking on user name and clicking view profile"  do
  	click_on(class: "dropdown-toggle")
  	click_on("View Profile", match: :first)
  	assert_equal current_path, user_profile_path(@user.permalink)
  end 

  test "should go to control panel after clicking on user name and clicking control panel"  do
  	click_on(class: "dropdown-toggle")
  	click_on("Control Panel", match: :first)
  	assert_equal current_path, user_controlpanel_path(@user.permalink)
  end

  test "should be able to sign out correctly" do
  	click_on("Sign out", match: :first)
  	assert_equal current_path, root_path
  end	

  test "should go to about page when clicking about in footer"  do
  	within("div.col-sm-2.col-sm-offset-1") do
  		click_on('About', match: :first)
  		assert_equal current_path, aboutus_path
  	end	
  end 

  test "should go to FAQ page when clicking on FAQ in footer"  do
  	within("div.col-sm-2.col-sm-offset-1") do
  		click_on('FAQ', match: :first)
  		assert_equal current_path, faq_path
  	end	
  end

  #tos = terms of service
  test "should go to tos page when clicking on tos in footer"  do
  	within("div.col-sm-2.col-sm-offset-1") do
  		click_on("Terms of Service", match: :first)
  		assert_equal current_path, tos_path
  	end	
  end  

  test "should open email after clicking on contact email in footer" do
  	#click_on(class: 'f-link')

  end	

  test "should be able to share website with social media" do
  	#assert_redirected_to %r(\Ahttp://localhost:3000/assets/social-share-button/facebook-cc0ec86441dbe9e86b58ac3e84d30dd1de8830c74e41e424aa447327795850df.png)
  end	


  def sign_in
    visit root_path

    click_on('Sign In', match: :first)

    fill_in(id: 'user_email', with: 'fake@fake.com')
    fill_in(id: 'user_password', with: 'user1234')

    click_on(class: 'form-control btn-primary')
  end
end
