# Cuts an array into pages: paginate_array(rows, per_page: 20) returns the
# page info and the rows on the current page (params[:page], from 1).
module ViewPagination
  extend ActiveSupport::Concern

  PageInfo = Struct.new(:number, :per_page, :total) do
    def pages = [ (total.to_f / per_page).ceil, 1 ].max
    def previous? = number > 1
    def next? = number < pages
  end

  private

  def paginate_array(rows, per_page:)
    page = PageInfo.new([ params[:page].to_i, 1 ].max, per_page, rows.size)
    page.number = page.pages if page.number > page.pages
    [ page, rows.slice((page.number - 1) * per_page, per_page) || [] ]
  end
end
