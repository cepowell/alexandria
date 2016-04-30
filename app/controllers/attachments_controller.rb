class AttachmentsController < ApplicationController
  def index
    @attachments = Attachment.order('created_at')
  end
  
  def new
    @attachment = Attachment.new
  end

  def create
    @attachment = Attachment.create(:file => params[:attachment][:file], :document_id => params[:attachment][:document_id], :user_id => params[:attachment][:user_id])
    if @attachment.save
      flash[:notice] = "The attachment was added!"
      redirect_to request.referrer
    else
      flash[:alert] = "The upload could not be completed. Please try again."
    end
  end
  
  def destroy
    @attachment = Attachment.find(params[:id])
    @attachment.destroy
    flash[:notice] = "Attachment '#{@attachment.name}' deleted."
    redirect_to request.referrer
  end
  
end