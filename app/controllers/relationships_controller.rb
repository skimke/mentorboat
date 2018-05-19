class RelationshipsController < ApplicationController
  before_action :ensure_admin, only: [:pair, :update]

  def pair
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
    desired_users_hash = update_params.to_hash.values.reduce(&:merge)
    relationship = Relationship.find(params[:id])

    Relationship.transaction do
      relationship.update_attributes!(desired_users_hash)

      Relationship
        .where.not(id: relationship.id)
        .where(desired_users_hash.merge(
          cohort_id: relationship.cohort_id
        ))
        .delete_all
    end

    redirect_to cohort_path(relationship.cohort)
  end

  private

  def update_params
    params.permit(mentor: [:mentor_id], mentee: [:mentee_id])
  end
end
