class ScriptsController < ApplicationController
  def index
    @scripts = Script.all.order(
      Arel.sql("CASE
       WHEN completed = TRUE AND review = FALSE THEN 1
       WHEN completed = FALSE AND assigned = TRUE THEN 2
       WHEN completed = FALSE AND assigned = FALSE THEN 3
       WHEN completed = TRUE AND review = TRUE THEN 4
       ELSE 5
       END ASC")
    )
    @completed_scripts = @scripts.select { |script| script.completed }
    @completed_count = @completed_scripts.count
    @total_count = @scripts.count
    @assigned_scripts = @scripts.select { |script| script.assigned }
    @assigned_count = @assigned_scripts.count
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

  def review
    @script = Script.find(params[:id])
    if @script.user != current_user
      @script.update(review: true)
      flash[:notice] = "Script marked as reviewed."
    else
      flash[:alert] = "You cannot mark your own script as reviewed."
    end

    redirect_to scripts_path  # or render a dedicated view if desired
  end
end
