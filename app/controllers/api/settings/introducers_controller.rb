module API
  module Settings
    class IntroducersController < BaseController
      # TODO: This is just a temporary implementation
      def hide
        session[:hidden_introducers] = (session[:hidden_introducers] || []).concat([params[:id]])

        render json: {}
      end
    end
  end
end
