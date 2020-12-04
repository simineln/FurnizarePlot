class MetersController < ApplicationController

  def index
    @operators = Operator.all
    @companies = Company.all
    @meters = Meter.all
  end

  def new
    @page_title = 'Add New Meter'
    @meter = Meter.new
  end

  def create
    @meter = Meter.new(meter_params)
    if @meter.save
      flash[:notice] = 'Meter Created'
      redirect_to meters_path
    else
      render 'new'
    end
  end

  def edit
    @meter = Meter.find(params[:id])
  end

  def update
    @meter = Meter.find(params[:id])
    if @meter.update(meter_params)
      flash[:notice] = 'Meter Updated'
      redirect_to meters_path
    else
      render 'new'
    end
  end

  def destroy
    @meter = Meter.find(params[:id])
    @meter.destroy
    flash[:alert] = 'Meter Removed'
    redirect_to meters_path
  end

  def day
    @meter = Meter.find(params[:id])

    if params[:datepicker]
      daterange = params[:daterange].split("to")
      @readings_plot = Reading.where(meter_id: @meter.id).where(date: daterange[0].to_date..daterange[-1].to_date + 1)
      @readings = Reading.where(meter_id: @meter.id).where(date: daterange[0].to_date..daterange[-1].to_date + 1).group_by_day(:date)

    else
      @readings_plot = Reading.where(meter_id: @meter.id)
      @readings = Reading.where(meter_id: @meter.id).group_by_day(:date)

    end
  end

  def hour
    @meter = Meter.find(params[:id])

    if params[:datepicker]
      daterange = params[:daterange].split("to")
      @readings = Reading.where(meter_id: @meter.id).where(date: daterange[0].to_date..daterange[-1].to_date + 1)
    else
      @readings = Reading.where(meter_id: @meter.id)
    end
  end

  private def meter_params
    params.require(:meter).permit(:name, :number, :nlc, :kt, :operator_id, :company_id)
  end
end
