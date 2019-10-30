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
      expect([nil, true, 99].my_any?(Integer)).to eql(true)
    end
    it 'when a Regex is passed as an argument returns false if none of the collection matches the Regex' do
      expect(%w[ant bear cat].my_any?(/d/)).to eql(false)
    end
    it 'when a pattern other than Regex or a Class is given returns false if none of the collection matches the pattern' do
      expect(%w[ant bear cat].my_any? { |word| word.length >= 5 }).to eql(false)
    end
  end
  describe '#my_none?' do
    it 'when no block or argument is given returns true only if none of the collection members is true' do
      expect([].my_none?).to eql(true)
    end
    it 'return true only if none of the collection members are true' do
      expect([nil, true, false].my_none?).to eql(false)
    end
    it 'when a class is passed as an argument returns true only if none of the collection is a member of such class' do
      expect([1, 3.14, 42].my_none?(Float)).to eql(false)
    end
    it 'when a Regex is passed as an argument returns true only if none of the collection matches the Regex' do
      expect(%w[ant bear cat].my_none?(/d/)).to eql(true)
    end
    it 'when a pattern other than Regex or a Class is given returns true only if none of the collection matches the pattern' do
      expect(%w[ant bear cat].my_none? { |word| word.length == 5 }).to eql(true)
    end
  end
  describe '#my_each' do
    it 'when no block or argument is given returns an enumerator' do
      expect([1..10].my_each).to be_a(Enumerator)
    end
    it 'Iterates the given block trough each item' do
      expect([1, 5, 10].my_each(&:to_s)).to eql([1, 5, 10].each(&:to_s))
    end
  end
  describe '#my_each_with_index' do
    it 'when no block or argument is given returns an enumerator' do
      expect([1..10].my_each_with_index).to be_a(Enumerator)
    end
    it 'Iterates the given block trough each item and respective index' do
      hash = {}
      expect(%w[cat dog wombat].my_each_with_index { |x, y| hash[x] = y }).to eql(%w[cat dog wombat].each_with_index { |x, y| hash[x] = y })
    end
  end
  describe '#my_select' do
    it 'when no block or argument is given returns an enumerator' do
      expect([1..10].my_select).to be_a(Enumerator)
    end
    it 'Returns an array containing all elements of enum for which the given block returns a true value.' do
      expect([1, 2, 3, 4, 5].my_select(&:even?)).to eql([1, 2, 3, 4, 5].select(&:even?))
    end
  end
  describe '#my_count' do
    it 'when no block or argument is given returns the length of enum' do
      expect([1, 2, 3, 4, 2, 5].my_count).to eql(6)
    end
    it ' If an argument is given, the number of items in enum that are equal to item are counted' do
      expect([1, 2, 3, 4, 2, 5].my_count(2)).to eql([1, 2, 3, 4, 2, 5].count(2))
    end
  end

  describe '#my_inject' do
    it 'return the sum of block when passed' do
      expect([3, 6, 10, 13].my_inject { |sum, number| sum + number }).to eql([3, 6, 10, 13].inject { |sum, number| sum + number })
    end
  end

  describe '#multiply_els' do
    it 'multiplies all the elements of the array together' do
      expect(multiply_els([2, 4, 5])).to eql(40)
    end
  end

  describe '#my_map' do
    it 'to return a new array with the executed block output' do
      expect([1, 2, 3].my_map { |n| n * 2 }).to eql([1, 2, 3].map { |n| n * 2 })
    end
  end
end

# rubocop:enable Metrics/LineLength
