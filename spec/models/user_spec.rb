require 'spec_helper'

describe User do

  before { @user = User.new(name: "Example Name", email: "nigger@yolo.com", password: "nigger",
                            password_confirmation: "nigger") }

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authenticate) }

  it { should be_valid }


  describe "when name is missing" do
    before { @user.name = " " }
    it { should_not be_valid }
  end

  describe "when email is missing" do
    before { @user.email = " " }
    it { should_not be_valid }
  end

  describe "when user name is too long" do
    before { @user.name = "a" * 50 }
    it { should_not be_valid }
  end


  describe "when email format is invalid" do
    it "should be invaild" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invaild_address|
        @user.email = invaild_address
        expect(@user).not_to be_valid

      end
    end
  end

  describe "when email format is vaild" do
    it "should be vaild" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |vaild_address|
        @user.email = vaild_address
        expect(@user).to be_valid
      end
    end
  end

  describe "when a email is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email = @user.email.upcase
      user_with_same_email.save
    end
    it { should_not be_valid }
  end

  describe "when wmail is mixed case" do
    let(:mixed_case) { "FoObAr@ExAmPlE.cOm" }

    it "should be saved as all lower case" do
      @user.email = mixed_case
      @user.save
      expect(@user.reload.email).to eq mixed_case_email.downcase
    end
  end


  describe "when a password feild is empty" do
    before do
      @user = User.new(name: "Example User", email: "user@example.com",
                       password: " ", password_confirmation: " ")
    end
    it { should_not be_valid }
  end

  describe "password mismatch" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  describe "password is too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should_not be_valid }
  end

  describe "return value of auth method" do
    before { @user.save }
    let(:found_user) { User.find_by(email: @user.email) }

    describe "with vaild password" do
      it { should eq found_user.authenticate(@user.password) }
    end

    describe "with invaild password" do
      let(:user_with_invaild_password) { found_user.authenticate("invaild") }

      it { should_not eq user_with_invaild_password }
      specify { expect(user_for_invalid_password).to be_false }
    end
  end
end