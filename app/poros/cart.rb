class Cart
  attr_reader :contents

  def initialize(initial_contents)
    @contents = initial_contents || Hash.new(0)
  end

  def items_count
    @contents.count
  end

  def add_item(id, quantity)
    @contents[id.to_s] = count_of(id) + quantity.to_i
  end

  def count_of(id)
    @contents[id.to_s].to_i
  end
end
