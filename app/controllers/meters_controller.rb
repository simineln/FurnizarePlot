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

  def hour
    @meter = Meter.find(params[:id])

    if params[:datepicker]
      daterange = params[:daterange].split("to")
      @readings = Reading.where(meter_id: @meter.id).where(date: daterange[0].to_date..daterange[-1].to_date + 1)
    else
      @readings = Reading.where(meter_id: @meter.id)
    end

    @aec_sum = [@readings.sum(:aec_p), @readings.sum(:aec_m)]
    @rec_sum = [@readings.sum(:rec_p), @readings.sum(:rec_m)]
    if @meter.inverted
      @aec_sum[0], @aec_sum[1] = @aec_sum[1], @aec_sum[0]
      @rec_sum[0], @rec_sum[1] = @rec_sum[1], @rec_sum[0]
    end


  end

  def day
    @meter = Meter.find(params[:id])

    if params[:datepicker]
      daterange = params[:daterange].split("to")
      @readings = Reading.where(meter_id: @meter.id).where(date: daterange[0].to_date..daterange[-1].to_date + 1)
    else
      @readings = Reading.where(meter_id: @meter.id)
    end
    
    @readingsDay = @readings.group_by_day(:date)

    @aec_sum = [@readings.sum(:aec_p), @readings.sum(:aec_m)]
    @rec_sum = [@readings.sum(:rec_p), @readings.sum(:rec_m)]

    # Generating hashes for sum values
    @aec = [@readingsDay.sum(:aec_p), @readingsDay.sum(:aec_m)]
    @rec = [@readingsDay.sum(:rec_p), @readingsDay.sum(:rec_m)]
    
    if @meter.inverted
      @aec[0], @aec[1] = @aec[1], @aec[0]
      @rec[0], @rec[1] = @rec[1], @rec[0]
      @aec_sum[0], @aec_sum[1] = @aec_sum[1], @aec_sum[0]
      @rec_sum[0], @rec_sum[1] = @rec_sum[1], @rec_sum[0]
    end
  end

  def month
   @meter = Meter.find(params[:id])

    if params[:datepicker]
      daterange = params[:daterange].split("to")
      @readings = Reading.where(meter_id: @meter.id).where(date: daterange[0].to_date..daterange[-1].to_date + 1)
    else
      @readings = Reading.where(meter_id: @meter.id)
    end
    
    @readingsMonth = @readings.group_by_month(:date)

    @aec_sum = [@readings.sum(:aec_p), @readings.sum(:aec_m)]
    @rec_sum = [@readings.sum(:rec_p), @readings.sum(:rec_m)]

    # Generating hashes for sum values
    @aec = [@readingsMonth.sum(:aec_p), @readingsMonth.sum(:aec_m)]
    @rec = [@readingsMonth.sum(:rec_p), @readingsMonth.sum(:rec_m)]
    
    if @meter.inverted
      @aec[0], @aec[1] = @aec[1], @aec[0]
      @rec[0], @rec[1] = @rec[1], @rec[0]
      @aec_sum[0], @aec_sum[1] = @aec_sum[1], @aec_sum[0]
      @rec_sum[0], @rec_sum[1] = @rec_sum[1], @rec_sum[0]
    end
  end

  private def meter_params
    params.require(:meter).permit(:name, :number, :nlc, :kt, :operator_id, :company_id, :inverted)
  end
end
