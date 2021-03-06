class MeasurementGroupsController < ApplicationController
  before_filter :authenticate_user!

  def index
    #@measurement_groups = MeasurementGroup.all
    #@measurement_groups = @measurement_groups.paginate(:page => params[:page], :per_page => 5)
    @measurement_groups = MeasurementGroup.paginate(:page => params[:page], :per_page => 8)

    if params[:search]
      @measurement_groupsS = MeasurementGroup.search(params[:search]).order("name DESC")
      @measurement_groups = @measurement_groupsS.paginate(:page => params[:page], :per_page => 8)
    else
      @measurement_groups = MeasurementGroup.paginate(:page => params[:page], :per_page => 8)
    end

    @measurement_groupsAll = MeasurementGroup.all
    #@researchers = Researcher.paginate(:page => params[:page], :per_page => 8)
    respond_to do |format|
      format.html
      format.pdf do
        pdf = ReportMeasurementGroup.new(@measurement_groupsAll)
        send_data pdf.render, filename: 'report.pdf', type: 'application/pdf'
      end
    end

  end

  def new
    @measurement_group = MeasurementGroup.new
    @researcher = Researcher.all
    @sample = Sample.all
    @device = Device.all
  end

  def edit
  @measurement_group = MeasurementGroup.find(params[:id])
  end

  def show
    @measurement_group = MeasurementGroup.find(params[:id])
    if @measurement_group.researcherID != nil
      @researcher = Researcher.find(@measurement_group.researcherID)
    end
    if @measurement_group.deviceID != nil
      @device = Device.find(@measurement_group.deviceID)
    end
    if @measurement_group.sampleID != nil
      @sample = Sample.find(@measurement_group.sampleID)
    end
  end

  def create
    @measurement_group = MeasurementGroup.new(measurement_group_params)

    if @measurement_group.save
    redirect_to @measurement_group
    else
    render 'new'
    end
  end

  def update
  @measurement_group = MeasurementGroup.find(params[:id])

  if @measurement_group.update(measurement_group_params)
    redirect_to @measurement_group
  else
    render 'edit'
  end
  end

  def destroy
  @measurement_group = MeasurementGroup.find(params[:id])
  @measurement_group.destroy

  redirect_to measurement_groups_path
end



  private
  def measurement_group_params
    params.require(:measurement_group).permit(:sampleID, :researcherID, :deviceID, :name, :date)
  end
end


