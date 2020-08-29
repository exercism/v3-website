# Calls to this class are intercepted by the RoutingError
# on the API::BaseController. Routing to this file from the
# config/routes allows us to quickly spot all such routing
# errors in the logs.

module API
  class ErrorsController < BaseController
  end
end
