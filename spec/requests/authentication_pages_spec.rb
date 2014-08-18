require 'spec_helper'

describe "User Auth" do

  subject { page }

  describe "sign in page" do
    before { visit signin_path }

    it { should have_title('Sign In') }
    it { should have_title('Sign In') }

    describe "invaild sign in info" do
      before { click_button "Sign In" }

      it { should have_title('Sign In') }
      it { should have_selector('div.alert.alert-error') }
    end


    describe "vaild sign in info" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        fill_in "Email", with: user.email.upcase
        fill_in "Password", with: user.password
        click_button "Sign In"
      end

      it { should have_title(user.name) }
      it { should have_link('Profile', href: user_path(user)) }
      it { should have_link('Sign out', href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }
    end
  end
end