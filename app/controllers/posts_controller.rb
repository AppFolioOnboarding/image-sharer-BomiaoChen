class PostsController < ApplicationController
  before_action :valid_post, only: %i[show destroy]

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      flash[:notice] = 'Post successfully created'
      redirect_to posts_path
    else
      flash.now[:error] = 'Image URL Invalid'
      render 'new'
    end
  end

  def show; end

  def index
    @posts = Post.all.reverse
    @title = 'All Images'

    return if params[:tag].blank?

    @posts = Post.tagged_with(params[:tag]).reverse
    @title = 'Filtered Images'

    return if @posts.present?

    flash[:error] = 'Tag not found'
    redirect_to posts_path
  end

  def destroy
    @post.destroy
    flash[:notice] = 'Image deleted'
    redirect_to posts_path
  end

  private

  def post_params
    params.require(:post).permit(:link, :caption, :tag_list)
  end

  def valid_post
    @post = Post.find_by(id: params[:id])

    return if @post.present?

    flash[:error] = 'Image not found'
    redirect_to new_post_path
  end
end
