class Tracks::ExercisesController < ApplicationController
  before_action :use_track
  before_action :use_exercise, only: %i[show start edit complete]
  before_action :use_solution, only: %i[show edit complete]

  skip_before_action :authenticate_user!, only: %i[index show]
  disable_site_header! only: [:edit]

  def index
    # TODO: - Sort by whether exercise is started, available, completed.
    @exercises = @track.exercises
    @num_completed = @user_track.num_completed_exercises
  end

  # TODO: There is lots of logic in this view
  # that should be extracted into a view model
  # to allow for pre-caching of solution data
  def show
    @iteration = @solution.iterations.last if @solution
  end

  def start
    Solution::Create.(current_user, @exercise)
    redirect_to action: :edit
  end

  def edit; end

  # TODO: Delete when this is working via the API
  def complete
    Solution::Complete.(@solution, @user_track)
    redirect_to action: :show
  end

  # TODO: Remove
  def completed
    use_exercise
    use_track

    if @exercise.concept_exercise?
      @concepts = @exercise.taught_concepts
      @unlocked_concepts = [] # TODO
      @unlocked_exercises = [] # TODO
    else
      @concepts = @exercise.prerequisites
    end

    @unlocked_exercises = @track.exercises.limit(2)
    @unlocked_concepts = @track.concepts.limit(2)
  end

  # TODO: Remove
  def publish
    use_exercise
    use_solution
    use_track

    @iterations = @solution.iterations
  end

  private
  def use_track
    @track = Track.find(params[:track_id])
    @user_track = UserTrack.for(current_user, @track, external_if_missing: true)
  end

  def use_exercise
    @exercise = @track.exercises.find(params[:id])
  end

  def use_solution
    @solution = Solution.for(current_user, @exercise)
  end
end
