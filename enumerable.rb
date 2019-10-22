# frozen_string_literal: true
# rubocop:disable Style/LineLength, Style/StringLiterals

module Enumerable
  def my_each
    return self.to_enum unless block_given?

    length.times { |i| yield(self[i]) }
    self
  end

  def my_each_with_index
    return self.to_enum unless block_given?

    length.times { |i| yield(self[i], i) }
  end

  def my_select
    return self.to_enum unless block_given?

    arr = []
    my_each { |i| yield(i) ? arr.push(i) : i }
    arr
  end

  def my_all?
    return self.to_enum unless block_given?

    my_each do |i|
      case yield i
      when false
        return false
      end
    end
    true
  end

  def my_any?
    return self.to_enum unless block_given?

    my_each do |i|
      case yield i
      when true
        return true
      end
    end
    false
  end

  def my_none?
    return self.to_enum unless block_given?

    (my_any? { |i| yield(i) == true }) != true
  end

  def my_count
    return self.to_enum unless block_given?

    my_each_with_index { |_n, i| i + 1 }
  end

  def my_map(proc = nil)
    return self.to_enum unless block_given?
    
    arr = []
    if proc
      my_each { |x| arr.push(proc.call(x)) }
    else
      my_each { |x| arr.push(yield x) }
    end
    arr
  end

  def my_inject
    return self.to_enum unless block_given?

    x = shift
    y = x
    my_each { |num| x = yield(x, num), x }
    unshift(y)
    x
  end

  def multiply_els(arr)
    return self.to_enum unless block_given?

    arr.my_inject { |x, num| x *= num }
  end
end
