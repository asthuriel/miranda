class Base
  def self.list_response(name, count, data)
    return {
      meta: {
        resource_name: name,
        count: count
      },
      data: data
    }
  end

  def self.transaction_response(name)
    return {
      meta: {
        resource_name: name
      },
      success: false,
      data: '',
      errors: []
    }
  end
end
