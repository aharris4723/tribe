class CommentsController < ApplicationController
def index
        @comments = Comment.all
    end

    def new
      
        @event = Event.find(params[:id])
        @comment = Comment.new
    end

    def create 
     	# event = Event.find(params[:id])       
        comment = Comment.new(comment_params)      
        comment.user_id = current_user.id
       
       
        if comment.save
            flash[:message] = 'Your comment was posted'
            redirect_to "/events/#{comment.event_id}"
        else
            flash[:message] = 'try again'
            render 'comments/new'
        end
    end

    def show
    	@event = Event.find_by_id(params[:id])
        @comment = Comment.find_by_id(params[:id])
    end

    def edit
        @comment = Comment.find_by_id(params[:id])
    end

    def update
        @comment = Comment.find(params[:id])
        @event = Event.find_by_id(params[:id])
        if @comment.update(comment_params)
            flash[:message] = 'Your comment was edited'
            redirect_to "/events"
        else
            flash[:message] = 'try again'
            render "/comments/#{@comment.id}/edit"
        end
    end

    def destroy
        @event = Event.find_by_id(params[:id])
        @comment = Comment.find(params[:id])
        @comment.destroy
        redirect_to events_path
    end

private

def comment_params
    params.require(:comment).permit(:content, :user_id, :event_id)
end



end
