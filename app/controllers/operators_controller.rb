class OperatorsController < ApplicationController
  def index
    @operators = Operator.all
  end

  def new
    @page_title = 'Add New Operator'
    @operator = Operator.new
  end

  def create
    @operator = Operator.new(operator_params)
    if @operator.save
      flash[:notice] = 'Operator Created'
      redirect_to meters_path
    else
      render 'new'
    end
  end

  def edit
    @operator = Operator.find(params[:id])
  end

  def update
    @operator = Operator.find(params[:id])
    if @operator.update(operator_params)
      flash[:notice] = 'Operator Updated'
      redirect_to meters_path
    else
      render 'new'
    end
  end

  def destroy
    @operator = Operator.find(params[:id])
    @operator.destroy
    flash[:alert] = 'Operator Removed'
    redirect_to meters_path
  end

  private def operator_params
    params.require(:operator).permit(:name, :description)
  end
end
