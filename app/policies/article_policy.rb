class ArticlePolicy < ApplicationPolicy

  def index?
    true
  end

  def show?
    user.present?
  end

  def create?
    user.present?
  end

  def new
    create?
  end

  def update?
    return true if user.present? && user == article.user
  end

  def edit?
    update?
  end

  def destroy?
    return true if user.present? && user == article.user
  end

  private
  def article
    record
  end

end