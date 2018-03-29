class EventsController < ApplicationController
  


  def index
    @event = Event.new
    @events = Event.all
  
  end

  def show
   @comments = Comment.all
   @comment = Comment.new  
   @event = Event.find(params[:id])
   if session[:authorization] == nil
        else
            client = Signet::OAuth2::Client.new(client_options)
            client.update!(session[:authorization])
            tokenRefresh
            service = Google::Apis::CalendarV3::CalendarService.new
            service.authorization = client
            if service.authorization.expires_at < Time.now 
            else 
                @calendar_list = service.list_calendar_lists
                @test = @calendar_list.items.first.id 
            end 

   end
  end

 
  def new
    @event = Event.new
    
  end
  def redirect
    client = Signet::OAuth2::Client.new(client_options)

    redirect_to client.authorization_uri.to_s
  end
   def callback
         client = Signet::OAuth2::Client.new(client_options)
         client.code = params[:code]
         response = client.fetch_access_token!
         
         session[:authorization] = response
         session[:authorization][:code] = params[:code]
         redirect_to "/events/#{current_user.id}"
     end 
   
    def calendars
    client = Signet::OAuth2::Client.new(client_options)
    client.update!(session[:authorization])

    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = client

    @calendar_list = service.list_calendar_lists
    rescue Google::Apis::AuthorizationError
    response = client.refresh!

    session[:authorization] = session[:authorization].merge(response)

    retry
  
   end 
    def events
    client = Signet::OAuth2::Client.new(client_options)
    client.update!(session[:authorization])

    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = client

    @event_list = service.list_events(params[:calendar_id])
  end
  def new_event
    client = Signet::OAuth2::Client.new(client_options)
    client.update!(session[:authorization])

    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = client

    today = Date.today

    event = Google::Apis::CalendarV3::Event.new({
      start: Google::Apis::CalendarV3::EventDateTime.new(date: today),
      end: Google::Apis::CalendarV3::EventDateTime.new(date: today + 1),
      summary: 'New event!'
    })

    service.insert_event(params[:calendar_id], event)

    redirect_to events_url(calendar_id: params[:calendar_id])
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
  def client_options
    {
      client_id: Rails.application.secrets.google_client_id,
      client_secret: Rails.application.secrets.google_client_secret,
      authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
      token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
      scope: Google::Apis::CalendarV3::AUTH_CALENDAR,
      redirect_uri: 'http://localhost:3000/callback'
    }
  end

    def event_params
      params.require(:event).permit(:name, :title, :content, :user_id)
    end
end
