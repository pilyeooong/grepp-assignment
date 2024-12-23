module Validator
  def validate_page_param(page)
    begin
      Integer(page)
      page = 1 if page.blank? || page.to_i < 1

      page.to_i
    rescue Exception
      1
    end
  end

  def validate_limit_param(limit)
    begin
      Integer(limit)
      limit = 10 if limit.blank?
      limit = 50 if limit.to_i > 50

      limit.to_i
    rescue Exception
      10
    end
  end
end
