class PostsController < ApplicationController
  before_action :set_post, only: %i[show edit update destroy]

  def index
    @posts = Post.includes(:user).order(created_at: :desc).page params[:page]
  end

  def show; end

  def new
    @post = current_user.posts.new
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      flash[:success] = 'Ваш пост опубликован!'
      redirect_to post_path(@post)
    else
      flash.now[:alert] = 'Ваш новый пост не создан! Пожалуйста, проверьте форму.'
      render :new
    end
  end

  def edit
    authorize @post
  end

  def update
    authorize @post

    if @post.update(post_params)
      flash[:success] = 'Пост обновлен.'
      redirect_to post_path(@post)
    else
      flash.now[:alert] = 'Ошибка обновления. Пожалуйста, проверьте форму.'
      render :edit
    end
  end

  def destroy
    authorize @post
    
    if @post.destroy
      flash[:success] = 'Пост удален.'
    else
      flash.now[:alert] = 'Ошибка удаления. Пожалуйста, попробуйте еще раз.'
    end
    redirect_to root_path
  end

  private

  def post_params
    params.require(:post).permit(:description, :image, :user_id)
  end

  def set_post
    @post = Post.find(params[:id])
  end
end
