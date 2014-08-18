require 'spec_helper'

describe "User pages" do

  subject { page }


  describe "profile page" do
    let (:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_content(user.name) }
    it { should have_title(user.name) }
  end

  describe "signup page" do
    before { visit signup_path }

    it { should have_content('Sign up') }
    it { should have_title(full_title('Sign up')) }
  end

  describe "signip" do
    before { visit signup_path }

    let(:submit) { "Create My Account" }

    describe "with invaild info" do
      it "should not create an account" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after form submission" do
        before { click_button submit }

        it { should have_title('Sign Up') }
        it { should have_content('Error') }
      end

    end

    describe "with vaild information" do
      before do
        fill_in "Name", with: "Example User"
        fill_in "Email", with: "Example@example.com"
        fill_in "Password", with: "Password"
        fill_in "Confirmation", with: "Password"
      end

      it "should create a vaild user" do
        expect { click_button submit }.to change(User, :count)
      end
    end
  end
end