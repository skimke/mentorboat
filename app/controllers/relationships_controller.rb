class RelationshipsController < ApplicationController
  before_action :ensure_admin

  def show
    relationship_id = params[:relationship_id]
    @relationship = Relationship.find(relationship_id)
    @user = User.find(params[:user_id])

    if @relationship.mentor.nil?
      @desired_user_type = 'mentor'
      @users = @relationship.cohort.mentors
    elsif @relationship.mentee.nil?
      @desired_user_type = 'mentee'
      @users = @relationship.cohort.mentees
    end
  end

  def update
  end
end
