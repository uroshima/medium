class Api::StoriesController < ApplicationController

  before_action :require_logged_in, only: [:create, :update, :destroy]

  def index
    @stories = Story.all

    render :index
  end

  def create
    @story = Story.new(story_params)
    @story.author_id = current_user.id

    if @story.save
      render :show
    else
      render json: @story.errors.full_messages, status: 422
    end
  end

  def show
    @story = Story.find(params[:id])

    if @story
      render :show
    else
      render json: ["Story doesn't exist"], status: 404
    end
  end

  def update
    @story = current_user.authored_stories(id: params[:id])

    if @story
      if @story.update(story_params)
        render :show
      else
        render json: @story.errors.full_messages, status: 422
      end
    else
      render json: ["Can't update this story"], status: 401
    end
  end

  def destroy
    @story = current_user.authored_stories(id: params[:id])

    if @story
      @story.destroy
      render :show
    else
      render json: ["Can't destroy this story"], status: 401
    end
  end

  private

  def story_params
    params.require(:story).permit(:title, :subtitle, :content, :photo)
  end
end