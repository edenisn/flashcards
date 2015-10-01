require 'rails_helper'

describe Pack do

  let!(:user) { FactoryGirl.create(:user) }
  let!(:pack) { FactoryGirl.create(:pack, user: user) }

  context "scopes" do

    it "is include pack that have current attribute = true" do
      expect(Pack.current_and_true).to include(pack)
    end

    it "is not include pack that have current attribute = false" do
      pack.update(current: false)
      expect(Pack.current_and_true).to_not include(pack)
    end

  end

end