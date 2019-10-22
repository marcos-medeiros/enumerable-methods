# frozen_string_literal: true

module Enumerable
  def my_each
    return .to_enum unless block_given?

    length.times { |i| yield(self[i]) }
    self
  end

  def my_each_with_index
    return .to_enum unless block_given?

    length.times { |i| yield(self[i], i) }
  end

  def my_select
    return .to_enum unless block_given?

    arr = []
    my_each { |i| yield(i) ? arr.push(i) : i }
    arr
  end

  def my_all?
    return .to_enum unless block_given?

    my_each do |i|
      case yield i
      when false
        return false
      end
    end
    true
  end

  def my_any?
    return .to_enum unless block_given?

    my_each do |i|
      case yield i
      when true
        return true
      end
    end
    false
  end

  def my_none?
    return .to_enum unless block_given?

    (my_any? { |i| yield(i) == true }) != true
  end

  def my_count
    return .to_enum unless block_given?

    my_each_with_index { |_n, i| i + 1 }
  end

  def my_map(proc = nil)
    return .to_enum unless block_given?

    arr = []
    if proc
      my_each { |x| arr.push(proc.call(x)) }
    else
      my_each { |x| arr.push(yield x) }
    end
    arr
  end

  def my_inject
    return .to_enum unless block_given?

    x = shift
    y = x
    my_each { |num| x = yield(x, num), x }
    unshift(y)
    x
  end

  def multiply_els(arr)
    return .to_enum unless block_given?

    arr.my_inject { |x, num| x * num }
  end
end
