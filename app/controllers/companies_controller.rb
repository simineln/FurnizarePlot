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

    if params[:datepicker]
      daterange = params[:daterange].split("to")
      @readings = Reading.where(meter_id: @meters[0].id).where(date: daterange[0].to_date..daterange[-1].to_date + 1)
    else
      @readings = Reading.where(meter_id: @meters[0].id)
    end

  end

  def day
    @company = Company.find(params[:id])
    @meters = Meter.where(company_id: @company.id)

    if params[:datepicker]
      daterange = params[:daterange].split("to")
      @readings_plot = Reading.where(meter_id: @meters[0].id).where(date: daterange[0].to_date..daterange[-1].to_date + 1)
      @readings = Reading.where(meter_id: @meters[0].id).where(date: daterange[0].to_date..daterange[-1].to_date + 1).group_by_day(:date)

    else
      @readings_plot = Reading.where(meter_id: @meters[0].id)
      @readings = Reading.where(meter_id: @meters[0].id).group_by_day(:date)

    end

  end

  private def company_params
    params.require(:company).permit(:name, :address, :description)
  end
end
