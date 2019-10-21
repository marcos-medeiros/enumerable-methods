# frozen_string_literal: true

module Enumerable
  def my_each
    return .to_enum unless block_given?

    if self.class == Array
      i = 0
      while i < length
        yield(self[i])
        i += 1
      end
    elsif self.class == Hash
      keys = self.keys
      keys.length.times do |j|
        key = keys[j]
        value = self[key]
        yield(keys, value)
      end
    end
  end

  # def my_each_with_index
  # end teste oi
end
