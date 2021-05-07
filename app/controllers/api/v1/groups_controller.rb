class Api::V1::GroupsController < ApplicationController
  def create
    group = Group.create(group_params)
    render json: GroupSerializer.new(group)
  end

  def destroy
    Group.destroy(params[:id])
  end

  private

  def group_params
    params.permit(:name)
  end
end