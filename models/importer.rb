class Importer
  attr_accessor :type

  def initialize(class_name)
    self.type = Kernel.const_get(class_name)
  end

  def import(file_path, class_name)
    items = []
    CSV.foreach(file_path, headers: true, converters: :numeric) do |row|
      new_item = self.type.new(row)
      items << new_item
    end
    items
  end
end
