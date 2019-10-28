# frozen_string_literal: true

module Enumerable
  def my_each
    return to_enum :my_each unless block_given?

    arr = to_a
    length.times { |i| yield arr[i] } unless is_a? Hash
    length.times { |i| yield arr[i][0], arr[i][1] }
    self
  end
end
