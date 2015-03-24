require 'rails_helper'

describe Guest do
  describe 'guest?' do
    it 'returns true' do
      expect(Guest.new.guest?).to eq true
    end
  end

  describe '#can_edit?' do
    it 'returns false' do
      question = stub
      expect(Guest.new.can_edit?(question)).to eq false
    end
  end
end
