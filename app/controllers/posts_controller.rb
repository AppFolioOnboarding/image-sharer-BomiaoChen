class PostsController < ApplicationController
  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      flash[:notice] = 'Post successfully created'
      head :ok
    else
      flash.now[:error] = 'Image URL Invalid'
      render 'new'
    end
  end

  private

  def post_params
    params.require(:post).permit(:link, :caption)
  end
end
