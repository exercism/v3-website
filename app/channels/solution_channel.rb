class SolutionChannel < ApplicationCable::Channel
  def subscribed
    solution = Solution.find_by!(uuid: params[:id])

    stream_for solution
  end

  def unsubscribed; end

  def self.broadcast!(solution)
    broadcast_to solution,
      solution: SerializeSolutionForStudent.(solution),
      latest_iteration: SerializeIteration.(solution.latest_iteration)
  end
end
