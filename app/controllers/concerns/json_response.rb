module JsonResponse
  extend ActiveSupport::Concern

  def render_json(data: {}, status: :ok, message: nil)
    response = { data: data }
    response[:message] = message if message.present?
    render json: response, status: status
  end

  def render_error(error)
    render json: { error: { message: error.message } }, status: error.try(:code) || 500
  end
end
