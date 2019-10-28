# frozen_string_literal: true

module Enumerable
  def my_each
    return to_enum :my_each unless block_given?

    arr = to_a
    length.times { |i| yield arr[i] } unless is_a? Hash
    length.times { |i| yield arr[i][0], arr[i][1] }
    self
  end

  def my_each_with_index
    return to_enum :my_each_with_index unless block_given?

    arr = to_a
    length.times { |i| yield arr[i], i }
    self
  end

  def my_select
    return to_enum :my_select unless block_given?

    if is_a? Hash
      selected = {}
      my_each { |k, v| selection[k] = v if yield k, v }
      return selected
    end
    selected = []
    my_each { |v| selection << v if yield v }
    selected
  end
end
