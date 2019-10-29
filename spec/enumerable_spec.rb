# spec/enumerable_spec.rb

# frozen_string_literal: true

require './lib/enumerable.rb'

RSpec.describe Enumerable do
  describe '#each' do
    it 'test' do
      enumerable = Enumerable.new
      expect(enumerable.each(5, 2)).to eql(7)
    end
  end
end
