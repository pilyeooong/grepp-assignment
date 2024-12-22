class ApplicationController < ActionController::API
  include JsonResponse

  rescue_from Errors::Forbidden, with: :handle_error
  rescue_from Errors::InvalidRequest, with: :handle_error
  rescue_from Errors::NotExist, with: :handle_error
  rescue_from Exception, with: :handle_error

  def handle_error(e)
    error_message = e.message + "\n" + e.backtrace.join("\n")
    Rails.logger.error(error_message)

    render_error(e)
  end
end
