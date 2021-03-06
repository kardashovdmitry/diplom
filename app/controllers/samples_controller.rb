class SamplesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @samples = Sample.paginate(:page => params[:page], :per_page => 8)

    if params[:search]
      @samplesS = Sample.search(params[:search])
      @samples = @samplesS.paginate(:page => params[:page], :per_page => 8)
    else
      @samples = Sample.paginate(:page => params[:page], :per_page => 8)
    end

    @samplesAll = Sample.all
    respond_to do |format|
      format.html
      format.pdf do

        pdf = ReportSample.new(@samplesAll)
        send_data pdf.render, filename: 'report.pdf', type: 'application/pdf'
      end
    end
  end

  def new
    @sample = Sample.new
  end

  def edit
  @sample = Sample.find(params[:id])
  end

  def show
    @sample = Sample.find(params[:id])
  end

  def create
    @sample = Sample.new(sample_params)

    if @sample.save
    redirect_to @sample
    else
    render 'new'
    end
  end

  def update
  @sample = Sample.find(params[:id])

  if @sample.update(sample_params)
    redirect_to @sample
  else
    render 'edit'
  end
  end

  def destroy
  @sample = Sample.find(params[:id])
  @sample.destroy

  redirect_to samples_path
end



  private
  def sample_params
    params.require(:sample).permit(:name, :weight, :size, :M, :lambda_em, :lambda_ex,
                                                        :description)
  end
end




