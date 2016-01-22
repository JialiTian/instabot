class KeywordsController < ApplicationController
before_action :require_user, only: [:index, :show, :new, :create, :edit, :destroy]
	def index
    @keywords = Keyword.all
  end
	def show
	  @keyword = Keyword.find(params[:id])
	end

	def new
	end

	def create
		@keyword = Keyword.new(params.require(:keyword).permit(:text)) 
		@keyword.save
		redirect_to '/'
	end

	def edit
		@keyword = Keyword.find(params[:id])
	end

	def update
	  @keyword = Keyword.find(params[:id])
	 
	  if @keyword.update(keyword_params)
	    redirect_to '/'
	  else
	    render 'edit'
	  end
	end

  def destroy 
	  keyword = Keyword.find(params[:id])
	  keyword.destroy
	  redirect_to '/' 
	end

	private
	  def keyword_params
	    params.require(:keyword).permit(:text)
	  end
end
