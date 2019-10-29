# spec/enumerable_spec.rb

# frozen_string_literal: true

# rubocop:disable Metrics/LineLength

require './lib/enumerable.rb'

RSpec.describe Enumerable do
  describe '#my_all?' do
    it 'when no block or argument is given returns true when none of the collection members are false or nil' do
      expect([].my_all?).to eql(true)
    end
    it 'return false when any of the collection members are false or nil' do
      expect([nil, true, 99].my_all?).to eql(false)
    end
    it 'when a class is passed as an argument returns true if all of the collection is a member of such class' do
      expect([1, 21, 3].my_all?(Integer)).to eql(true)
    end
    it 'when a Regex is passed as an argument returns true if all of the collection matches the Regex' do
      expect(%w[ant airplane apple].all?(/a/)).to eql(true)
    end
    it 'when a pattern other than Regex or a Class is given returns true if all of the collection matches the pattern' do
      expect(%w[ant bear cat].all? { |word| word.length >= 3 }).to eql(true)
    end
  end
  describe '#my_any?' do
    it 'when no block or argument is given returns true if at least one of the collection is not false or nil' do
      expect([].my_any?).to eql(false)
    end
    it 'return true if any of the collection members are true' do
      expect([nil, true, false].my_any?).to eql(true)
    end
    it 'when a class is passed as an argument returns true if at least one of the collection is a member of such class' do
      expect([nil, true, 99].any?(Integer)).to eql(true)
    end
    it 'when a Regex is passed as an argument returns false if none of the collection matches the Regex' do
      expect(%w[ant bear cat].any?(/d/)).to eql(false)
    end
    it 'when a pattern other than Regex or a Class is given returns false if none of the collection matches the pattern' do
      expect(%w[ant bear cat].any? { |word| word.length >= 5 }).to eql(false)
    end
  end
end

# rubocop:enable Metrics/LineLength
