module InvestmentFilters
  extend ActiveSupport::Concern

  class_methods do
    def investment_filters
      %w[not_unfeasible feasible unfeasible unselected selected winners]
    end
  end

  def set_default_investment_filter
    if @budget&.finished?
      params[:filter] ||= "winners"
    elsif @budget&.publishing_prices_or_later?
      params[:filter] ||= "selected"
    end
  end
end
