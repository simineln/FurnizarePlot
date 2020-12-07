class CompaniesController < ApplicationController

  def index
    @companies = Company.all
  end

  def new
    @page_title = 'Add New Company'
    @company = Company.new
  end

  def create
    @company = Company.new(company_params)
    if @company.save
      flash[:notice] = 'Company Created'
      redirect_to meters_path
    else
      render 'new'
    end
  end

  def edit
    @company = Company.find(params[:id])
  end

  def update
    @company = Company.find(params[:id])
    if @company.update(company_params)
      flash[:notice] = 'Company Updated'
      redirect_to meters_path
    else
      render 'new'
    end
  end

  def destroy
    @company = Company.find(params[:id])
    @company.destroy
    flash[:alert] = 'Company Removed'
    redirect_to meters_path
  end


  def hour
    @company = Company.find(params[:id])
    @meters = Meter.where(company_id: @company.id)
    metersID = @meters.distinct.pluck(:id)  # array with meters IDs

    if params[:datepicker]
      daterange = params[:daterange].split("to")
      @readings = Reading.where(meter_id: metersID).where(date: daterange[0].to_date..daterange[-1].to_date + 1)
    else
      @readings = Reading.where(meter_id: metersID)
    end
  end

  def day
    @company = Company.find(params[:id])
    @meters = Meter.where(company_id: @company.id)
    metersID = @meters.distinct.pluck(:id)  # array with meters IDs

    if params[:datepicker]
      daterange = params[:daterange].split("to")
      @readings = Reading.where(meter_id: metersID).where(date: daterange[0].to_date..daterange[-1].to_date + 1)

      # Generating hashes for sum values and plots
      @readingsDay = @readings.group_by_day(:date)
      @aec_p = @readingsDay.sum(:aec_p)
      @aec_m = @readingsDay.sum(:aec_m)
      @rec_p = @readingsDay.sum(:rec_p)
      @rec_m = @readingsDay.sum(:rec_m)
    else
      @readings = Reading.where(meter_id: metersID)

      # Generating hashes for sum values and plots
      @readingsDay = @readings.group_by_day(:date)
      @aec_p = @readingsDay.sum(:aec_p)
      @aec_m = @readingsDay.sum(:aec_m)
      @rec_p = @readingsDay.sum(:rec_p)
      @rec_m = @readingsDay.sum(:rec_m)
    end
  end

  def month

  end


  private def company_params
    params.require(:company).permit(:name, :address, :description)
  end
end
