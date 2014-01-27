class PlayingsController < ApplicationController
  include AwsHelper

  before_filter :authenticate_user!, :only => [:destroy, :edit, :update]

  # GET /playings
  # GET /playings.json
  def index
    @playings = Playing.order(:created_at).reverse_order.all

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
      format.html { render locals: { short_url: short_link_to(@playing.id) } }
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
    @playing = current_user.playing.find(params[:id])
  end

  # POST /playings
  # POST /playings.json
  def create
    @playing = Playing.new(playing_params)
    photo = URI.unescape(playing_params[:remote_photo_url] || "")
    logger.debug("Uploaded photo URL: #{photo}")
    #@playing.raw_write_attribute(:photo, URI.unescape(playing_params[:photo]))
    @playing.session_token = session[:session_token]

    if user_signed_in?
      @playing.user = current_user
    end

    respond_to do |format|
      if @playing.save
        format.html { redirect_to @playing, notice: 'Thank you for playing!' }
        format.json { render json: @playing, status: :created, location: @playing }
      else
        format.html { render action: "new" }
        format.json { render json: @playing.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /playings/1
  # PUT /playings/1.json
  def update
    @playing = current_user.playing.find(params[:id])

    respond_to do |format|
      if @playing.update_attributes(playing_params)
        format.html { redirect_to @playing, notice: 'Playing was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @playing.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /playings/1
  # DELETE /playings/1.json
  def destroy
    @playing = current_user.playing.find(params[:id])
    @playing.destroy

    respond_to do |format|
      format.html { redirect_to playings_url }
      format.json { head :no_content }
    end
  end

  private

  def playing_params
    params.require(:playing).permit(:content, :game, :location, :latitude, :longitude,
                                    :photo, :photo_cache, :remote_photo_url)
  end

  def short_link_to(id)
    ['http://', request.host, '/!', Radix62.encode(id)].join
  end

  def extract_id_from(encoded_id)
    Radix62.decode(encoded_id)
  end
end
