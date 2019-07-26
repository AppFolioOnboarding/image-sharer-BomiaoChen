class PostsController < ApplicationController
  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      flash[:notice] = 'Post successfully created'
      redirect_to post_path(@post)
    else
      flash.now[:error] = 'Image URL Invalid'
      render 'new'
    end
  end

  def show
    @post = Post.find_by(id: params[:id])
    if @post.nil?
      flash[:error] = 'Image not found'
      redirect_to new_post_path
    end
  end

  private

  def post_params
    params.require(:post).permit(:link, :caption)
  end
end
