class ScriptsController < ApplicationController
  def index
    @scripts = Script.all.order("Completed ASC")
  end

  def show
  end

  def assign
    # This query assumes you are using PostgreSQL. For MySQL, use "RAND()" instead of "RANDOM()"
    @script = Script.where(user_id: nil, completed: false).order("RANDOM()").first
    if Script.where(user: current_user, completed: false).exists?
      flash[:alert] = "You already have an assigned script."
    elsif @script
      @script.update(user: current_user)
      @script.update(assigned: true)
      flash[:notice] = "Script assigned: #{@script.name}"
    else
      flash[:alert] = "No unassigned scripts available."
    end

    redirect_to scripts_path  # or render a dedicated view if desired
  end

  def complete
    @script = Script.find(params[:id])
    if @script.user == current_user
      @script.update(completed: true)
      flash[:notice] = "Script marked as completed."
    else
      flash[:alert] = "You cannot complete this script."
    end

    redirect_to scripts_path  # or render a dedicated view if desired
  end
end
