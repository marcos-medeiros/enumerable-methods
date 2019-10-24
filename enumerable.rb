# frozen_string_literal: true

module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?

    length.times { |i| yield(self[i]) }
    self
  end

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    length.times { |i| yield(self[i], i) }
  end

  def my_select
    return to_enum(:my_select) unless block_given?

    arr = []
    my_each { |i| yield(i) ? arr.push(i) : i }
    arr
  end

  def my_all?
    return my_all? { |obj| obj } unless block_given?

    my_each do |i|
      case yield i
      when false
        return false
      end
    end
    true
  end

  def my_any?
    return my_any? { |obj| obj } unless block_given?

    my_each do |i|
      case yield i
      when true
        return true
      end
    end
    false
  end

  def my_none?
    (my_any? { |i| yield(i) == true }) != true
  end

  def my_count(arg = nil)
    return length(:my_count) unless block_given? && arg.nil?

    if !block_given? && !arg.nil?
      count_arr = []
      my_each(:my_count) { |x| count_arr << x unless x != arg }
      count_arr.length

    elsif block_given? && arg.nil?
      count_arr = my_select(:my_count) { |x| yield(x) }
      count_arr.length
    end
  end

  def my_map(proc = nil)
    return to_enum(:my_map) unless block_given?

    arr = []
    if proc
      my_each { |x| arr.push(proc.call(x)) }
    else
      my_each { |x| arr.push(yield x) }
    end
    arr
  end

  def my_inject
    return 'no block given' unless block_given?

    x = shift
    y = x
    my_each { |num| x = yield(x, num), x }
    unshift(y)
    x
  end

  def multiply_els(arr)
    return to_enum(:multiply_els) unless block_given?

    arr.my_inject { |x, num| x * num }
  end
end
