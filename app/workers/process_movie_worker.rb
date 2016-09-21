class ProcessMovieWorker < ::CarrierWave::Workers::StoreAsset
  def perform(*args)
    set_args(*args) if args.present?
    @movie = constantized_resource.find(id)
    @movie.process!
    super(*args)
    @movie.reload
    @movie.done!
  rescue Exception => e
    @movie.fails!
  end
end
