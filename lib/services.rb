module Services
  class Pagination
    attr_reader :collection, :params

    def initialize(collection, params = {})
      @collection = collection
      @params = params.merge(count: collection.size)
    end

    def metadata
      @metadata ||= ViewModel::Pagination.new(params)
    end

    def results
      collection[metadata.offset, metadata.per_page]
    end
  end
end