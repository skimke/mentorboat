class GoalsController < ApplicationController
  before_action :ensure_user_belongs_to_relationship

  def new
    @goal = Goal.new
  end

  private

  def goal_params
    params.require(:goal).permit(
      :title,
      :description
    )
  end

  def ensure_user_belongs_to_relationship
    @relationship = Relationship.find(params[:relationship_id])

    redirect_to relationship_url(@relationship) unless user_belongs_to_relationship?(@relationship)
  end

  def user_belongs_to_relationship?(relationship)
    relationship.mentor_id == current_user.id || relationship.mentee_id == current_user.id
  end
end
