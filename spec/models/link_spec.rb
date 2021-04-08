require 'rails_helper'

RSpec.describe Link do
  it "should require an original_url" do
    expect(Link.new(original_url: nil)).to_not be_valid
  end

  it "should require original_url to be a url" do
    expect(Link.new(original_url: "not a url")).to_not be_valid
  end
end