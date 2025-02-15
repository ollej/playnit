class PlayingsController < ApplicationController
  include AwsHelper

  before_action :authenticate_user!, :only => [:destroy, :edit, :update]
  before_action :spammenot!, :only => [:create, :update]

  # GET /playings
  # GET /playings.json
  def index
    limit = params.fetch(:limit, 10).to_i
    @playings = Playing.order(:created_at).reverse_order.limit(limit)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @playings }
    end
  end

  # GET /playings/1
  # GET /playings/1.json
  def show
    id = params[:id] || extract_id_from(params[:encoded_id])
    @playing = Playing.find(id)

    respond_to do |format|
      format.html { render locals: { short_url: short_link_to(@playing) } }
      format.json { render json: @playing }
    end
  end

  # GET /playings/new
  # GET /playings/new.json
  def new
    @playing = Playing.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @playing }
    end
  end

  # GET /playings/1/edit
  def edit
    @playing = Playing.find(params[:id])
    respond_to do |format|
      if current_user.can_modify?(@playing)
        format.html # edit.html.erb
      else
        format.html { redirect_to root_url, status: :forbidden, alert: 'Not allowed' }
      end
    end
  end

  # POST /playings
  # POST /playings.json
  def create
    @playing = Playing.new(playing_params)
    photo = URI::Parser.new.unescape(playing_params[:remote_photo_url] || "")
    logger.debug("Uploaded photo URL: #{photo}")
    #@playing.raw_write_attribute(:photo, URI.unescape(playing_params[:photo]))
    @playing.session_token = session[:session_token]

    if user_signed_in?
      @playing.user = current_user
    end

    respond_to do |format|
      if @playing.save
        format.html { redirect_to @playing, notice: 'Thank you for playing!', status: :see_other }
        format.json { render json: @playing, status: :created, location: @playing }
      else
        format.html { render action: "new", status: :unprocessable_entity }
        format.json { render json: @playing.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /playings/1
  # PUT /playings/1.json
  def update
    @playing = Playing.find(params[:id])
    unless current_user.can_modify?(@playing)
      respond_to do |format|
        format.html { redirect_to @playing, status: :forbidden, alert: 'Not allowed' }
        format.json { render json: { error: 'Not allowed' }, status: :forbidden }
      end
    else
      respond_to do |format|
        if @playing.update(playing_params)
          format.html { redirect_to @playing, notice: 'Playing was successfully updated.', status: :see_other }
          format.json { head :no_content }
        else
          format.html { redirect_to edit_playing_path(@playing), status: :unprocessable_entity, alert: "Could not delete playing: #{@playing.errors.to_sentence}" }
          format.json { render json: @playing.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /playings/1
  # DELETE /playings/1.json
  def destroy
    @playing = Playing.find(params[:id])
    unless current_user.can_modify?(@playing)
      render status: :forbidden
    else
      respond_to do |format|
        if @playing.destroy
          format.html { redirect_to playings_url, notice: "#{@playing.game} checkin deleted", status: :see_other }
          format.json { head :no_content }
        else
          format.html { render action: "edit", status: :unprocessable_entity }
          format.json { render json: @playing.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  private

  def playing_params
    params.require(:playing).permit(:content, :game, :location, :latitude, :longitude,
                                    :photo, :photo_cache, :remote_photo_url, :bgg_id)
  end

  def spammenot!
    raise if params[:spammenot].present?
  end

  def short_link_to(playing)
    ['http://', request.host, playing.short_id].join
  end

  def extract_id_from(encoded_id)
    Radix62.decode(encoded_id)
  end
end
