class CommentsController < ApplicationController
  before_action :set_commentable, only: %i[create destroy]

  def show
    @comment = Comment.find(params[:id])
  end

  # DELETE /books/1/comments/1 or /books/1/comments/1.json
  def destroy
    @commentable.comments.find(params[:id]).destroy

    respond_to do |format|
      format.html { redirect_to @commentable, notice: t('controllers.common.notice_destroy', name: Comment.model_name.human) }
      format.json { head :no_content }
    end
  end

  # POST /comments or /comments.json
  def create
    @comment = @commentable.comments.create(comment_params)
    @comment.created_user_id = current_user.id
    if @comment.save
      redirect_to @commentable
    else
      format.html { render :new, status: :unprocessable_entity }
      format.json { render json: @comment.errors, status: :unprocessable_entity }
    end
  end

  private

  def set_commentable
    if params.key?(:report_id)
      @commentable = Report.find(params[:report_id])
    elsif params.key?(:book_id)
      @commentable = Book.find(params[:book_id])
    end
  end

  def comment_params
    params.require(:comment).permit(:created_user_id, :content)
  end
end
