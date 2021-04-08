require 'rails_helper'

RSpec.describe Link do
  it "should require an original_url" do
    expect(Link.new(original_url: nil)).to_not be_valid
  end

  it "should require original_url to be a url" do
    expect(Link.new(original_url: "not a url")).to_not be_valid
  end

  it "should require original_url be less than 32780 characters long" do
    long_url = "https://www.#{'a' * 32780}.com"
    expect(Link.new(original_url: long_url)).to_not be_valid
  end

  describe "before_validation" do
    it "should generate an admin slug on create" do
      expect(Link.create(original_url: "https://www.test.com").admin_slug).to_not be_nil
    end

    it "should generate a short slug on create" do
      expect(Link.create(original_url: "https://www.test.com").short_slug).to_not be_nil
    end

    it "should not change slugs on update" do
      link = Link.create(original_url: "https://www.test.com")
      expect {
        link.update(click_counter: 1)
      }.to_not change(link, :admin_slug)
    end
  end
end