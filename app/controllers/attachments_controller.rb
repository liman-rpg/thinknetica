class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_attachment, only: [:destroy]

  def destroy
    @attachment.destroy if current_user.author_of?(@attachment.attachable)
  end

  private

  def load_attachment
    @attachment = Attachment.find(params[:id])
  end
end
