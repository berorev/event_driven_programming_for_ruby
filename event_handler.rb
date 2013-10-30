class EventHandler
  def initialize
    @events = Hash.new { |h, k| h[k] = [] }
  end
  
  def on(event_key, &blk)
    @events[event_key] << blk
  end
  
  def emit(event_key, *args)
    @events[event_key].each do |blk|
      blk.call(*args)
    end
  end
end