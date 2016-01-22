class SleepController < ApplicationController
	def show
	  @sleep = Sleep.first
	end
	def edit
		@sleep = Sleep.first
	end

	def update
	  @sleep = Sleep.first
	 
	  if @sleep.update(sleep_params)
	    redirect_to '/'
	  else
	    render 'edit'
	  end
	end

	private
	  def sleep_params
	    params.require(:sleep).permit(:period)
	  end
end

