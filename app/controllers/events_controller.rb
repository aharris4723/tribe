class EventsController < ApplicationController
  


  def index
    @event = Event.new
    @events = Event.all
  
  end

  def show
   @comments = Comment.all
   @comment = Comment.new  
   @event = Event.find(params[:id])
   
  end

 
  def new
    @event = Event.new
    
  end

 
  def edit
  end

  
  def create
    @event = Event.new(event_params)
    @event.user_id = current_user.id

    if @event.save
      redirect_to events_path
    else 
      render new_event_path
    end
  end

 
  def update
    respond_to do |format|
      if @event.update(event_params)
        flash[:notice] = 'Your event was created successfully.'
			redirect_to '/events'
		else
      flash[:alert] = 'Sorry, please try again.'  
			render new_event_path
      end
    end
  


  def destroy
   @comment = Comment.find(params[:id])
   @comment.destroy
        redirect_to "/comments/#{comment.post_id}"
    @event.destroy
     flash[:alert] = 'you have deleted this event.'
    
    end
  end

  private

    def event_params
      params.require(:event).permit(:name, :title, :content, :user_id)
    end
end
