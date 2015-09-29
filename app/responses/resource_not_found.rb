class ResourceNotFound < Praxis::Responses::NotFound
  
  def initialize(id:, type: nil, headers:{})
    name = if type.nil?
      'Resource'
    else
      type.name.demodulize
    end

    body = "#{name} with id: #{id} was not found in the system"
    headers['Content-Type']='text/plain'
    super(status: self.class.status, headers: headers, body: body)
  end
end