class PlayingsController < ApplicationController
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
    @playing = Playing.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
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
  end

  # POST /playings
  # POST /playings.json
  def create
    @playing = Playing.new(params[:playing])

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
    @playing = Playing.find(params[:id])

    respond_to do |format|
      if @playing.update_attributes(params[:playing])
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
    @playing = Playing.find(params[:id])
    @playing.destroy

    respond_to do |format|
      format.html { redirect_to playings_url }
      format.json { head :no_content }
    end
  end
end
