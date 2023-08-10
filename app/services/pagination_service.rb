class PaginationService
  DEFAULT_PAGE = 1
  DEFAULT_PER_PAGE = 10
  MAX_PER_PAGE = 100

  def initialize(relation, page: DEFAULT_PAGE, per_page: DEFAULT_PER_PAGE)
    @relation = relation
    @page = page.to_i
    @per_page = per_page.to_i.clamp(1, MAX_PER_PAGE)
  end

  def call
    {
      page: @page,
      per_page: @per_page,
      total_count: @relation.count,
      total_pages: total_pages,
      records: records
    }
  end

  private

  def total_pages
    (@relation.count / @per_page.to_f).ceil
  end

  def records
    @relation.offset((@page - 1) * @per_page).limit(@per_page)
  end
end