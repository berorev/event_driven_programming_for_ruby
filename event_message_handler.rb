class EventMessageHandler
  def initialize
    @handlers = []
  end

  def onmessage(&blk)
    @handlers << blk
  end

  def handle(msg)
    @handlers.each do |h|
      h.call(msg)
    end
  end
end